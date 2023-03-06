from sqlalchemy.orm import relationship, registry

from src import models


mapper_registry = registry()

from .tables import books, authors, books_authors_table, users  # NOQA: E402

mapper_registry.map_imperatively(
    models.Book,
    books,
    properties={
        'authors': relationship(
            models.Author,
            secondary=books_authors_table,
            lazy='joined'
        )
    }
)

mapper_registry.map_imperatively(models.Author, authors)
mapper_registry.map_imperatively(models.User, users)
