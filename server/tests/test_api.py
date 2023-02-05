import pytest
import json

from unittest.mock import MagicMock
from urllib import request, parse

from src.api import fetch_book_from_google


class TestFetchFromGoogle:
    @pytest.fixture(autouse=True)
    def setup(self, create_book):
        self.book = create_book()

    def test_able_to_fetch_book(self):
        mock_response = MagicMock()
        mock_response.read.return_value = json.dumps({
            'totalItems': 1,
            'items': [{
                'volumeInfo': {
                    'title': self.book.title,
                    'authors': self.book.authors,
                    'publishedDate': f'{self.book.published}-11-1'
                }
            }]
        })
        request.urlopen = MagicMock(return_value=mock_response)

        fetched_book = fetch_book_from_google(self.book.isbn)

        expected_url = parse.urljoin(
            'https://www.googleapis.com',
            f'/books/v1/volumes?q=isbn:{self.book.isbn}'
        )
        request.urlopen.assert_called_once_with(expected_url)
        assert self.book == fetched_book

    @pytest.mark.parametrize('itemCount', [0, 2])
    def test_returns_none_if_not_one_book_found(self, itemCount):
        mock_response = MagicMock()
        mock_response.read.return_value = json.dumps({
            'totalItems': itemCount,
        })
        request.urlopen = MagicMock(return_value=mock_response)

        fetched_book = fetch_book_from_google(self.book.isbn)
        assert fetched_book is None
