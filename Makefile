PYTHON=`which python`
DESTDIR=/
PROJECT=simple_log_messaging
BUILDDIR=$(CURDIR)/$(PROJECT)
BINDIR=$(CURDIR)/$(PROJECT)/bin
LIBDIR=$(CURDIR)/$(PROJECT)/lib
TOOLSDIR=$(CURDIR)/$(PROJECT)/tools

RM=/usr/bin/rm
BINDIR=$(CURDIR)/$(PROJECT)/bin

RM=/usr/bin/rm
CP=/usr/bin/cp

# $(PYTHON) setup.py build
# Generate a distributable package.
# Test this by installing locally - over and over!!!
all: cp_apps
	$(PYTHON) setup.py sdist

help:
	@echo "make - Build source distributable package. Test locally"
	@echo "make test - Run test suite. Capture with 'script' command."
	@echo "make install - install on local system"
	@echo "make buildrpm - Generate an rpm package"
	@echo "make backup - Create tgz backup one dir above base dir."
	@echo "make wc - Perform word count for ine counts."
	@echo "make clean - Get rid of scratch files"

source:
	$(PYTHON) setup.py sdist $(COMPIE)

test:
	(cd $(PROJECT); ./runTests.sh)

cp_apps:
	$(CP) $(TOOLSDIR)/listeningPort.py $(BINDIR)/listeningPort
	$(CP) $(LIBDIR)/logCollector.py    $(BINDIR)/logCollector
	$(CP) $(LIBDIR)/logFilterApp.py    $(BINDIR)/logFilterApp
	$(CP) $(LIBDIR)/logCmd.py          $(BINDIR)/logCmd

install:
	$(PYTHON) setup.py install --root $(DESTDIR) $(COMPILE)

buildrpm:
	$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

wc:
	$(PROJECT)/tools/wc.sh

lsfiles:
	-for APP in logCollector listeningPort logCmd logFilterApp; do \
		ls -l /home/cecilm/anaconda/bin/$$APP ; \
		ls -l /usr/bin/$$APP ; \
	done
	ls -lh /home/cecilm/anaconda/lib/python2.7/site-packages/$(PROJECT)-1.0.0-py2.7.egg

backup:
	$(PROJECT)/tools/backup.sh

clean:
	$(PYTHON) setup.py clean
	$(RM) -rf build/ dist/ $(PROJECT).egg-info/
	find . -name '*.pyc' -delete
	find . -name '*.pyo' -delete
	find . -name typescript -delete
	$(RM) $(BINDIR)/listeningPort
	$(RM) $(BINDIR)/logCollector
	$(RM) $(BINDIR)/logFilterApp
	$(RM) $(BINDIR)/logCmd
	sudo $(RM) -rf /usr/lib/python2.7/site-packages/$(PROJECT)
	sudo $(RM) -rf /usr/lib/python2.7/site-packages/$(PROJECT)-*
	-for APP in logCollector listeningPort logCmd logFilterApp; do \
		$(RM) -f /home/cecilm/anaconda/bin/$$APP || true; \
		sudo $(RM) -f /usr/bin/$$APP || true; \
	done
	$(RM) -rf /home/cecilm/anaconda/lib/python2.7/site-packages/$(PROJECT)-1.0.0-py2.7.egg

