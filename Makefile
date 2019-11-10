.PHONY: default setupWorkspace gitTag gitTagMinor gitTagMajor build
default: build

# Files
lexend/:
	mkdir -p lexend

lexend/README.md: lexend/
	cp README.md lexend/

lexend.zip: lexend/ lexend/README.md
	zip -r lexend.zip lexend

# Tasks
setupWorkspace:
	cp -afv .hooks/* .git/hooks/

gitTag:
	@./scripts/git_tag.sh

gitTagMinor:
	@MINOR=1 ./scripts/git_tag.sh

gitTagMajor:
	@MAJOR=1 ./scripts/git_tag.sh

build: lexend.zip
