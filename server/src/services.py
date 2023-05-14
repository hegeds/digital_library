import uuid

from datetime import datetime, timedelta
from email_validator import validate_email, EmailNotValidError
from jose import jwt, JWTError

from .base.uow import AbstractUnitOfWork
from .models import User
from . import password_context, settings


user_creation_error = ValueError('Unable to create user!')


def create_user(
    uow: AbstractUnitOfWork,
    email: str,
    raw_password: str
):
    with uow:
        try:
            validate_email(email)
        except EmailNotValidError:
            raise user_creation_error

        validate_password(raw_password)

        if uow.users.getByEmail(email) is not None:
            raise user_creation_error

        password = password_context.hash(raw_password)
        user = User(email=email, password=password)
        uow.users.add(user)
        uow.commit()
        return user


def create_access_token(user_id: uuid.UUID, timestamp=datetime.now()):
    to_encode = {
        "sub": str(user_id),
        "exp": (
            timestamp
            + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        )
    }
    encoded_jwt = jwt.encode(
        to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM
    )
    return encoded_jwt


def authenticate_user(uow: AbstractUnitOfWork, email: str, raw_password: str):
    with uow:
        user = uow.users.getByEmail(email)

        if (
            user is None
            or not password_context.verify(raw_password, user.password)
        ):
            return None

        uow.commit()
        return user


def validate_token(uow: AbstractUnitOfWork, token: str):
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=settings.ALGORITHM
        )
        user_id = str(payload.get("sub"))
        if user_id is None:
            raise PermissionError('Invalid token provided!')
    except JWTError:
        raise PermissionError('Invalid token provided!')

    with uow:
        user = uow.users.get(uuid.UUID(user_id))

        if user is None:
            raise PermissionError('Invalid token provided!')


def validate_password(password: str):
    if (
        password is None
        or len(password) < settings.MINIMUM_PASSWORD_LENGTH
    ):
        raise user_creation_error
