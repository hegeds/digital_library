from dataclasses import dataclass, field
import uuid


@dataclass
class Author:
    name: str
    id: uuid.UUID = field(init=False)

    def __post_init__(self) -> None:
        self.id = uuid.uuid4()


@dataclass
class Book:
    isbn: str
    published: int
    title: str
    id: uuid.UUID = field(init=False)
    authors: list[Author] = field(default_factory=list)

    def __post_init__(self) -> None:
        self.id = uuid.uuid4()


@dataclass
class User:
    id: uuid.UUID = field(init=False)
    email: str
    password: str

    def __post_init__(self) -> None:
        self.id = uuid.uuid4()
