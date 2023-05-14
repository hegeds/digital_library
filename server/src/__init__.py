from functools import lru_cache
from fastapi import FastAPI
from pydantic import BaseSettings
from passlib.context import CryptContext
from sqlalchemy import create_engine


class Settings(BaseSettings):
    DATABASE_URL = "postgresql://library_user:library_user@127.0.0.1/library"
    MINIMUM_PASSWORD_LENGTH = 8
    # to get a string like this run:
    # openssl rand -hex 32
    SECRET_KEY = "dbdac2857bf1c560cebb245794d3ad1f957e3b2e3f06a17c4a7978762676560b" # NOQA E501
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 30


settings = Settings()
app = FastAPI()
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


@lru_cache
def get_configurations():
    from .api import BOOK_APIS  # NOQA F401
    from .database.uow import SQLUnitOfWork  # NOQA F401

    return {
        'uow': SQLUnitOfWork(create_engine(settings.DATABASE_URL)),
        'configured_apis': BOOK_APIS
    }


from .routes import *  # NOQA: F401 F403 E402
