.PHONY: test
test:
	pipenv run pytest tests

.PHONY: serve
serve:
	pipenv run uvicorn src:app --port 8080 --reload

.PHONY: build
build:
	docker build . -t digital_library

.PHONY: library-up
library-up:
	docker-compose -f ./library.yml up
