from fastapi import FastAPI

app = FastAPI()

from .routes import *  # NOQA: F401 F403 E402
