from pydantic import BaseModel


class Book(BaseModel):
    isbn: str
    published: int
    authors: list[str]
    title: str
