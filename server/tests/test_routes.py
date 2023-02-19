import json

from unittest.mock import MagicMock
from http import HTTPStatus
from fastapi.encoders import jsonable_encoder

from src import Settings


class TestSearchBook:
    def test_returns_book_when_fetched_from_api(
        self, test_client, create_book, settings_override
    ):
        book = create_book()
        mock_api = MagicMock(return_value=book)
        settings = Settings(configured_apis=[mock_api])
        settings_override(settings)

        response = test_client.get(f"/books/search/{book.isbn}")
        assert response.status_code == HTTPStatus.OK
        assert jsonable_encoder(book) == json.loads(response.read().decode())
        mock_api.assert_called_once_with(book.isbn)

    def test_returns_not_found_when_book_can_not_be_fetched(
        self, test_client, settings_override
    ):
        mock_api = MagicMock(return_value=None)
        settings = Settings(configured_apis=[mock_api])
        settings_override(settings)

        response = test_client.get("/books/search/1")

        assert response.status_code == HTTPStatus.NOT_FOUND
