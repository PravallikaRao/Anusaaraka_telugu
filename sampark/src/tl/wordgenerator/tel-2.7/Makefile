#
# Makefile -- compiling/copying/install/uninstall the module
#

PREFIX = $(setu)
SUBDIR = gen
.PHONY:$(SUBDIR)

# Program and Data files and directories.
DEST_BIN_PROG_DIR = $(PREFIX)/bin/tl/wordgenerator/tel
CPFR = cp -fr

# make all -- make programs, library, documentation, etc.
all:

# make compile -- Compiles the source code  
compile:$(SUBDIR)

$(SUBDIR):
	$(MAKE) -C $@ 


install:install-src

install-src:
	mkdir -p $(DEST_BIN_PROG_DIR)
#	mkdir -p $(DEST_BIN_PROG_DIR)/gen
	$(CPFR)  tests README INSTALL tel_gen.pl word_smt API ChangeLog data-src $(DEST_BIN_PROG_DIR)
	$(CPFR)  wordgen_converter.sh wordgen_converter_web.sh $(DEST_BIN_PROG_DIR)


# make install -- Install what all needs to be installed, copying the files from the packages tree to systemwide directories.# it installs the engine and the corpus, dictionary, etc.


# remove the module files from sampark
clean:uninstall
uninstall:
	$(MAKE) -C gen clean
	rm -fr $(DEST_BIN_PROG_DIR) 

.PHONY: all clean install uninstall install-src 
