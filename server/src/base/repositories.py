import uuid

from abc import ABC, abstractmethod

from src.models import Book


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
