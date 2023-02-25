import json

from urllib import request, parse

from src.models import Book, Author


def fetch_book_from_google(isbn: str):
    url = parse.urljoin(
        'https://www.googleapis.com',
        f'/books/v1/volumes?q=isbn:{isbn}'
    )
    response = request.urlopen(url)
    response_data = json.loads(response.read())

    if response_data['totalItems'] != 1:
        return None

    volume = response_data['items'][0]['volumeInfo']

    published = int(volume['publishedDate'].split('-')[0])
    authors = [
        Author(name=author_data['name']) for author_data in volume['authors']
    ]
    title = volume['title']

    return Book(
        isbn=isbn,
        title=title,
        authors=authors,
        published=published
    )


BOOK_APIS = [fetch_book_from_google]
