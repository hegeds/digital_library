from abc import ABC, abstractmethod

from .repositories import AbstractBookRepository, AbstractUserRepository


class AbstractUnitOfWork(ABC):
    books: AbstractBookRepository
    users: AbstractUserRepository

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
