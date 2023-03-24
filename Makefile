PROJECT_DIR    := $(shell pwd)
PROJECT_PARAMS := secrets/params.yaml
CHANNEL        := $(shell git branch --show-current)

MANIFEST_DIR := $(PROJECT_DIR)/manifests
MANIFESTS    := $(shell find $(MANIFEST_DIR) -name '*.yaml' -o -name '*.tgz')

app:
	@replicated app create online-boutique

lint: $(MANIFESTS)
	@replicated release lint --yaml-dir $(MANIFEST_DIR)

release: $(MANIFESTS)
ifndef $(RELEASE_NOTES)
	$(error RELEASE_NOTES not provided)
endif
ifndef $(VERSION)
	$(error VERSION not provided)
endif
	@replicated release create \
		--app ${REPLICATED_APP} \
		--token ${REPLICATED_API_TOKEN} \
		--version $(VERSION) \
		--release-notes "$(RELEASE_NOTES)" \
		--yaml-dir $(MANIFEST_DIR) \
		--ensure-channel
		--promote $(CHANNEL)

install:
	@kubectl kots install ${REPLICATED_APP}

