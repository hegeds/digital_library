from sqlalchemy.orm import Session

from src import models
from src.base import repositories


class SQLBookRepository(repositories.AbstractBookRepository):
    def __init__(self, session: Session):
        self.session = session

    def getById(self, id):
        return self.session.query(models.Book).filter_by(id=id).one_or_none()

    def getByISBN(self, isbn: int):
        return (
            self.session.query(models.Book).filter_by(isbn=isbn).one_or_none()
        )

    def getAll(self):
        return self.session.query(models.Book).all()

    def add(self, book):
        self.session.add(book)


class SQLUserRepository(repositories.AbstractUserRepository):
    def __init__(self, session: Session):
        self.session = session

    def get(self, id):
        return self.session.query(models.User).filter_by(id=id).one_or_none()

    def getByEmail(self, email):
        return (
            self.session.query(models.User).filter_by(email=email)
            .one_or_none()
        )

    def add(self, user):
        self.session.add(user)
