
CONTAINER_NAME = eigenlayer-contracts

.PHONY: install-hooks
install-hooks:
	cp bin/pre-commit.sh .git/hooks/pre-commit

.PHONY: install-deps
install-deps:
	./bin/install-deps.sh
	foundryup

.PHONY: deps
deps: install-hooks install-deps

.PHONY: compile
compile:
	forge b

.PHONY: bindings
bindings: compile
	./bin/compile-bindings.sh

.PHONY: all
all: compile bindings


docker:
	docker build --progress=plain -t ${CONTAINER_NAME}:latest .

compile-in-docker:
	docker run -v $(PWD):/build -w /build --rm -it ${CONTAINER_NAME}:latest bash -c "make compile"

bindings-in-docker:
	docker run -v $(PWD):/build -w /build --rm -it ${CONTAINER_NAME}:latest bash -c "make bindings"

all-in-docker:
	docker run -v $(PWD):/build -w /build --rm -it ${CONTAINER_NAME}:latest bash -c "make all"

gha-docker:
	docker run -v $(PWD):/build -w /build --rm -i ${CONTAINER_NAME}:latest bash -c "make all"
