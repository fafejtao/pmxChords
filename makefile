BASE_DIR=$(shell pwd)
DOC_DIR=$(BASE_DIR)/doc
EXAMPLE_DIR=$(BASE_DIR)/example
SCRIPTS_DIR=$(BASE_DIR)/scripts
TEX_DIR=$(BASE_DIR)/tex

BUILD_DIR=$(BASE_DIR)/build

TDS_DIR=$(BUILD_DIR)/tds
TDS_DOC_DIR=$(TDS_DIR)/doc/pmxchords
TDS_DOC_EXAMPLE_DIR=$(TDS_DOC_DIR)/examples
TDS_SCRIPTS_DIR=$(TDS_DIR)/scripts/pmxchords
TDS_TEX_DIR=$(TDS_DIR)/tex/generic/pmxchords

CTAN_DIR=$(BUILD_DIR)/ctan
CTAN_PMXCHORDS_DIR=$(CTAN_DIR)/pmxchords
CTAN_PMXCHORDS_DOC_DIR=$(CTAN_PMXCHORDS_DIR)/doc
CTAN_PMXCHORDS_SCRIPTS_DIR=$(CTAN_PMXCHORDS_DIR)/scripts
CTAN_PMXCHORDS_TEX_DIR=$(CTAN_PMXCHORDS_DIR)/tex


ctanZip : tdsZip
	mkdir -p $(CTAN_PMXCHORDS_DOC_DIR)
#
# copy pmxchords.tds.zip created by tdsZip step
#
	cp $(BUILD_DIR)/pmxchords.tds.zip $(CTAN_DIR)

#
# copy all examples from tds/doc/pmxchords except README file.
#
	cd $(TDS_DOC_DIR); cp -r --parents * $(CTAN_PMXCHORDS_DOC_DIR)
	rm $(CTAN_PMXCHORDS_DOC_DIR)/README

#
# copy Windows directory
#
	cd $(BASE_DIR); cp -r --parents Windows $(CTAN_PMXCHORDS_DIR)

#
# copy scripts
#
	mkdir $(CTAN_PMXCHORDS_SCRIPTS_DIR)
	cp $(TDS_SCRIPTS_DIR)/* $(CTAN_PMXCHORDS_SCRIPTS_DIR)

#
# copy tex
#
	mkdir $(CTAN_PMXCHORDS_TEX_DIR)
	cp $(TDS_TEX_DIR)/* $(CTAN_PMXCHORDS_TEX_DIR)

#
# copy README
#
	cp $(TDS_DOC_DIR)/README $(CTAN_PMXCHORDS_DIR)

#
# make final pmxchords.zip file
#
	cd $(CTAN_DIR); zip ../pmxchords.zip -r *


tdsZip : clean
	mkdir -p $(TDS_DOC_EXAMPLE_DIR)
#
# Copy all doc files
#
	cd $(EXAMPLE_DIR); find . -name \*.pmx -exec cp --parents {} $(TDS_DOC_EXAMPLE_DIR) \;
	cd $(EXAMPLE_DIR); find . -name \*.pdf -exec cp --parents {} $(TDS_DOC_EXAMPLE_DIR) \;
	cd $(EXAMPLE_DIR); find . -name README -exec cp --parents {} $(TDS_DOC_EXAMPLE_DIR) \;

	cp $(DOC_DIR)/* $(TDS_DOC_DIR)
	cp $(BASE_DIR)/README.tds $(TDS_DOC_DIR)/README

#
# Copy scripts
#
	mkdir -p $(TDS_SCRIPTS_DIR)
	cp $(SCRIPTS_DIR)/pmxchords.lua $(SCRIPTS_DIR)/ChordsTr.lua $(TDS_SCRIPTS_DIR)

#
# Copy tex files
#
	mkdir -p $(TDS_TEX_DIR)
	cp $(TEX_DIR)/* $(TDS_TEX_DIR)

#
# make zip file
#
	cd $(TDS_DIR); zip ../pmxchords.tds.zip -r * 



clean :
	rm -rf ${BUILD_DIR}

