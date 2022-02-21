import re
from typing import Dict, List

import dateutil.parser as parser
from numpy import average

from texts.find_combination import find_combination


def recognize_prices(raw_texts: str, texts_with_offsets: list) -> dict:
    print('\n[recognize_text] function called')

    # 1. Find the middle dx of this image
    top_left_dxs = [x['points'][0][0] for x in texts_with_offsets]
    top_right_dxs = [x['points'][1][0] for x in texts_with_offsets]
    middle = average([min(top_left_dxs), max(top_right_dxs)])
    print(f'1a. dx range {min(top_left_dxs)}, {max(top_right_dxs)}')
    print(f'1b. middle dx = {middle}')

    result = {}

    # 2. Find the Prices and Max prices
    prices = [re.findall(r'\d+[.]\d+', x['text']) for x in texts_with_offsets]
    prices = [''.join(x) for x in prices]
    prices_filtered = [float(x) for x in prices if x]
    print(f'2a. Filtered prices = {prices_filtered}')

    if len(prices_filtered) == 0:
        return {'status': 404, 'message': 'Could not find the total amount from the image. Please choose a different image'}

    max_price = max(prices_filtered)
    result['max_price'] = max_price
    print(f'2b. Max Price: {max_price}')

    # 3. Create a new list of dictionaries that include price and offset
    price_with_points: List[Dict] = []

    for i in range(len(prices)):
        price = prices[i]

        if price == '':
            continue

        top_left_dx = top_left_dxs[i]
        offset = texts_with_offsets[i]['points']

        if top_left_dx > middle and float(price) != 0 and float(price) != max_price:
            price_with_points.append({'price': price, 'offset': offset})

    print(price_with_points)
    print(len(price_with_points))

    prices_filtered = [float(x.get('price')) for x in price_with_points]
    prices_combination = find_combination(max_price, prices_filtered)
    result['prices'] = prices_combination
    print(f'3a. Prices combination: {prices_combination}')

    prices_points_filtered = [x for x in price_with_points if float(
        x.get('price')) in prices_combination]
    result['prices_with_points'] = prices_points_filtered
    print(f'4. prices_points_filtered: {prices_points_filtered}')

    # 5. Find the date
    dates = re.findall(r'\d+[/.-]\d+[/.-]\d+', raw_texts)
    dates_parsed = []

    for possible_date in dates:
        try:
            date_parsed = parser.parse(possible_date)
            date_str = date_parsed.strftime('%Y-%m-%d %H:%M:%S.%f')
        except:
            continue

        dates_parsed.append(date_str)

    result['dates'] = dates_parsed
    print(f'5. Possible dates are: {dates_parsed}')

    result['status'] = 200

    return result
