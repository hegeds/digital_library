import pytest
import random
import string

from fastapi.testclient import TestClient

from src import Settings, app, get_settings, models


@pytest.fixture
def test_client():
    return TestClient(app)


@pytest.fixture
def settings_override():
    def _(settings: Settings):
        app.dependency_overrides[get_settings] = lambda: settings

    return _


@pytest.fixture
def generate_unique_id():
    return lambda: "".join(random.choices(string.ascii_lowercase, k=8))


@pytest.fixture
def generate_title(generate_unique_id):
    return lambda: f"Dummy title {generate_unique_id()}"


@pytest.fixture
def generate_author(generate_unique_id):
    return lambda: f"Dummy author {generate_unique_id()}"


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
    generate_publish_year
):
    return lambda: models.Book(
        isbn=generate_isbn(),
        authors=[generate_author(), generate_author()],
        title=generate_title(),
        published=generate_publish_year(),
    )
