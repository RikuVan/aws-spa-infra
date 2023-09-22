apply: plan
	terraform apply $(TF_WORKSPACE).tfplan
	rm $(TF_WORKSPACE).tfplan

plan: init
	terraform plan --out $(TF_WORKSPACE).tfplan

init:
	terraform init

hash:
	cd csp && npm run hashjs

lint:
	terraform validate
