import json
import uuid
from typing import Any, Dict, List, Optional

import flask
from flask import jsonify

from source.texts.find_descriptions import find_descriptions
from source.texts.recognize_prices import recognize_prices


def process_receipt_texts(request: flask.Request):
    # ^TODO: change the type to flask.Request for release

    # Load request data
    data_dict: Dict[str, Any] = json.loads(request.data)  # TODO: for release
    # data_dict = request # TODO: for testing
    texts_with_offsets: list = data_dict.get('texts_with_offsets')
    print(f'texts_with_offsets: {texts_with_offsets}')
    raw_texts: str = data_dict.get('raw_texts')
    print(f'raw_texts: {raw_texts}')

    result = recognize_prices(raw_texts, texts_with_offsets)
    price_with_points: List[Dict] = result.get('prices_with_points')
    max_price: Optional[float] = result.get('max_price')
    prices: List[float] = result.get('prices')
    dates: List = result.get('dates')
    status: int = result.get('status')

    if status == 404:
        return {'status': 404, 'message': 'Could not find the price from this image'}

    try:
        descriptions = find_descriptions(texts_with_offsets, price_with_points)
        print(f'descriptions: {descriptions}')

        if descriptions is None:
            return {'status': 404, 'message': 'Could not find the descriptions from this image'}

        receipt_id = str(uuid.uuid4())

        transaction_items = []

        assert(len(price_with_points) == len(descriptions))

        for i in range(len(prices)):
            if 'tax' in descriptions[i]:
                type = 'tax'
            elif 'tip' in descriptions[i]:
                type = 'tip'
            else:
                type = 'item'

            item: dict = {
                'name': descriptions[i],
                'transactionItemId': str(uuid.uuid4()),
                'amount': prices[i],
                'isoCurrencyCode': 'USD',
                'receiptId': receipt_id,
                'type': type,
            }

            transaction_items.append(item)

        total: dict = {
            'name': 'Total',
            'transactionItemId': str(uuid.uuid4()),
            'amount': max_price,
            'isoCurrencyCode': 'USD',
            'receiptId': receipt_id,
            'type': 'subtotal',
        }

        transaction_items.append(total)

        return jsonify(status=200, transactionItems=transaction_items, dates=dates)
    except Exception as e:
        print(f'process_receipt_texts function ended with error: {e}')

        return jsonify(status=404, message=f'An Error Occurred {str(e)}')
