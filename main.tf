module "spa" {
  source = "./modules/spa"
  endpoint = "dev.huggingdog.com"
  domain_name = "huggingdog.com"
  region = var.region
  bucket_name = "dev.huggingdog.com"
}
