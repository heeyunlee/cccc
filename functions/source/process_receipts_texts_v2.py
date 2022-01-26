# %%
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

# %%
raw_texts = 'Angelo\'s Piza Restaurant, 12247 Sheridan St, Cooper Cityb, FL 33026, (954) 893-2000, Station: 2, Server: Melina, In, Dine, Guests: 4, Order #; 4876, Table: 1, 2.55, 8.95, Sprite, Chicken Caesar Salad, Chefs Special, > Chefs Special, Soup of Day, 19.9, Bar Subtotal:, Food Subtotal:, Tax, 0.00, 31.45, 1.89, 1:, TOTAL:, K3.34, >» Ticket t: 56 K<, 7/10/2017 9:32:06 PM, THANK YOU!'
map_with_position = [{'text': "Angelo's", 'points': [[192.0, 108.0], [285.0, 104.0], [286.0, 144.0], [193.0, 148.0]]}, {'text': 'Piza', 'points': [[287.0, 104.0], [348.0, 101.0], [349.0, 141.0], [288.0, 144.0]]}, {'text': 'Restaurant', 'points': [[350.0, 104.0], [459.0, 99.0], [460.0, 138.0], [351.0, 143.0]]}, {'text': '12247', 'points': [[249.0, 145.0], [295.0, 143.0], [295.0, 161.0], [249.0, 163.0]]}, {'text': 'Sheridan', 'points': [[308.0, 142.0], [387.0, 139.0], [387.0, 158.0], [308.0, 161.0]]}, {'text': 'St', 'points': [[399.0, 140.0], [416.0, 139.0], [416.0, 156.0], [399.0, 157.0]]}, {'text': 'Cooper', 'points': [[227.0, 172.0], [285.0, 169.0], [285.0, 188.0], [227.0, 191.0]]}, {'text': 'Cityb,', 'points': [[298.0, 169.0], [353.0, 166.0], [353.0, 186.0], [298.0, 189.0]]}, {'text': 'FL', 'points': [[370.0, 167.0], [386.0, 166.0], [386.0, 183.0], [370.0, 184.0]]}, {'text': '33026', 'points': [[400.0, 165.0], [449.0, 162.0], [449.0, 180.0], [400.0, 183.0]]}, {'text': '(954)', 'points': [[270.0, 195.0], [315.0, 193.0], [315.0, 213.0], [270.0, 215.0]]}, {'text': '893-2000', 'points': [[329.0, 193.0], [408.0, 190.0], [408.0, 208.0], [329.0, 211.0]]}, {'text': 'Station:', 'points': [[442.0, 240.0], [521.0, 237.0], [521.0, 255.0], [442.0, 258.0]]}, {'text': '2', 'points': [[535.0, 238.0], [544.0, 237.0], [544.0, 254.0], [535.0, 255.0]]}, {'text': 'Server:', 'points': [[128.0, 250.0], [205.0, 247.0], [205.0, 264.0], [128.0, 267.0]]}, {'text': 'Melina', 'points': [[219.0, 247.0], [278.0, 245.0], [278.0, 263.0], [219.0, 265.0]]}, {'text': 'In', 'points': [[527.0, 291.0], [544.0, 291.0], [543.0, 306.0], [526.0, 306.0]]}, {'text': 'Dine', 'points': [[474.0, 291.0], [513.0, 291.0], [512.0, 307.0], [473.0, 307.0]]}, {'text': 'Guests:', 'points': [[454.0, 317.0], [521.0, 315.0], [521.0, 332.0], [454.0, 334.0]]}, {'text': '4', 'points': [[537.0, 315.0], [545.0, 314.0], [545.0, 330.0], [537.0, 331.0]]}, {'text': 'Order', 'points': [[139.0, 299.0], [188.0, 297.0], [188.0, 315.0], [139.0, 317.0]]}, {'text': '#;', 'points': [[200.0, 300.0], [215.0, 299.0], [215.0, 314.0], [200.0, 315.0]]}, {'text': '4876', 'points': [[230.0, 298.0], [268.0, 296.0], [268.0, 312.0], [230.0, 314.0]]}, {'text': 'Table:', 'points': [[140.0, 324.0], [196.0, 322.0], [196.0, 339.0], [140.0, 341.0]]}, {'text': '1', 'points': [[213.0, 323.0], [216.0, 322.0], [216.0, 338.0], [213.0, 339.0]]}, {'text': '2.55', 'points': [[507.0, 365.0], [546.0, 365.0], [545.0, 383.0], [506.0, 383.0]]}, {'text': '8.95', 'points': [[507.0, 391.0], [547.0, 391.0], [546.0, 408.0], [506.0, 408.0]]}, {'text': 'Sprite', 'points': [[161.0, 372.0], [219.0, 373.0], [218.0, 393.0], [160.0, 392.0]]}, {'text': 'Chicken', 'points': [[161.0, 399.0], [229.0, 397.0], [229.0, 414.0], [161.0, 416.0]]}, {'text': 'Caesar', 'points': [[242.0, 397.0], [300.0, 395.0], [300.0, 412.0], [242.0, 414.0]]}, {'text': 'Salad', 'points': [
    [312.0, 395.0], [361.0, 393.0], [361.0, 411.0], [312.0, 413.0]]}, {'text': 'Chefs', 'points': [[161.0, 422.0], [210.0, 420.0], [210.0, 439.0], [161.0, 441.0]]}, {'text': 'Special', 'points': [[222.0, 422.0], [288.0, 419.0], [288.0, 438.0], [222.0, 441.0]]}, {'text': '>', 'points': [[163.0, 451.0], [170.0, 451.0], [170.0, 464.0], [163.0, 464.0]]}, {'text': 'Chefs', 'points': [[183.0, 447.0], [231.0, 447.0], [231.0, 465.0], [183.0, 465.0]]}, {'text': 'Special', 'points': [[243.0, 445.0], [309.0, 445.0], [309.0, 467.0], [243.0, 467.0]]}, {'text': 'Soup', 'points': [[163.0, 474.0], [200.0, 473.0], [200.0, 492.0], [163.0, 493.0]]}, {'text': 'of', 'points': [[213.0, 473.0], [230.0, 472.0], [230.0, 489.0], [213.0, 490.0]]}, {'text': 'Day', 'points': [[243.0, 472.0], [271.0, 471.0], [271.0, 490.0], [243.0, 491.0]]}, {'text': '19.9', 'points': [[500.0, 417.0], [535.0, 417.0], [535.0, 435.0], [500.0, 435.0]]}, {'text': 'Bar', 'points': [[143.0, 525.0], [171.0, 524.0], [171.0, 540.0], [143.0, 541.0]]}, {'text': 'Subtotal:', 'points': [[184.0, 523.0], [269.0, 521.0], [269.0, 538.0], [184.0, 540.0]]}, {'text': 'Food', 'points': [[144.0, 548.0], [183.0, 548.0], [183.0, 567.0], [144.0, 567.0]]}, {'text': 'Subtotal:', 'points': [[194.0, 547.0], [281.0, 547.0], [281.0, 566.0], [194.0, 566.0]]}, {'text': 'Tax', 'points': [[144.0, 574.0], [172.0, 574.0], [171.0, 591.0], [143.0, 591.0]]}, {'text': '0.00', 'points': [[511.0, 519.0], [550.0, 518.0], [550.0, 535.0], [511.0, 536.0]]}, {'text': '31.45', 'points': [[501.0, 544.0], [551.0, 545.0], [550.0, 563.0], [500.0, 562.0]]}, {'text': '1.89', 'points': [[514.0, 569.0], [552.0, 570.0], [551.0, 589.0], [513.0, 588.0]]}, {'text': '1:', 'points': [[187.0, 574.0], [200.0, 574.0], [199.0, 590.0], [186.0, 590.0]]}, {'text': 'TOTAL:', 'points': [[126.0, 619.0], [205.0, 626.0], [201.0, 662.0], [122.0, 655.0]]}, {'text': 'K3.34', 'points': [[493.0, 624.0], [556.0, 624.0], [556.0, 663.0], [493.0, 663.0]]}, {'text': '>»', 'points': [[258.0, 696.0], [277.0, 696.0], [277.0, 722.0], [258.0, 722.0]]}, {'text': 'Ticket', 'points': [[288.0, 690.0], [348.0, 690.0], [348.0, 726.0], [288.0, 726.0]]}, {'text': 't:', 'points': [[359.0, 693.0], [377.0, 693.0], [377.0, 726.0], [359.0, 726.0]]}, {'text': '56', 'points': [[390.0, 691.0], [410.0, 691.0], [410.0, 726.0], [390.0, 726.0]]}, {'text': 'K<', 'points': [[422.0, 697.0], [441.0, 697.0], [441.0, 723.0], [422.0, 723.0]]}, {'text': '7/10/2017', 'points': [[248.0, 730.0], [338.0, 730.0], [338.0, 751.0], [248.0, 751.0]]}, {'text': '9:32:06', 'points': [[350.0, 731.0], [421.0, 731.0], [421.0, 750.0], [350.0, 750.0]]}, {'text': 'PM', 'points': [[432.0, 732.0], [452.0, 732.0], [452.0, 750.0], [432.0, 750.0]]}, {'text': 'THANK', 'points': [[300.0, 781.0], [349.0, 782.0], [348.0, 800.0], [299.0, 799.0]]}, {'text': 'YOU!', 'points': [[361.0, 783.0], [398.0, 784.0], [397.0, 801.0], [360.0, 800.0]]}]

