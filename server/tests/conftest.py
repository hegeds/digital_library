import pytest

from fastapi.testclient import TestClient

from src import app


@pytest.fixture
def test_client():
    return TestClient(app)
