-include .env

apply: plan
	terraform apply $(TF_WORKSPACE).tfplan
	rm $(TF_WORKSPACE).tfplan

plan: init
	terraform plan --out $(TF_WORKSPACE).tfplan

init:
	terraform init

hash:
	cd csp && npm run hashjs

upload: hash
	aws s3 cp app/index.html s3://dev.huggingdog.com --profile rvc --metadata csp="$(CSP_HASH)"
	aws s3 sync app/ s3://dev.huggingdog.com/ --exclude="app/index.html" --cache-control="public, max-age=31536000, immutable" --profile rvc

invalidate:
	aws cloudfront create-invalidation --distribution-id "$(CF_ID)" --paths "/*" --profile rvc

lint:
	terraform validate

env:
	source .env
