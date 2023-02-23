.PHONY: test
test:
	DATABASE_URL="postgresql://library_user:library_user@127.0.0.1/library_test" \
		pipenv run pytest tests

.PHONY: serve
serve:
	pipenv run uvicorn src:app --port 8008 --reload

.PHONY: build
build:
	docker build . -t digital_library

.PHONY: library-up
library-up:
	docker-compose -f ./library.yml up -d


.PHONY: library-down
library-down:
	docker-compose -f ./library.yml down

.PHONY: db-up
db-up:
	docker-compose -f ./db.yml up -d

.PHONY: db-down
db-down:
	docker-compose -f ./db.yml down
