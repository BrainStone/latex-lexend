# Variables
SRC_FONT_FILES        := $(wildcard font/fonts/ttf/*.ttf)
SRC_PACKAGE_FILES     := $(wildcard tex/*.sty)
TARGET_FONT_FILES     := $(SRC_FONT_FILES:font/fonts/ttf/%.ttf=lexend/font/%.ttf)
TARGET_FONTSPEC_FILES := $(TARGET_FONT_FILES:lexend/font/%-Regular.ttf=lexend/tex/%.fontspec)
TARGET_PACKAGE_FILES  := $(SRC_PACKAGE_FILES:tex/%.sty=lexend/tex/%.sty)

VERSION               := $(shell ./scripts/get_version.sh version)
TIMESTAMP             := $(shell ./scripts/get_version.sh timestamp)
DATE                  := $(shell date -d@$(TIMESTAMP) +%Y/%m/%d)

# Tasks
.PHONY: default setupWorkspace gitTag gitTagMinor gitTagMajor build
## We don't want make to try and remove files
.SECONDARY:
default: build

setupWorkspace:
	cp -afv .hooks/* .git/hooks/

gitTag:
	@./scripts/git_tag.sh

gitTagMinor:
	@MINOR=1 ./scripts/git_tag.sh

gitTagMajor:
	@MAJOR=1 ./scripts/git_tag.sh

build: lexend.zip

clean:
	@echo Cleaning build files:
	@rm -rfv lexend

# Files
lexend/:
	@echo Creating build directory:
	@mkdir -pv lexend

lexend/%/:
	@echo Creating $* directory:
	@mkdir -pv $@

lexend/%.md: %.md lexend/
	@echo Copying $*.md:
	@cp -v $< $@

lexend/font/%.ttf: font/fonts/ttf/%.ttf lexend/font/
	@echo Copying font file $*.ttf:
	@cp -v $< $@

lexend/tex/%.fontspec: tex/template.fontspec lexend/font/%-Regular.ttf lexend/tex/
	@echo Creating fontspec file for $*:
	@cp -v $< $@
	@sed -i "s/%FONTNAME%/$*/g" $@

lexend/tex/%.sty: tex/%.sty lexend/tex/
	@echo Copying package file $*.sty:
	@cp -v $< $@
	@sed -i -e "s/%VERSION%/$(VERSION)/g" -e "s@%DATE%@$(DATE)@g" $@

lexend/doc/lexend.tex: doc/lexend.tex CHANGELOG.md lexend/doc/
	@echo Copying documentation file lexend.tex:
	@cp -v $< $@
	@echo Replacing placeholders in lexend.tex
	@pandoc CHANGELOG.md -f markdown -o lexend/doc/.CHANGELOG.tex -t latex --columns 100
	@sed -i 's/\\subsection/\\subsection*/g' lexend/doc/.CHANGELOG.tex 
	@sed -i -e "s/%VERSION%/$(VERSION)/g" -e '/%CHANGELOG%/ {' -e 'r lexend/doc/.CHANGELOG.tex' -e 'd' -e '}' $@
	@rm lexend/doc/.CHANGELOG.tex

lexend/doc/lexend.pdf: $(TARGET_FONT_FILES) $(TARGET_FONTSPEC_FILES) $(TARGET_PACKAGE_FILES) lexend/doc/lexend.tex
	@echo Rendering documentation file pdf:
	@./scripts/render_doc.sh $^

lexend.zip: lexend/README.md $(TARGET_FONT_FILES) $(TARGET_FONTSPEC_FILES) $(TARGET_PACKAGE_FILES) lexend/doc/lexend.tex lexend/doc/lexend.pdf
	@echo Creating final lexend.zip:
	@zip -r lexend.zip lexend
