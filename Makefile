.PHONY: test

# Headless-nvim plugin test. Set WYN=/path/to/wyn to exercise the LSP checks
# (otherwise they skip gracefully).
test:
	@bash tests/run.sh
