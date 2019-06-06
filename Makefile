PACKAGE := $(shell perl -aF: -ne 'print, exit if s/^Package:\s+//' DESCRIPTION)
VERSION := $(shell perl -aF: -ne 'print, exit if s/^Version:\s+//' DESCRIPTION)
BUILD   := $(PACKAGE)_$(VERSION).tar.gz

.PHONY: doc build install test $(BUILD)

default: doc README

doc:
	Rscript -e 'devtools::document()'

build: $(BUILD)

$(BUILD): doc
	R CMD build .

check: $(BUILD)
	R CMD check --as-cran $<

check-cran: $(BUILD)
	R --interactive --no-save --args $< <<<'rhub::check_for_cran(commandArgs(T)[1], email="traversc@gmail.com")'

install:
	R CMD install .

test:
	Rscript -e 'devtools::test()'

manual: manual.pdf
manual.pdf: doc
	R CMD Rd2pdf --batch --output=$@ --force .

README: man/current_filename.Rd doc
	R CMD Rd2txt $< | perl -pe 's/_\x08//g' > $@
