
help:
	@echo "Commands"
	@echo "--------"
	@echo "- compile: builds the extension using cython."
	@echo "- test: run python unittests."

compile:
	python setup.py build_ext --inplace

test:
	pytest tests/