from functools import lru_cache
from fastapi import FastAPI
from pydantic import BaseSettings
from passlib.context import CryptContext
from sqlalchemy import create_engine

from .api import BOOK_APIS


class Settings(BaseSettings):
    configured_apis = BOOK_APIS
    database_url = "postgresql://library_user:library_user@127.0.0.1/library"


settings = Settings()
app = FastAPI()
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


@lru_cache
def get_configurations():
    from .api import BOOK_APIS  # NOQA F401
    from .database.uow import SQLUnitOfWork  # NOQA F401

    return {
        'uow': SQLUnitOfWork(create_engine(settings.database_url)),
        'configured_apis': BOOK_APIS
    }


from .routes import *  # NOQA: F401 F403 E402
