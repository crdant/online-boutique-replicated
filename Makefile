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
ifndef RELEASE_NOTES
	$(error RELEASE_NOTES not provided)
endif
ifndef VERSION
	$(error VERSION not provided)
endif
	@replicated release create \
		--app ${REPLICATED_APP} \
		--token ${REPLICATED_API_TOKEN} \
		--version $(VERSION) \
		--release-notes "$(RELEASE_NOTES)" \
		--yaml-dir $(MANIFEST_DIR) \
		--ensure-channel \
		--promote $(CHANNEL)

install:
	@kubectl kots install ${REPLICATED_APP}/$(CHANNEL)

customers:
	@replicated customer create --channel Stable --expires-in 730h --name Klein-Stehr
	@replicated customer create --channel Stable --expires-in 17530h --name "Purdy Inc."
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name Treutel
	@replicated customer create --channel Stable --snapshot --expires-in 17530h --name "Casper Group"
	@replicated customer create --channel Beta --snapshot --expires-in 8766h --name Will-Kautzer
	@replicated customer create --channel Stable --snapshot --name Sipes-Erdman
	@replicated customer create --channel Stable --snapshot --expires-in 730h --name "Little and Sons"
	@replicated customer create --channel Stable --snapshot --expires-in 26300h --name "Ferry Group"
	@replicated customer create --channel Stable --snapshot --expires-in 2160h --name Bergstrom
	@replicated customer create --channel Beta --snapshot --expires-in 8766h --name "Schamberger, LLC"
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name Trantow-Carroll
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name "Swaniawski, Inc."
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name "Silver Fir"
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name Trueyx
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name Schowalter
	@replicated customer create --channel $(CHANNEL) --expires-in 26300h --name Halvorsen
	@replicated customer create --channel Beta --snapshot --expires-in 730h --name Spinka
	@replicated customer create --channel Beta --snapshot --expires-in 17530h --name Stehr
	@replicated customer create --channel $(CHANNEL) --expires-in 8766h --name Nienow
	@replicated customer create --channel Beta --expires-in 17530h --name Quitzon-Greenholt
	@replicated customer create --channel Stable --snapshot --expires-in 8766h --name Emmerich
	@replicated customer create --channel Stable --snapshot --name Gulgow
	@replicated customer create --channel Beta --expires-in 730h --name Vandervort
	@replicated customer create --channel Stable --snapshot --expires-in 26300h --name Langworth
