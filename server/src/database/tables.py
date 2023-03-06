from sqlalchemy import Column, String, ForeignKey, UUID, Table, Integer

from . import mapper_registry


books_authors_table = Table(
    "books_authors_relationships",
    mapper_registry.metadata,
    Column("author_id", ForeignKey("authors.id")),
    Column("book_id", ForeignKey("books.id")),
)

books = Table(
    "books",
    mapper_registry.metadata,
    Column('id', UUID, primary_key=True),
    Column('isbn', String(13), nullable=False),
    Column('title', String(200), nullable=False),
    Column('published', Integer, nullable=False),
    # relationship(secondary=books_authors_table)
)

authors = Table(
    "authors",
    mapper_registry.metadata,
    Column('id', UUID, primary_key=True),
    Column('name', String(200), nullable=False),
)

users = Table(
    "users",
    mapper_registry.metadata,
    Column('id', UUID, primary_key=True),
    Column('email', String(200), nullable=False, unique=True),
    Column('password', String(200), nullable=False),
)
