FROM python:3.11-alpine

EXPOSE 8000

ADD . /server
WORKDIR /server

RUN  pip install pipenv
RUN pipenv install --deploy

CMD pipenv run uvicorn src:app --port 8000 --host 0.0.0.0
