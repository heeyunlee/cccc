# %%
import pytesseract
import cv2
import numpy as np
import requests
import re
import uuid
from collections import Counter
import flask
from flask import make_response, jsonify
import json
import pandas as pd
from string import punctuation


# %%
def get_image(url: str):
    # Read Images from URL
    raw = requests.get(url, stream=True).raw
    image = np.asarray(bytearray(raw.read()), dtype="uint8")
    image = cv2.imdecode(image, cv2.IMREAD_GRAYSCALE)

    # # Read Data from files
    # path = 'dataset/1{}-receipt.jpg'.format(str(7).zfill(3))
    # image=cv2.imread(path,cv2.IMREAD_GRAYSCALE)

    return image

# %%


def process_image(image):
    # cv2.imwrite('original.jpg', image)

    rgb_planes = cv2.split(image)
    result_norm_planes = []

    for plane in rgb_planes:
        dilated_image = cv2.dilate(plane, np.ones((15, 15), np.uint8))
        blurred_image = cv2.medianBlur(dilated_image, 27)
        diff_image = 255 - cv2.absdiff(image, blurred_image)
        norm_image = cv2.normalize(
            diff_image, diff_image, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1)

        result_norm_planes.append(norm_image)

    result_norm = cv2.merge(result_norm_planes)
    thres_image = cv2.threshold(
        result_norm, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
    # cv2.imwrite('final.jpg', thres_image)

    return thres_image

# %%


def recognize_text(url: str):

    image = get_image(url)
    image = process_image(image)

    # Get Text using pytesseract
    raw_text: str = (pytesseract.image_to_string(image)).lower()

    # Find all the prices data
    prices = re.findall(r'\d+[.]\d+', raw_text)
    prices = [float(x) for x in prices]

    # Find the max price, which should be the total
    if len(prices) != 0:
        max_price = max(prices)
    else:
        max_price = None

    # Find the prices that are NOT total AND NOT 0
    prices_filtered = [x for x in prices if x != 0 and x != max_price]

    return (max_price, prices_filtered, raw_text)


# %%
def find_combination(candidates: list, target: float or None):
    print(f'target is {target}')

    if target is None:
        return None

    # remain: what remains to be substracted
    # comb: list of numbers that potentially adds up to k
    # next_start:
    def backtrack(remain: float, comb: list, current_index: int, counter: list, results: list):
        if remain == 0:
            results.append(list(comb))
            return
        elif remain < 0:
            return

        # Iterate through the reduced list of candidates.
        for i in range(current_index, len(counter)):
            candidate, freq = counter[i]

            # if freq is less than 0, go to next i
            if freq <= 0:
                continue

            comb.append(candidate)

            counter[i] = (candidate, freq - 1)

            backtrack(round(remain - candidate, 2), comb, i, counter, results)

            # if the function above returns, backtrak.
            counter[i] = (candidate, freq)
            comb.pop()

    counter = Counter(candidates)
    counter = [(c, counter[c]) for c in counter]

    results = []

    backtrack(target, [], 0, counter, results)

    return results

# %%


def get_items(receipt_id: str, raw_texts: str, item_prices: list or None):
    if item_prices is None or len(item_prices) == 0:
        return

    line_by_line = raw_texts.split('\n')

    items_list = []

    for item in item_prices:
        transaction_item: dict = {
            'transactionItemId': str(uuid.uuid4()),
            'transactionId': 'transaction_id',
            'amount': item,
            'isoCurrencyCode': 'US',
            'receiptId': receipt_id,
        }

        item_str = str(item)
        name = [x for x in line_by_line if item_str in x]

        if name is None:
            transaction_item['name'] = 'No Name Yet'
            transaction_item['type'] = 'others'
        else:
            name = name[0]
            name = re.sub("[^-9A-Za-z ]", "", name)
            name = name.strip()
            transaction_item['name'] = 'name'
            transaction_item['type'] = 'item'

        items_list.append(transaction_item)

    return items_list

# %%


def update_transaction_with_image(request: flask.Request):

    # Load request data
    data = request.get_data()
    data_decoded = data.decode('UTF-8')
    data_dict = json.loads(data_decoded)
    uid = data_dict['uid']
    url = data_dict['url']

    receipt_id = str(uuid.uuid4())

    max_price, prices, raw_text = recognize_text(url)

    print(f'''
    Max Price = {max_price}
    All the Prices = {prices}
    raw Text = {raw_text}
    ''')

    combinations = find_combination(prices, max_price)
    print(f'Combinations {combinations}')

    items = get_items(receipt_id, raw_text, combinations)
    print(f'Items are {items}')

# %%


def find_description(texts_dict: dict, target_prices: list):
    if len(target_prices) == 0:
        return

    texts_series = pd.Series(texts_dict)

    processsed_descriptions = []

    for price in target_prices:
        price_str = str(price)

        keys = [x for x in texts_dict.keys() if price_str in x]
        key = keys[0]
        key_position = texts_dict[key]

        indexes = np.where((texts_series.values > key_position * 0.95)
                           & (texts_series.values < key_position * 1.05))

        descriptions: pd.Series = texts_series.iloc[indexes]
        description = ', '.join(descriptions.index.values)
        description_clean = description.strip(key)
        description_clean = re.sub(
            f'[{re.escape(punctuation)}]', '', description_clean)
        description_clean = re.sub(r"\b[0-9]+\b\s*", "", description_clean)

        processsed_descriptions.append(description_clean)

    return processsed_descriptions

# %%


def process_receipt_texts(request: flask.Request):
    print('process_receipt_texts function started')

    try:

        # Load request data
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict: dict[str, ] = json.loads(data_decoded)

        raw_text: str = data_dict['raw_texts']
        # print(f'''raw texts: {raw_text}''')

        texts_with_position: dict = data_dict['texts_with_position']
        print(f'texts_with_position {texts_with_position}')

        max_price, filtered_price = recognize_text(raw_text)
        print(f'Max Price: {max_price} \nFiltered Price: {filtered_price}')

        target_prices = find_combination(max_price, filtered_price)
        print(f'target_prices is {target_prices}')

        descriptions = find_description(texts_with_position, target_prices)
        print(f'Descriptions are {descriptions}')

        transaction_items = []
        receipt_id = str(uuid.uuid4())

        for i in len(target_prices):
            id = str(uuid.uuid4())

            if 'tax' in descriptions[i]:
                type = 'tax'
            elif 'tip' in descriptions[i]:
                type = 'tip'
            else:
                type = 'subtotal'

            item: dict = {
                'name': descriptions[i],
                'transactionItemId': id,
                'amount': target_prices[i],
                'isoCurrencyCode': 'US',
                'receiptId': receipt_id,
                'type': type,
            }

            transaction_items.append(item)

        # Total dictionary
        total: dict = {
            'name': 'Total',
            'transactionItemId': str(uuid.uuid4()),
            'amount': max_price,
            'isoCurrencyCode': 'US',
            'receiptId': receipt_id,
            'type': 'subtotal',
        }

        transaction_items.append(total)

        response = jsonify(transaction_items=transaction_items)

        print('process_receipt_texts function ended')

        return make_response(response, 200)
    except Exception as e:
        print(f'process_receipt_texts function ended with error {e}')

        return make_response(jsonify('An Error Occurred'), 404)
