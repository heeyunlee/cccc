import json

import plaid
from plaid import ApiException
from plaid.model.country_code import CountryCode
from plaid.model.institutions_get_by_id_request import InstitutionsGetByIdRequest
from plaid.model.institutions_get_by_id_request_options import InstitutionsGetByIdRequestOptions
from plaid.model.institutions_get_by_id_response import InstitutionsGetByIdResponse
from source.plaid_configuration import PlaidConfiguration

''' /institutions/get_by_id

    Returns a JSON response containing details on a specified financial institution currently
    upported by Plaid.

    Versioning note: API versions 2019-05-29 and earlier allow use of the public_key parameter
    instead of the client_id and secret to authenticate to this endpoint. The public_key has been
    deprecated; all customers are encouraged to use client_id and secret instead.
'''


def institutions_get_by_id(institution_id: str):
    try:
        options = InstitutionsGetByIdRequestOptions(
            include_optional_metadata=True,
        )
        request = InstitutionsGetByIdRequest(
            institution_id=institution_id,
            country_codes=[CountryCode('US')],
            options=options,
        )

        # TODO: Change to Development or Production for release
        plaid_config = PlaidConfiguration(plaid.Environment.Development)
        client = plaid_config.client()

        response: InstitutionsGetByIdResponse = client.institutions_get_by_id(
            request)
        response_dict = response.to_dict()

        return response_dict
    except ApiException as e:
        exceptions: dict = json.loads(e.body)

        return exceptions
