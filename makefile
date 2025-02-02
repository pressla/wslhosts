# Define scripts
SCRIPTS = register-github.sh install-wslhosts.sh
# Define the alias to be inserted
ALIAS = "alias fz='fzf --preview \"batcat --style numbers --color always {}\"'"

# Default target - make all scripts executable
all: $(SCRIPTS) insert-alias

# Make each script executable
.PHONY: $(SCRIPTS)
$(SCRIPTS):
	@chmod +x $@
	@echo "Made $@ executable"

# Insert the alias into .bashrc or .zshrc
insert-alias:
	@echo "Inserting alias into .bashrc or .zshrc..."

	# Check for .bashrc or .zshrc and append the alias with a comment
	if [ -f ~/.bashrc ]; then \
		echo -e "\n# inserted by Makefile\n$(ALIAS)" >> ~/.bashrc; \
		echo "Alias added to ~/.bashrc"; \
	elif [ -f ~/.zshrc ]; then \
		echo -e "\n# inserted by Makefile\n$(ALIAS)" >> ~/.zshrc; \
		echo "Alias added to ~/.zshrc"; \
	else \
		echo "No recognized shell configuration file found (~/.bashrc or ~/.zshrc)"; \
	fi

# Clean target (remove any files, if needed)
clean:
	@echo "No files to clean"

.PHONY: all clean
