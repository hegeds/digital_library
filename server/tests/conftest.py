import pytest
import random
import string

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, close_all_sessions


from src import app, Settings, get_settings
from src.models import Author, Book
from src.database import mapper_registry


@pytest.fixture
def test_client():
    return TestClient(app)


@pytest.fixture
def settings_override():
    def _(settings: Settings):
        app.dependency_overrides[get_settings] = lambda: settings

    return _


@pytest.fixture
def database_engine():
    return create_engine(
        get_settings().database_url,
        pool_pre_ping=True
    )


@pytest.fixture
def Session(database_engine):
    mapper_registry.metadata.create_all(database_engine)

    Session = sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=database_engine
    )
    yield Session

    close_all_sessions()
    mapper_registry.metadata.drop_all(database_engine)


@pytest.fixture
def generate_unique_id():
    return lambda: "".join(random.choices(string.ascii_lowercase, k=8))


@pytest.fixture
def generate_title(generate_unique_id):
    return lambda: f"Dummy title {generate_unique_id()}"


@pytest.fixture
def generate_author(generate_unique_id):
    return lambda: Author(name=f"Dummy author {generate_unique_id()}")


@pytest.fixture
def generate_publish_year():
    return lambda: random.randint(1700, 2100)


@pytest.fixture
def generate_isbn():
    return lambda: "".join(random.choices(string.digits, k=13))


@pytest.fixture
def create_book(
    generate_isbn,
    generate_author,
    generate_title,
    generate_publish_year,
):
    def _():
        authors = [generate_author(), generate_author()]
        book = Book(
            isbn=generate_isbn(),
            title=generate_title(),
            published=generate_publish_year(),
        )

        for author in authors:
            book.authors.append(author)

        return book

    return _


@pytest.fixture
def create_stored_book(create_book):
    def _(session):
        book = create_book()
        session.add(book)
        session.commit()

        return book

    return _
