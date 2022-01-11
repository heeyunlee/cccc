import re
from collections import Counter
import uuid
import flask
import json
from flask import jsonify, make_response
import pandas as pd
import numpy as np
from string import punctuation


def recognize_text(raw_text: str) -> tuple:
    print('recognize_text function started')

    # Find all the prices data
    prices: list[str] = re.findall(r'\d+[.]\d+', raw_text)
    prices: list[float] = [float(x) for x in prices]
    print(f'All the prices found {prices}')

    # Find the max price, which should be the total
    if len(prices) != 0:
        max_price = max(prices)
    else:
        max_price = None
    print(f'Max price found: {max_price}')

    # Find the prices that are NOT total AND NOT 0
    prices_filtered = [x for x in prices if x != 0 and x != max_price]
    print(f'Filtered prices: {prices_filtered}')

    return (max_price, prices_filtered)


def find_combination(target: float or None, candidates: list) -> list:
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

    maxLengthResult = max(results, key=len)
    print(f'Max List: {maxLengthResult}')

    return maxLengthResult


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

        for i in range(len(target_prices) - 1):
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
