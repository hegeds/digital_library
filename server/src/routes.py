from fastapi import HTTPException, Depends

from . import app, get_settings


@app.get("/books/search/{isbn}")
async def search_book(isbn: str, settings=Depends(get_settings)):
    for api in settings.configured_apis:
        if book := api(isbn):
            return book

    raise HTTPException(status_code=404, detail="Book not found")
