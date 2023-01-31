from fastapi import HTTPException

from . import app


@app.get("/books/search/{isbn}")
async def search_book():
    raise HTTPException(status_code=404, detail="Book not found")
