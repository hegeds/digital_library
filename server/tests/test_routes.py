import json
import pytest

from unittest.mock import MagicMock
from http import HTTPStatus
from fastapi.encoders import jsonable_encoder


class TestSearchBook:
    def test_returns_book_when_fetched_from_api(
        self, test_client, create_book, settings_override, uow
    ):
        book = create_book()
        mock_api = MagicMock(return_value=book)
        settings_override({"configured_apis": [mock_api], "uow": uow})

        response = test_client.get(f"/books/search/{book.isbn}")
        assert response.status_code == HTTPStatus.OK
        assert jsonable_encoder(book) == json.loads(response.read().decode())
        assert uow.books.calls[0] == ["getByISBN", [book.isbn]]
        assert uow.books.calls[1] == ["add", [book]]
        mock_api.assert_called_once_with(book.isbn)

    def test_returns_book_when_found_in_repository(
        self, test_client, create_book, settings_override, uow
    ):
        book = create_book()
        uow.books.result = book
        mock_api = MagicMock(return_value=book)
        settings_override({"configured_apis": [mock_api], "uow": uow})

        response = test_client.get(f"/books/search/{book.isbn}")
        assert response.status_code == HTTPStatus.OK
        assert jsonable_encoder(book) == json.loads(response.read().decode())
        mock_api.assert_not_called()
        assert uow.books.calls == [["getByISBN", [book.isbn]]]

    def test_returns_not_found_when_book_can_not_be_fetched(
        self, test_client, settings_override, uow
    ):
        mock_api = MagicMock(return_value=None)
        settings_override({"configured_apis": [mock_api], "uow": uow})

        response = test_client.get("/books/search/1")

        assert response.status_code == HTTPStatus.NOT_FOUND


class TestCreateUser:
    def test_returns_created_user(self, test_client, database_engine):
        email = 'valid@mail.co'
        password = 'this is a valid password'

        response = test_client.post("/user/create", json={
            'email': email,
            'password': password
        })
        created_user_dict = json.loads(response.read().decode())

        assert response.status_code == HTTPStatus.CREATED
        assert created_user_dict['email'] == email

    def test_returns_error_when_user_creations_fails(
        self, test_client, database_engine
    ):
        invalid_email = 'invalid.email'
        password = 'this is a valid password'

        response = test_client.post("/user/create", json={
            'email': invalid_email,
            'password': password
        })
        response_data = json.loads(response.text)

        assert response.status_code == HTTPStatus.UNPROCESSABLE_ENTITY
        assert response_data['detail'] == 'Unable to create user!'


class TestTokenCreation:
    @pytest.fixture(autouse=True)
    def setup(self, Session, create_stored_user):
        self.email = 'valid@mail.co'
        self.password = 'this is a valid password'

        with Session() as session:
            create_stored_user(session, self.email, self.password)

    def test_creates_toke_for_user(
        self, test_client,
    ):
        response = test_client.post("/token", data={
            'username': self.email,
            'password': self.password
        })
        response_data = json.loads(response.text)

        assert response.status_code == HTTPStatus.OK
        assert response_data['token_type'] == 'bearer'
        assert response_data['access_token'] is not None

    def test_raises_unauthorized_for_invalid_credentials(self, test_client):
        response = test_client.post("/token", data={
            'username': self.email,
            'password': 'wrong password'
        })
        response_data = json.loads(response.text)

        assert response.status_code == HTTPStatus.UNAUTHORIZED
        assert response_data['detail'] == 'Incorrect username or password'
