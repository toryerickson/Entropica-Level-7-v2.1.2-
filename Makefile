# EFM CODEX — Build System
# Version 2.1

.PHONY: all volumes appendices clean help

# Directories
LATEX_DIR = latex
BUILD_DIR = build/pdf
VOLUME_DIR = $(LATEX_DIR)/volumes
APPENDIX_DIR = $(LATEX_DIR)/appendices

# LaTeX compiler
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode -output-directory=$(BUILD_DIR)

# Source files
VOLUME_SOURCES = $(wildcard $(VOLUME_DIR)/*.tex)
APPENDIX_SOURCES = $(wildcard $(APPENDIX_DIR)/*.tex)

# Output files
VOLUME_PDFS = $(patsubst $(VOLUME_DIR)/%.tex,$(BUILD_DIR)/%.pdf,$(VOLUME_SOURCES))
APPENDIX_PDFS = $(patsubst $(APPENDIX_DIR)/%.tex,$(BUILD_DIR)/%.pdf,$(APPENDIX_SOURCES))

# Default target
all: setup volumes appendices
	@echo ""
	@echo "=== BUILD COMPLETE ==="
	@echo "PDFs generated in $(BUILD_DIR)/"
	@ls -la $(BUILD_DIR)/*.pdf 2>/dev/null || echo "No PDFs found"

# Create build directory
setup:
	@mkdir -p $(BUILD_DIR)
	@echo "Build directory ready: $(BUILD_DIR)"

# Build all volumes
volumes: setup $(VOLUME_PDFS)
	@echo "Volumes built successfully"

# Build all appendices
appendices: setup $(APPENDIX_PDFS)
	@echo "Appendices built successfully"

# Pattern rule for volumes
$(BUILD_DIR)/volume-%.pdf: $(VOLUME_DIR)/volume-%.tex
	@echo "Building $<..."
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/$(notdir $<) || true
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/$(notdir $<) || true

# Pattern rule for appendices
$(BUILD_DIR)/appendix-%.pdf: $(APPENDIX_DIR)/appendix-%.tex
	@echo "Building $<..."
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) appendices/$(notdir $<) || true
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) appendices/$(notdir $<) || true

# Individual targets
volume-i: setup
	@echo "Building Volume I..."
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-i.tex
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-i.tex

volume-ii: setup
	@echo "Building Volume II..."
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-ii.tex
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-ii.tex

volume-iii: setup
	@echo "Building Volume III..."
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-iii.tex
	@cd $(LATEX_DIR) && $(LATEX) $(LATEX_FLAGS) volumes/volume-iii.tex

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@find $(LATEX_DIR) -name "*.aux" -delete
	@find $(LATEX_DIR) -name "*.log" -delete
	@find $(LATEX_DIR) -name "*.toc" -delete
	@find $(LATEX_DIR) -name "*.out" -delete
	@echo "Clean complete"

# Deep clean (including all generated files)
distclean: clean
	@rm -rf build/
	@echo "Distribution clean complete"

# List available LaTeX sources
list:
	@echo "=== VOLUMES ==="
	@ls -1 $(VOLUME_DIR)/*.tex 2>/dev/null || echo "No volume sources"
	@echo ""
	@echo "=== APPENDICES ==="
	@ls -1 $(APPENDIX_DIR)/*.tex 2>/dev/null || echo "No appendix sources"

# Help
help:
	@echo "EFM CODEX Build System"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all         Build all PDFs (default)"
	@echo "  volumes     Build all volume PDFs"
	@echo "  appendices  Build all appendix PDFs"
	@echo "  volume-i    Build Volume I only"
	@echo "  volume-ii   Build Volume II only"
	@echo "  volume-iii  Build Volume III only"
	@echo "  clean       Remove build artifacts"
	@echo "  distclean   Remove all generated files"
	@echo "  list        List available LaTeX sources"
	@echo "  help        Show this help"
	@echo ""
	@echo "Prerequisites:"
	@echo "  - pdflatex (texlive-latex-extra)"
	@echo "  - texlive-fonts-extra"
	@echo ""
	@echo "Output: build/pdf/*.pdf"

# Validate markdown files exist
validate:
	@echo "=== VALIDATING DOCUMENTATION ==="
	@echo ""
	@echo "Volumes:"
	@test -f volumes/volume-i/README.md && echo "  ✓ Volume I" || echo "  ✗ Volume I MISSING"
	@test -f volumes/volume-ii/README.md && echo "  ✓ Volume II" || echo "  ✗ Volume II MISSING"
	@test -f volumes/volume-iii/README.md && echo "  ✓ Volume III" || echo "  ✗ Volume III MISSING"
	@echo ""
	@echo "Core Appendices:"
	@for f in A C I; do \
		test -f appendices/core/appendix-$$(echo $$f | tr 'A-Z' 'a-z')-*.md && \
		echo "  ✓ Appendix $$f" || echo "  ✗ Appendix $$f MISSING"; \
	done
	@echo ""
	@echo "v2.1 Appendices:"
	@for letter in B D E F G H J K L M N O P Q R; do \
		count=$$(ls appendices/v2.1/appendix-$$(echo $$letter | tr 'A-Z' 'a-z')-*.md 2>/dev/null | wc -l); \
		if [ $$count -gt 0 ]; then echo "  ✓ Appendix $$letter"; else echo "  ✗ Appendix $$letter MISSING"; fi; \
	done
	@echo ""
	@echo "Validation complete"

# Word/line counts
stats:
	@echo "=== DOCUMENTATION STATISTICS ==="
	@echo ""
	@echo "Volumes:"
	@wc -l volumes/*/README.md
	@echo ""
	@echo "Appendices:"
	@wc -l appendices/*/*.md | tail -1
	@echo ""
	@echo "Total Markdown files:"
	@find . -name "*.md" | wc -l
	@echo ""
	@echo "Total LaTeX files:"
	@find . -name "*.tex" | wc -l
