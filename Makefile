.PHONY: setupWorkspace gitTag gitTagMinor gitTagMajor

setupWorkspace:
	cp -afv .hooks/* .git/hooks/

gitTag:
	@./scripts/git_tag.sh

gitTagMinor:
	@MINOR=1 ./scripts/git_tag.sh

gitTagMajor:
	@MAJOR=1 ./scripts/git_tag.sh
