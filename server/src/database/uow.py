from sqlalchemy import Engine
from sqlalchemy.orm import sessionmaker

from src.base import uow

from . import repositories


class SQLUnitOfWork(uow.AbstractUnitOfWork):
    def __init__(self, engine: Engine):
        self.engine = engine

    def __enter__(self):
        self.session = sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=self.engine,
            expire_on_commit=False
        )()
        self.books = repositories.SQLBookRepository(self.session)
        self.users = repositories.SQLUserRepository(self.session)
        return super().__enter__()

    def __exit__(self, *args):
        super().__exit__(*args)
        self.session.close()

    def commit(self):
        self.session.commit()

    def rollback(self):
        self.session.rollback()
