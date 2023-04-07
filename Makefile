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

pipelines:
	@fly --target boutique set-pipeline --pipeline adservice --config ci/concourse/adservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline adservice
	@fly --target boutique set-pipeline --pipeline cartservice --config ci/concourse/cartservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline cartservice
	@fly --target boutique set-pipeline --pipeline checkoutservice --config ci/concourse/checkoutservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline checkoutservice
	@fly --target boutique set-pipeline --pipeline currencyservice --config ci/concourse/currencyservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline currencyservice
	@fly --target boutique set-pipeline --pipeline emailservice --config ci/concourse/emailservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline emailservice
	@fly --target boutique set-pipeline --pipeline frontend --config ci/concourse/frontend/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline frontend
	@fly --target boutique set-pipeline --pipeline paymentservice --config ci/concourse/paymentservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline paymentservice
	@fly --target boutique set-pipeline --pipeline productcatalogservice --config ci/concourse/productcatalogservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline productcatalogservice
	@fly --target boutique set-pipeline --pipeline recommendationservice --config ci/concourse/recommendationservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline recommendationservice
	@fly --target boutique set-pipeline --pipeline shippingservice --config ci/concourse/shippingservice/pipeline.yaml --non-interactive && fly -t boutique unpause-pipeline --pipeline shippingservice

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

stable:
	@nerdctl pull registry.shortrib.dev/online-boutique/adservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/adservice:edge registry.shortrib.dev/online-boutique/adservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/adservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/cartservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/cartservice:edge registry.shortrib.dev/online-boutique/cartservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/cartservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/checkoutservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/checkoutservice:edge registry.shortrib.dev/online-boutique/checkoutservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/checkoutservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/currencyservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/currencyservice:edge registry.shortrib.dev/online-boutique/currencyservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/currencyservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/emailservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/emailservice:edge registry.shortrib.dev/online-boutique/emailservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/emailservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/frontend:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/frontend:edge registry.shortrib.dev/online-boutique/frontend:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/frontend:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/paymentservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/paymentservice:edge registry.shortrib.dev/online-boutique/paymentservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/paymentservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/productcatalogservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/productcatalogservice:edge registry.shortrib.dev/online-boutique/productcatalogservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/productcatalogservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/recommendationservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/recommendationservice:edge registry.shortrib.dev/online-boutique/recommendationservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/recommendationservice:stable
	@nerdctl pull registry.shortrib.dev/online-boutique/shippingservice:edge \
		&& nerdctl tag registry.shortrib.dev/online-boutique/shippingservice:edge registry.shortrib.dev/online-boutique/shippingservice:stable \
		&& nerdctl push registry.shortrib.dev/online-boutique/shippingservice:stable
