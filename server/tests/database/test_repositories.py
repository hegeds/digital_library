import pytest

from sqlalchemy.exc import IntegrityError

from src.database import repositories


class TestSQLBookRepository:
    @pytest.fixture(autouse=True)
    def setup(self, create_stored_book, Session):
        with Session() as session:
            self.book = create_stored_book(session)
            self.session = session
            self.repository = repositories.SQLBookRepository(self.session)
            yield

    def test_gets_book_by_id(self):
        fetched_book = self.repository.getById(self.book.id)

        assert fetched_book == self.book

    def test_gets_book_by_ISBN(self):
        fetched_book = self.repository.getByISBN(self.book.isbn)

        assert fetched_book == self.book

    def test_all_books(self, create_stored_book):
        books = [self.book]
        books.append(create_stored_book(self.session))
        fetched_books = self.repository.getAll()

        assert fetched_books == books

    def test_adds_book(self, create_book):
        book = create_book()

        old_books = self.repository.getAll()
        self.repository.add(book)
        self.session.commit()
        new_books = self.repository.getAll()

        assert book not in old_books
        assert book in new_books
        assert len(old_books) + 1 == len(new_books)


class TestSQLUserRepository:
    @pytest.fixture(autouse=True)
    def setup(self, create_stored_user, Session):
        with Session() as session:
            self.email = 'hello@mail.com'
            self.password = 'password'
            self.user = create_stored_user(
                session, self.email, self.password
            )
            self.session = session
            self.repository = repositories.SQLUserRepository(self.session)
            yield

    def test_gets_user_by_id(self):
        fetched_user = self.repository.get(self.user.id)

        assert fetched_user == self.user

    def test_gets_user_by_email(self):
        fetched_user = self.repository.getByEmail(self.user.email)

        assert fetched_user == self.user

    def test_adds_user(self, create_user):
        email = '2@mail.co'
        password = 'password'

        user = create_user(email, password)

        self.repository.add(user)
        self.session.commit()
        self.session.rollback
        new_user = self.repository.getByEmail(email)

        assert new_user is not None

    def test_fails_if_email_used(self, create_user):
        user = create_user(self.email, self.password)

        with pytest.raises(IntegrityError):
            self.repository.add(user)
            self.session.commit()
