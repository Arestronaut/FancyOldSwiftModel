prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: fancyoldswiftmodel

fancyoldswiftmodel: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: fancyoldswiftmodel
	@install -d "$(bindir)" "$(libdir)"
	@install "$(BUILDDIR)/release/fancyoldswiftmodel" "$(bindir)"

.PHONY: portable_zip
portable_zip: fancyoldswiftmodel
	rm -f "$(BUILDDIR)/release/portable_fancyoldswiftmodel.zip"
	zip -j "$(BUILDDIR)/release/portable_fancyoldswiftmodel.zip" "$(BUILDDIR)/release/fancyoldswiftmodel" "$(REPODIR)/LICENSE"
	echo "Portable ZIP created at: $(BUILDDIR)/release/portable_fancyoldswiftmodel.zip"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/fancyoldswiftmodel"

.PHONY: clean
distclean:
	@rm -f $(BUILDDIR)/release

.PHONY: clean
clean: distclean
	@rm -rf $(BUILDDIR)