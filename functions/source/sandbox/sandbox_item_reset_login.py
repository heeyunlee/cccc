import json

from plaid import ApiException
from plaid.model.sandbox_item_reset_login_request import \
    SandboxItemResetLoginRequest
from plaid.model.sandbox_item_reset_login_response import \
    SandboxItemResetLoginResponse
from tests.test_configuration import plaid_client

''' Force a Sandbox Item into an error state

    `/sandbox/item/reset_login/` forces an Item into an `ITEM_LOGIN_REQUIRED` 
    state in order to simulate an Item whose login is no longer valid. This makes 
    it easy to test Link's update mode flow in the Sandbox environment. After calling 
    `/sandbox/item/reset_login`, You can then use Plaid Link update mode to restore 
    the Item to a good state. An `ITEM_LOGIN_REQUIRED` webhook will also be fired 
    after a call to this endpoint, if one is associated with the Item.

    In the Sandbox, Items will transition to an `ITEM_LOGIN_REQUIRED` error state 
    automatically after 30 days, even if this endpoint is not called.
'''


def sandbox_item_reset_login(access_token: str):
    try:
        request = SandboxItemResetLoginRequest(access_token)
        response: SandboxItemResetLoginResponse = plaid_client.sandbox_item_reset_login(
            request
        )
        return response.to_dict()
    except ApiException as e:
        exceptions: dict = json.loads(e.body)
        return exceptions
