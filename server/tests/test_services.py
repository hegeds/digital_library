import pytest
import uuid

from datetime import datetime, timedelta
from unittest.mock import MagicMock
from jose import jwt

from src.services import (
    authenticate_user, create_access_token, create_user, validate_token
)
from src import password_context, settings


class TestCreateUser:
    def test_able_to_create_user(self, uow):
        email = 'test@mail.com'
        password = '12345678'

        user = create_user(uow, email, password)
        created_user = uow.users.calls[1][1][0]

        assert uow.calls[0] == ['commit']
        assert uow.users.calls[1][0] == 'add'
        assert created_user.email == email
        assert password_context.verify(password, created_user.password)
        assert user == created_user

    @pytest.mark.parametrize('invalid_email', [
        'test', 'test@mail', 'mail.com'
    ])
    def test_should_fail_if_invalid_email(self, uow, invalid_email):
        with pytest.raises(ValueError):
            create_user(uow, invalid_email, 'password')

    @pytest.mark.parametrize('invalid_password', [
        '', '1234567', None
    ])
    def test_should_fail_for_invalid_passoword(
        self, uow, invalid_password
    ):
        with pytest.raises(ValueError) as error:
            create_user(uow, 'test@mail.com', invalid_password)

            assert str(error) == 'Unable to create user!'

    def test_should_fail_for_duplicate_email(self, uow):
        email = 'test@mail.com'
        password = '12345678'

        uow.users.result = create_user(uow, email, password)

        with pytest.raises(ValueError) as error:
            create_user(uow, email, password)
            assert str(error) == 'Unable to create user!'


class TestAuthenticateUser:
    def test_authenticates_user(self, uow):
        password = '12345678'
        user = create_user(uow, 'test@mail.com', password)
        uow.users.result = user

        authenticated_user = authenticate_user(uow, user.email, password)

        assert authenticated_user == user

    def test_fails_if_email_not_found(self, uow):
        email = 'test@mail.com'
        uow.users.result = None

        authenticated_user = authenticate_user(uow, email, '')

        assert authenticated_user is None
        assert uow.users.calls.pop() == ['getByEmail', [email]]

    def test_fails_for_invalid_password(self, uow):
        user = create_user(uow, 'test@mail.com', '12345678')
        uow.users.result = user

        authenticated_user = authenticate_user(uow, user.email, '')

        assert authenticated_user is None


class TestValidateToken:
    def test_validates_correct_token(self, uow):
        user = create_user(uow, 'dummy@mail.com', '12345678')
        uow.users.result = user
        token = create_access_token(user.id)

        validate_token(uow, token)

    def test_fails_if_user_not_found(self, uow):
        user_id = uuid.uuid4()
        token = create_access_token(user_id)

        with pytest.raises(PermissionError):
            validate_token(uow, token)

    def test_failse_if_token_expired(self, uow):
        user_id = uuid.uuid4()
        token = create_access_token(user_id)

        with pytest.raises(PermissionError):
            validate_token(uow, token)


class TestCreateAccesToken:
    def test_creates_access_token(self, monkeypatch):
        token = 'token'
        user_id = uuid.uuid4()
        jwt.encode = MagicMock(return_value='token')
        timestamp = datetime(1212, 12, 12, 12, 12, 12)

        payload = {
            'sub': str(user_id),
            'exp': (
                timestamp
                + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
            )
        }

        created_token = create_access_token(user_id, timestamp)

        assert token == created_token
        jwt.encode.assert_called_once_with(
            payload,
            settings.SECRET_KEY,
            algorithm=settings.ALGORITHM
        )
