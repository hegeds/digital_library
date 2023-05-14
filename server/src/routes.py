from typing import Annotated

from fastapi import Body, Depends, HTTPException, status
from fastapi.encoders import jsonable_encoder
from fastapi.security import OAuth2PasswordRequestForm


from . import app, get_configurations
from .models import Token, User
from .services import authenticate_user, create_access_token, create_user


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


@app.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    configurations=Depends(get_configurations)
):
    uow = configurations['uow']
    user = authenticate_user(uow, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token(user.id)
    return {"access_token": access_token, "token_type": "bearer"}


@app.post("/user/create", response_model=User, status_code=201)
async def create_user_api(
    email: Annotated[str, Body()],
    password: Annotated[str, Body()],
    configurations=Depends(get_configurations)
):
    uow = configurations['uow']

    try:
        user = create_user(uow, email, password)

        return jsonable_encoder(user, exclude=set(['password']))
    except ValueError as error:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=str(error)
        )
