all: XSB-TAGS CIAO-TAGS SWI-TAGS MERCURY-TAGS ECLIPSE-TAGS YAP-TAGS

# XSB 3.3.7

XSB_ROOT_DIR=~/xsb/3.3.7

XSB-TAGS:
	find $(XSB_ROOT_DIR)/packages -type f -name '*.P' | xargs etags -l prolog -o $@

# YAP 6.2.2

YAP_LIB_DIR=/usr/share/Yap

YAP-TAGS:
	find $(YAP_LIB_DIR) -type f | xargs etags -l prolog -o $@


# Ciao 1.14
CIAO_ROOT_DIR=~/CiaoDE

CIAO-TAGS:
	touch $@
	find $(CIAO_ROOT_DIR)/lib/ciao/ciao-1.14/library -type f -name '*.pl' | xargs etags -a -l prolog -o $@
	find $(CIAO_ROOT_DIR)/lib/ciao/ciao-1.14/contrib -type f -name '*.pl' | xargs etags -a -l prolog -o $@
	find $(CIAO_ROOT_DIR)/lib/ciao/ciao-1.14/lib -type f -name '*.pl' | xargs etags -a -l prolog -o $@

# SWI-PROLOG 6.0.2

SWI_ROOT_DIR=~/swi

SWI-TAGS:
	touch $@
	find $(SWI_ROOT_DIR)/lib/swipl-6.0.2/boot -type f -name '*.pl' | xargs etags -a -l prolog -o $@
	find $(SWI_ROOT_DIR)/lib/swipl-6.0.2/library -type f -name '*.pl' | xargs etags -a -l prolog -o $@
	find $(SWI_ROOT_DIR)/lib/swipl-6.0.2/xpce -type f -name '*.pl' | xargs etags -a -l prolog -o $@

# Mercury 13.05.2

MERCURY_SOURCE_DIR=~/source/packaging/mercury-srcdist-14.01

MERCURY-TAGS:
	touch $@
	mtags -e `find $(MERCURY_SOURCE_DIR)/ -type f -name '*.m'`
	mv TAGS $@

# ECLiPSe 6.0.199

ECLIPSE_ROOT_DIR=~/Eclipse_6.0_199

ECLIPSE-TAGS:
	touch $@
	find $(ECLIPSE_ROOT_DIR)/lib -type f -name '*.pl' -o -name '*.ecl' | xargs etags -a -l prolog -o $@
	find $(ECLIPSE_ROOT_DIR)/lib_tcl -type f -name '*.pl' -o -name '*.ecl' | xargs etags -a -l prolog -o $@
	find $(ECLIPSE_ROOT_DIR)/lib_public -type f -name '*.pl' -o -name '*.ecl' | xargs etags -a -l prolog -o $@


clean:
	rm -fv *TAGS *~

.PHONY: clean
