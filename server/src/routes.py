from fastapi import HTTPException, Depends
from fastapi.encoders import jsonable_encoder

from . import app, get_configurations


@app.get("/books/search/{isbn}")
async def search_book(isbn: str, configurations=Depends(get_configurations)):
    uow = configurations['uow']

    with uow:
        if book := uow.books.getByISBN(isbn):
            return jsonable_encoder(book)

        for api in configurations['configured_apis']:
            if book := api(isbn):
                uow.books.add(book)
                uow.commit()
                return jsonable_encoder(book)

    raise HTTPException(status_code=404, detail="Book not found")
