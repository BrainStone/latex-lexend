# Variables
SRC_FONT_FILES        := $(wildcard font/fonts/ttf/*.ttf)
SRC_PACKAGE_FILES     := $(wildcard tex/*.sty)
TARGET_FONT_FILES     := $(SRC_FONT_FILES:font/fonts/ttf/%.ttf=lexend/font/%.ttf)
TARGET_FONTSPEC_FILES := $(TARGET_FONT_FILES:lexend/font/%-Regular.ttf=lexend/tex/%.fontspec)
TARGET_PACKAGE_FILES  := $(SRC_PACKAGE_FILES:tex/%.sty=lexend/tex/%.sty)

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

lexend/README.md: lexend/
	@echo Copying README.md:
	@cp -v README.md lexend/

lexend/font/%.ttf: font/fonts/ttf/%.ttf lexend/font/
	@echo Copying font file $*.ttf:
	@cp -v $< $@

lexend/tex/%.fontspec: lexend/font/%-Regular.ttf tex/template.fontspec lexend/tex/
	@echo Creating fontspec file for $*:
	@cp -v tex/template.fontspec $@
	@sed -i "s/%FONTNAME%/$*/g" $@

lexend/tex/%.sty: tex/%.sty lexend/tex/
	@echo Copying package file $*.sty:
	@cp -v $< $@

lexend.zip: lexend/README.md $(TARGET_FONT_FILES) $(TARGET_FONTSPEC_FILES) $(TARGET_PACKAGE_FILES)
	@echo Creating final lexend.zip:
	@zip -r lexend.zip lexend
