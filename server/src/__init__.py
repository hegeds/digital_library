from functools import lru_cache

from fastapi import FastAPI
from pydantic import BaseSettings

from .api import BOOK_APIS


class Settings(BaseSettings):
    configured_apis = BOOK_APIS
    database_url = "postgresql://library_user:library_user@127.0.0.1/library"


settings = Settings()
app = FastAPI()


@lru_cache()
def get_settings():
    return settings


from .routes import *  # NOQA: F401 F403 E402
