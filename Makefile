.PHONY: doc build install test

# Regenerate NAMESPACE and man/*.Rd using Roxygen via devtools
doc:
	Rscript -e 'devtools::document()'

build:
	R CMD build .

install:
	R CMD install .

test:
	Rscript -e 'devtools::test()'

manual: manual.pdf
manual.pdf: doc
	R CMD Rd2pdf --batch --output=$@ --force .
