import pytest
import random
import string

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, close_all_sessions


from src import app, settings, get_configurations, password_context
from src.base.repositories import (
    AbstractBookRepository, AbstractUserRepository
)
from src.base.uow import AbstractUnitOfWork
from src.models import Author, Book, User
from src.database import mapper_registry


@pytest.fixture
def test_client():
    return TestClient(app)


@pytest.fixture
def settings_override():
    def _(configurations: dict):
        app.dependency_overrides[get_configurations] = lambda: configurations

    return _


@pytest.fixture
def database_engine():
    engine = create_engine(
        settings.database_url,
        pool_pre_ping=True
    )

    mapper_registry.metadata.create_all(engine)

    yield engine

    close_all_sessions()
    mapper_registry.metadata.drop_all(engine)


@pytest.fixture
def Session(database_engine):
    return sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=database_engine
    )


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


@pytest.fixture
def create_user():
    def _(email, raw_password):
        hashed_password = password_context.hash(raw_password)

        user = User(email, hashed_password)
        return user

    return _


@pytest.fixture
def create_stored_user(create_user):
    def _(session, email, password):
        user = create_user(email, password)
        session.add(user)
        session.commit()

        return user

    return _


@pytest.fixture
def book_repository():
    class TestBookRepository(AbstractBookRepository):
        calls = []
        result: Book | None = None
        results: list = []

        def getById(self, id):
            self.calls.append(['getById', [id]])
            return self.result

        def getByISBN(self, isbn):
            self.calls.append(['getByISBN', [isbn]])
            return self.result

        def getAll(self):
            return self.results

        def add(self, book):
            self.calls.append(['add', [book]])

    return TestBookRepository()


@pytest.fixture
def user_repository():
    class TestUserRepository(AbstractUserRepository):
        calls = []
        result: User | None = None
        results: list = []

        def get(self, id):
            self.calls.append(['getById', [id]])
            return self.result

        def getByEmail(self, email):
            self.calls.append(['getByISBN', [email]])
            return self.result

        def add(self, user):
            self.calls.append(['add', [user]])

    return TestUserRepository()


@pytest.fixture
def uow(book_repository, user_repository):
    class TestUnitOfWork(AbstractUnitOfWork):
        books = book_repository
        users = user_repository
        calls = []

        def commit(self):
            return self.calls.append(['commit'])

        def rollback(self):
            return self.calls.append(['rollback'])

    return TestUnitOfWork()
