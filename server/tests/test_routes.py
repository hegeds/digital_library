import json

from unittest.mock import MagicMock
from http import HTTPStatus
from fastapi.encoders import jsonable_encoder


class TestSearchBook:
    def test_returns_book_when_fetched_from_api(
        self, test_client, create_book, settings_override, uow
    ):
        book = create_book()
        mock_api = MagicMock(return_value=book)
        settings_override({
            'configured_apis': [mock_api],
            'uow': uow
        })

        response = test_client.get(f"/books/search/{book.isbn}")
        assert response.status_code == HTTPStatus.OK
        assert jsonable_encoder(book) == json.loads(response.read().decode())
        assert uow.books.calls[0] == ['getByISBN', [book.isbn]]
        assert uow.books.calls[1] == ['add', [book]]
        mock_api.assert_called_once_with(book.isbn)

    def test_returns_book_when_found_in_repository(
        self, test_client, create_book, settings_override, uow
    ):
        book = create_book()
        uow.books.result = book
        mock_api = MagicMock(return_value=book)
        settings_override({
            'configured_apis': [mock_api],
            'uow': uow
        })

        response = test_client.get(f"/books/search/{book.isbn}")
        assert response.status_code == HTTPStatus.OK
        assert jsonable_encoder(book) == json.loads(response.read().decode())
        mock_api.assert_not_called()
        assert uow.books.calls == [['getByISBN', [book.isbn]]]

    def test_returns_not_found_when_book_can_not_be_fetched(
        self, test_client, settings_override, uow
    ):
        mock_api = MagicMock(return_value=None)
        settings_override({
            'configured_apis': [mock_api],
            'uow': uow
        })

        response = test_client.get("/books/search/1")

        assert response.status_code == HTTPStatus.NOT_FOUND
