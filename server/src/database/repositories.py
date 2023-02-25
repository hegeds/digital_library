from sqlalchemy.orm import Session

from src import models
from src.base import repositories


class SQLBookRepository(repositories.AbstractBookRepository):
    def __init__(self, session: Session):
        self.session = session

    def getById(self, id):
        return self.session.query(models.Book).filter_by(id=id).one()

    def getByISBN(self, isbn: int):
        return self.session.query(models.Book).filter_by(isbn=isbn).one()

    def getAll(self):
        return self.session.query(models.Book).all()

    def add(self, book):
        self.session.add(book)
