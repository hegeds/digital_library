from dataclasses import dataclass, field
import uuid


@dataclass
class Author:
    name: str
    id: uuid.UUID = field(default=uuid.uuid4())


@dataclass
class Book:
    isbn: str
    published: int
    title: str
    id: uuid.UUID = field(default=uuid.uuid4())
    authors: list[Author] = field(default_factory=list)
