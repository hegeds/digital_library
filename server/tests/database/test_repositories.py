import pytest

from src.database import repositories


class TestSQLBookRepository:
    @pytest.fixture(autouse=True)
    def setup(self, create_stored_book, Session):
        with Session() as session:
            self.book = create_stored_book(session)
            self.session = session
            yield

    def test_gets_book_by_id(self):
        bookRepository = repositories.SQLBookRepository(self.session)
        fetched_book = bookRepository.getById(self.book.id)

        assert fetched_book == self.book

    def test_gets_book_by_ISBN(self):
        bookRepository = repositories.SQLBookRepository(self.session)
        fetched_book = bookRepository.getByISBN(self.book.isbn)

        assert fetched_book == self.book

    def test_all_books(self, create_stored_book):
        books = [self.book]
        books.append(create_stored_book(self.session))

        bookRepository = repositories.SQLBookRepository(self.session)
        fetched_books = bookRepository.getAll()

        assert fetched_books == books

    def test_adds_book(self, create_book):
        book = create_book()

        bookRepository = repositories.SQLBookRepository(self.session)

        old_books = bookRepository.getAll()
        bookRepository.add(book)
        self.session.commit()
        new_books = bookRepository.getAll()

        assert book not in old_books
        assert book in new_books
        assert len(old_books) + 1 == len(new_books)


