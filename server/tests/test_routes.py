from http import HTTPStatus


class TestSearchBook:
    def test_returns_not_found(self, test_client):
        response = test_client.get('/books/search/1')

        assert response.status_code == HTTPStatus.NOT_FOUND
