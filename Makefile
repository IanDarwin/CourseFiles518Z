all:
	@echo "SourceCode Makefile not created yet. But OK..."


check:
	for d in ex*solution; do rg -q '//T' $$d/* || echo "$$d might not have been marked up!"; done
