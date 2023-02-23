import pytest

from unittest.mock import MagicMock
from sqlalchemy.orm import Session

from src.database import uow, repositories


class TestSQLUnitOfWork:
    @pytest.fixture(autouse=True)
    def setup(self, database_engine, monkeypatch):
        self.session = MagicMock()
        self.uow = uow.SQLUnitOfWork(database_engine)

    def test_entering_uow_creates_session(self):
        old_session = getattr(self.uow, 'session', None)
        with self.uow:
            assert self.uow.session is not None
            assert isinstance(self.uow.session, Session)
            assert old_session is None

    def test_commit_calls_session_commit(self):
        with self.uow:
            self.uow.session = self.session
            self.uow.commit()
            self.session.commit.assert_called_once()

    def test_rollback_calls_session_rollback(self):
        with self.uow:
            self.uow.session = self.session
            self.uow.rollback()
            self.session.rollback.assert_called_once()

    def test_exiting_closes_session(self):
        with self.uow:
            self.uow.session = self.session

        self.session.rollback.assert_called_once()
        self.session.close.assert_called_once()

    def test_provides_book_repository(self, create_book):
        with self.uow:
            book = create_book()
            self.uow.books.add(book)
            self.uow.commit()
            fetched_book = self.uow.books.getById(book.id)

            assert fetched_book == book
            assert isinstance(self.uow.books, repositories.SQLBookRepository)

