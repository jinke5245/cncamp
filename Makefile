###############################################################################
#
# host environment variables
#
###############################################################################

GO     ?= go
GOOS   ?= $(shell $(GO) env GOOS)
GOARCH ?= $(shell $(GO) env GOARCH)

###############################################################################
#
# project environment variables
#
###############################################################################

PROJECT_NAME           := $(shell $(GO) mod edit -print | grep -E '^module' | awk '{print $$2}')
PROJECT_BASENAME       := $(shell basename $(PROJECT_NAME))
PROJECT_VERSION        := $(shell cat version.txt)
PROJECT_REVISION       := $(shell git rev-parse HEAD)
PROJECT_REVISION_SHORT := $(shell git rev-parse --short HEAD)

PROJECT_DESCRIPTION    ?= advanced packaging management tools
PROJECT_MAINTAINER     := $(shell git config user.email)

###############################################################################
#
# project source paths
#
###############################################################################

PROJECT_SOURCE_DIR        := $(CURDIR)
PROJECT_TARGET_DIR        := $(PROJECT_SOURCE_DIR)/cmd
PROJECT_INIT_DIR          := $(PROJECT_SOURCE_DIR)/init
PROJECT_CONFIG_DIR        := $(PROJECT_SOURCE_DIR)/configs
PROJECT_BUILD_PACKAGE_DIR := $(PROJECT_SOURCE_DIR)/build/package

###############################################################################
#
# project output paths
#
###############################################################################

PROJECT_OUTPUT_BINARY_DIR         ?= $(PROJECT_SOURCE_DIR)/bin
PROJECT_OUTPUT_BINARY_CURRENT_DIR ?= $(PROJECT_OUTPUT_BINARY_DIR)
PROJECT_OUTPUT_DERIVED_TEMP_DIR   ?= $(PROJECT_SOURCE_DIR)/tmp
PROJECT_OUTPUT_PACKAGE_DIR        ?= $(PROJECT_SOURCE_DIR)/dist

###############################################################################
#
# default targets
#
###############################################################################

.NOTPARALLEL:


.PHONY: help
help:
	@echo "Usage of make [ build | package | clean ]"

################################################################################
#
# targets for clean phases
#
################################################################################

clean: clean.build clean.tmp clean.package

clean.build:
	@[ -d $(PROJECT_OUTPUT_BINARY_DIR) ] && rm -rf $(PROJECT_OUTPUT_BINARY_DIR) || true

clean.tmp:
	@[ -d $(PROJECT_OUTPUT_DERIVED_TEMP_DIR) ] && rm -rf $(PROJECT_OUTPUT_DERIVED_TEMP_DIR) || true

clean.package:
	@[ -d $(PROJECT_OUTPUT_PACKAGE_DIR) ] && rm -rf $(PROJECT_OUTPUT_PACKAGE_DIR) || true

.PHONY: clean clean.build clean.package

################################################################################
#
# targets for built phases
#
################################################################################

build: build.httpserver
build.httpserver: $(PROJECT_OUTPUT_BINARY_CURRENT_DIR)/httpserver

$(PROJECT_OUTPUT_BINARY_CURRENT_DIR)/%:
	@mkdir -p $(PROJECT_OUTPUT_BINARY_CURRENT_DIR)
	@$(GO) build -ldflags "-s -w" -o $(PROJECT_OUTPUT_BINARY_CURRENT_DIR)/$* $(PROJECT_TARGET_DIR)/$* || exit 1;
	@echo "built target $*"

.PHONY: build build.apmd build.apm
