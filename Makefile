# Dirs to run makehandsons in
MAKEHANDSONS_DIRS = ex31solution
# Dirs to NEVER run makehandsons in
NEVER_MAKEHANDSONS_DIRS = ex101solution

all:
	@echo "SourceCode Makefile not created yet. But OK..."

check:
	for d in $(MAKEHANDSONS_DIRS); do rg -q '//T' $$d/* || echo "$$d might not have been marked up!"; done


overwrite:
	makehandsons $(MAKEHANDSONS_DIRS)
