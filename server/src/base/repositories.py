import uuid

from abc import ABC, abstractmethod

from src.models import Book, User


class AbstractBookRepository(ABC):

    @abstractmethod
    def getById(self, id: uuid.UUID) -> Book | None:
        raise NotImplementedError

    @abstractmethod
    def getByISBN(self, isbn: int) -> Book | None:
        raise NotImplementedError

    def getAll(self) -> list:
        raise NotImplementedError

    @abstractmethod
    def add(self, book: Book):
        raise NotImplementedError


class AbstractUserRepository(ABC):
    @abstractmethod
    def get(self, id: uuid.UUID) -> User | None:
        raise NotImplementedError

    def getByEmail(self, email: str) -> User | None:
        raise NotImplementedError

    def add(self, user: User):
        raise NotImplementedError
