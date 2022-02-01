from unittest.mock import Mock

import main


def test_print_name():
    name = 'test'
    data = {'name': name}
    req = Mock(get_json=Mock(return_value=data), args=data)

    # Call tested function
    assert main.hello_http(req) == 'Hello {}!'.format(name)


def test_print_hello_world():
    data = {}
    req = Mock(get_json=Mock(return_value=data), args=data)

    # Call tested function
    assert main.hello_http(req) == 'Hello World!'
