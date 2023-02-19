from sqlalchemy import create_engine
from sqlalchemy.orm import relationship, sessionmaker, registry

from src import get_settings, models


settings = get_settings()
engine = create_engine(
    settings.database_url,  pool_pre_ping=True
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

mapper_registry = registry()

from .tables import books, authors, books_authors_table  # NOQA: E402


mapper_registry.map_imperatively(
    models.Book,
    books,
    properties={
        'authors': relationship(models.Author, secondary=books_authors_table)
    }
)

mapper_registry.map_imperatively(models.Author, authors)
