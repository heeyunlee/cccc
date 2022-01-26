import ast
import json
import plaid
from plaid.api import plaid_api


def get_categories():
    f = open('private_keys.json')
    data = json.load(f)
    f.close()

    configuration = plaid.Configuration(
        host=plaid.Environment.Sandbox,
        api_key={
            'clientId': data['client_id'],
            'secret': data['secret'],
        }
    )

    api_client = plaid.ApiClient(configuration)
    client = plaid_api.PlaidApi(api_client)

    response = client.categories_get({})
    a = response['categories']
    print(f'categories_get response: {a}')
    # print(f'type is {type(a)}')

    with open('categories.txt', 'w') as f:
        for item in a:
            f.write("%s\n" % item)


def food_category_ids() -> list:
    f = open('categories.txt', 'r')
    categories = f.read()
    splitter = '}'
    categories = [x+splitter for x in categories.split(splitter) if x]
    f.close()

    category_ids = []

    for category in categories:
        if 'food' in category.lower():
            category_dict = ast.literal_eval(category)
            category_ids.append(category_dict['category_id'])

    return category_ids