# %%


def recognize_text(raw_texts: str, texts_with_offsets: list) -> dict:
    print('\n[recognize_text] function called')

    print(f'raw texts: \n{raw_texts}')
    print(f'texts_with_offsets: \n{texts_with_offsets}')

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

    # 4. Find the all the prices and max price
    prices = [float(x['price']) for x in prices_dict_list]

    if len(prices) != 0:
        max_price = max(prices)
    else:
        max_price = None

    result['max_price'] = max_price
    print(f'4. Max price found: {max_price}')

    # 5. All the other items
    prices = [x for x in prices if x != 0 and x != max_price]
    result['prices'] = prices
    print(f'5. All the found prices except 0 and max: {prices}')

    # 6. Find the date
    date = re.findall(r'\d+[/.-]\d+[/.-]\d+', raw_texts)

    if len(date) > 0:
        for i in date:
            try:
                date_parsed = parser.parse(i)
                date = date_parsed.strftime('%Y-%m-%d')
            except:
                continue
    else:
        date = None

    result['date'] = date
    print(f'6. Date is {date}')

    # 7. Find the name
    right_top_dys = [x['points'][0][1] for x in texts_with_offsets]
    right_top_dy_max = min(right_top_dys)
    name = [x['text'] for x in texts_with_offsets if right_top_dy_max *
            0.95 < x['points'][0][1] < right_top_dy_max * 1.05]
    name = ' '.join(name)
    result['name'] = name
    print(f'Name: {name}')

    print('[recognize_text] function END\n')

    return result

# %%


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

    try:
        maxLengthResult = max(results, key=len)
        print(f'Combination of prices: {maxLengthResult}')
    except:
        print('Could not find the combination prices. Returning the original prices')
        return candidates

    return maxLengthResult

# %%


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

# %%


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

# %%


def process_receipt_texts(request: flask.Request):
    try:
        # Load request data
        data = request.get_data()
        data_decoded = data.decode('UTF-8')
        data_dict: dict[str, ] = json.loads(data_decoded)
        texts_with_offset: list = data_dict['texts_with_offsets']
        raw_texts: str = data_dict['raw_texts']

        #
        result = recognize_text(raw_texts, texts_with_offset)

        prices_dict_list: list = result['prices_dict_list']
        max_price: float or None = result['max_price']
        prices: list = result['prices']
        date: datetime.datetime = result['date']
        name: str = result['name']

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

        response = jsonify(transactionItems=items, date=date, name=name)

        print('process_receipt_texts function ended')

        return make_response(response, 200)
    except Exception as e:
        print(f'process_receipt_texts function ended with error {e}')

        return make_response(jsonify('An Error Occurred'), 404)
