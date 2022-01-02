
help:
	@echo "Commands"
	@echo "--------"
	@echo "- build: builds the extension using cython."
	@echo "- test: run python unittests."

build:
	python setup.py build_ext --inplace

test:
	pytest tests/