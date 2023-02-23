from abc import ABC, abstractmethod

from .repositories import AbstractBookRepository


class AbstractUnitOfWork(ABC):
    books: AbstractBookRepository

    def __enter__(self):
        pass

    def __exit__(self, *args):
        self.rollback()

    @abstractmethod
    def commit(self):
        raise NotImplementedError

    @abstractmethod
    def rollback(self):
        raise NotImplementedError
