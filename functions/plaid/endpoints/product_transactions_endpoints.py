import json
from datetime import date

import plaid
from plaid import ApiException
from plaid.model.transactions_get_request import TransactionsGetRequest
from plaid.model.transactions_get_response import TransactionsGetResponse
from plaid_configuration import PlaidConfiguration


# TODO: Change to Development or Production for release
plaid_config = PlaidConfiguration(plaid.Environment.Development)
client = plaid_config.client()

''' Get transaction data

    The `/transactions/get` endpoint allows developers to receive user-authorized transaction data
    for credit, depository, and some loan-type accounts (only those with account subtype student;
    coverage may be limited). For transaction history from investments accounts, use the Investments
    endpoint instead. Transaction data is standardized across financial institutions, and in many cases
    transactions are linked to a clean name, entity type, location, and category. Similarly, account
    data is standardized and returned with a clean name, number, balance, and other meta information
    where available.

    Transactions are returned in reverse-chronological order, and the sequence of transaction ordering
    is stable and will not shift. Transactions are not immutable and can also be removed altogether
    by the institution; a removed transaction will no longer appear in `/transactions/get`. For more
    details, see Pending and posted transactions.

    Due to the potentially large number of transactions associated with an Item, results are paginated.
    Manipulate the count and offset parameters in conjunction with the total_transactions response body
    field to fetch all available transactions.

    Data returned by `/transactions/get` will be the data available for the Item as of the most recent
    successful check for new transactions. Plaid typically checks for new data multiple times a day,
    but these checks may occur less frequently, such as once a day, depending on the institution. An
    Item's status.transactions.last_successful_update field will show the timestamp of the most recent
    successful update. To force Plaid to check for new transactions, you can use the
    `/transactions/refresh` endpoint.

    Note that data may not be immediately available to `/transactions/get`. Plaid will begin to prepare
    transactions data upon Item link, if Link was initialized with transactions, or upon the first call
    to `/transactions/get`, if it wasn't. To be alerted when transaction data is ready to be fetched,
    listen for the `INITIAL_UPDATE` and `HISTORICAL_UPDATE` webhooks. If no transaction history is
    ready when `/transactions/get` is called, it will return a `PRODUCT_NOT_READY` error.
'''


def transactions_get(access_token: str, start_date: date, end_date: date):
    try:
        request = TransactionsGetRequest(
            access_token=access_token,
            start_date=start_date,
            end_date=end_date,
        )
        response: TransactionsGetResponse = client.transactions_get(
            request
        )

        return response.to_dict()

    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
