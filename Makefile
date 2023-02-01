# Dirs to run makehandsons in
MAKEHANDSONS_DIRS = ex31solution ex51solution ex61solution ex71solution ex81solution ex91solution
# Dirs to NEVER run makehandsons in
NEVER_MAKEHANDSONS_DIRS = ex21solution ex22solution ex32solution ex101solution
# These do not exist!
NONEXISTANT_DIRS = ex41solution

all:
	@echo "SourceCode Makefile not created yet. But OK..."

check:
	for d in $(MAKEHANDSONS_DIRS); do rg -q '//T' $$d/* || echo "$$d might not have been marked up!"; done
	for e in ${MAKEHANDSONS_DIRS}; do rg -q "^$${e%solution}\$$" .gitignore || echo "$${e%solution} not gitignored"; done

# This will FAIL if a directory already exists.
overwrite:
	makehandsons $(MAKEHANDSONS_DIRS)
