# Define scripts
SCRIPTS = register-github.sh install-wslhosts.sh

# Default target - make all scripts executable
all: $(SCRIPTS)

# Make each script executable
.PHONY: $(SCRIPTS)
$(SCRIPTS):
	@chmod +x $@
	@echo "Made $@ executable"

# Clean target (remove any files, if needed)
clean:
	@echo "No files to clean"

.PHONY: all clean
