.EXPORT_ALL_VARIABLES:

# Build the PHP runtimes
runtimes:
	cd runtime && make publish

docker-images:
	cd runtime && make build
	docker push bref/php-72
	docker push bref/php-72-fpm
	docker push bref/php-72-fpm-dev
	docker push bref/php-73
	docker push bref/php-73-fpm
	docker push bref/php-73-fpm-dev
	docker push bref/fpm-dev-gateway

# Generate and deploy the production version of the website using http://couscous.io
website:
	# See http://couscous.io/
	couscous generate
	netlify deploy --prod --dir=.couscous/generated
website-staging:
	couscous generate
	netlify deploy --dir=.couscous/generated

# Run a local preview of the website using http://couscous.io
website-preview:
	couscous preview

website-assets: website/template/output.css
website/template/output.css: website/node_modules website/template/styles.css website/tailwind.js
	./website/node_modules/.bin/tailwind build website/template/styles.css -c website/tailwind.js -o website/template/output.css
website/node_modules:
	yarn install

# Deploy the demo functions
demo:
	serverless deploy

layers.json:
	php runtime/layer-list.php

.PHONY: runtimes website website-preview website-assets demo layers.json
