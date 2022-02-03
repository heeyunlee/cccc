import json

from plaid import ApiException
from plaid.model.item_remove_request import ItemRemoveRequest
from plaid.model.item_remove_response import ItemRemoveResponse
from source.configuration import plaid_client

''' Remove an Item

    The `/item/remove` endpoint allows you to remove an Item. Once removed, 
    the `access_token` associated with the Item is no longer valid and cannot 
    be used to access any data that was associated with the Item.

    Note that in the Development environment, issuing an `/item/remove` request 
    will not decrement your live credential count. To increase your credential 
    account in Development, contact Support.

    Also note that for certain OAuth-based institutions, an Item removed via 
    `/item/remove` may still show as an active connection in the institution's 
    OAuth permission manager.

    API versions 2019-05-29 and earlier return a removed boolean as part of the 
    response.
'''


def item_remove(access_token: str):
    try:
        request = ItemRemoveRequest(access_token)
        response: ItemRemoveResponse = plaid_client.item_remove(request)

        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions
