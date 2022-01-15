import numpy as np
import re
import uuid
from collections import Counter
import flask
from flask import make_response, jsonify
import pandas as pd
from string import punctuation
import dateutil.parser as parser
import datetime
import json


def recognize_text(raw_texts: str, texts_with_offsets: list) -> dict:
    print('\n[recognize_text] function called')

    # 1. Find average left top offset
    left_top_dxs = [x['points'][0][0] for x in texts_with_offsets]
    average_left_top_position = np.mean(left_top_dxs)
    print(f'1. average_left_top_position= {average_left_top_position}')

    result = {}

    # 2. Find the Prices
    prices = [re.findall(r'\d+[.]\d+', x['text']) for x in texts_with_offsets]
    prices = [''.join(x) for x in prices]
    print(f'2. All the found prices {prices}')

    # 3. Create a new list of dictionaries that include price and offset
    prices_dict_list = []

    for i in range(len(prices)):
        price = prices[i]
        left_top_dx = left_top_dxs[i]
        offset = texts_with_offsets[i]['points']

        if price != '' and left_top_dx > average_left_top_position:
            prices_dict_list.append({'price': price, 'offset': offset})

    print(f'3. Prices dict list: {prices_dict_list}')
    result['prices_dict_list'] = prices_dict_list

    # 4. Find all the prices
    prices = [float(x['price']) for x in prices_dict_list]
    result['prices'] = prices
    print(f'4. All the found prices: {prices}')

    # 5. Find the max price, which should be the total
    if len(prices) != 0:
        max_price = max(prices)
    else:
        max_price = None

    result['max_price'] = max_price
    print(f'5. Max price found: {max_price}')

    # 6. Find the date
    date = re.findall(r'\d+[/.-]\d+[/.-]\d+', raw_texts)

    for i in date:
        try:
            date_parsed = parser.parse(i)
            date = date_parsed
        except:
            continue

    result['date'] = date
    print(f'6. Date is {date}')

    print('[recognize_text] function END\n')

    return result


def find_combination(target: float or None, candidates: list) -> list or None:
    # print(f'target is {target}')

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

    try:
        maxLengthResult = max(results, key=len)
        print(f'Combination of prices: {maxLengthResult}')
    except:
        print('Could not find the combination prices')
        return None

    return maxLengthResult


def find_description(texts_dict: list, target_prices: list):
    if len(target_prices) == 0:
        return

    texts_df = pd.DataFrame(texts_dict)
    columns = ['topLeft', 'topRight', 'bottomRight', 'bottomLeft']
    texts_df2 = pd.DataFrame(
        texts_df['points'].values.tolist(), columns=columns)
    columns = ['dx', 'dy']
    texts_df3 = pd.DataFrame(
        texts_df2['bottomLeft'].values.tolist(), columns=columns)
    texts_df3['text'] = texts_df['text']

    processsed_descriptions = []

    for price_with_position in target_prices:
        price_with_position: dict

        value = price_with_position['offset'][3][1]

        index = np.where((texts_df3.dy.values > value * 0.975)
                         & (texts_df3.dy.values < value * 1.025))
        descriptions = texts_df3.iloc[index]['text']
        description = ', '.join(descriptions.values)

        description_clean = description.strip(price_with_position['price'])
        description_clean = re.sub(
            f'[{re.escape(punctuation)}]', '', description_clean)
        description_clean = re.sub(r"\b[0-9]+\b\s*", "", description_clean)
        description_clean = description_clean.strip()

        processsed_descriptions.append(description_clean)

    print(f'All the descriptions found: {processsed_descriptions}')

    return processsed_descriptions


def create_items(receipt_id: str, descriptions: list, prices: list):
    transaction_items = []

    for i in range(len(prices)):
        id = str(uuid.uuid4())

        if 'tax' in descriptions[i]:
            type = 'tax'
        elif 'tip' in descriptions[i]:
            type = 'tip'
        else:
            type = 'item'

        item: dict = {
            'name': descriptions[i],
            'transactionItemId': id,
            'amount': prices[i],
            'isoCurrencyCode': 'USD',
            'receiptId': receipt_id,
            'type': type,
        }

        transaction_items.append(item)

    return transaction_items


def process_receipt_texts(request: flask.Request):
    try:
        # Load request data
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict: dict[str, ] = json.loads(data_decoded)
        texts_with_offset: list = data_dict['texts_with_offsets']
        print(f'Texts with offsets: \n{texts_with_offset}')
        raw_texts: str = data_dict['raw_texts']
        print(f'Raw texts: \n{raw_texts}')

        result = recognize_text(raw_texts, texts_with_offset)

        prices_dict_list: list = result['prices_dict_list']
        max_price: float or None = result['max_price']
        prices: list = result['prices']
        date: datetime.datetime = result['date']

        prices_combination = find_combination(max_price, prices)
        prices_dict_list_filtered = [
            x for x in prices_dict_list if float(x['price']) in prices_combination]

        descriptions = find_description(
            texts_with_offset, prices_dict_list_filtered)

        receipt_id = str(uuid.uuid4())

        if prices_dict_list_filtered != None:
            items = create_items(receipt_id, descriptions, prices_combination)
        else:
            items = create_items(receipt_id, descriptions, prices)

        total: dict = {
            'name': 'Total',
            'transactionItemId': str(uuid.uuid4()),
            'amount': max_price,
            'isoCurrencyCode': 'USD',
            'receiptId': receipt_id,
            'type': 'subtotal',
        }

        items.append(total)

        response = jsonify(transaction_items=items, date=date)

        print('process_receipt_texts function ended')

        return make_response(response, 200)
    except Exception as e:
        print(f'process_receipt_texts function ended with error {e}')

        return make_response(jsonify('An Error Occurred'), 404)
