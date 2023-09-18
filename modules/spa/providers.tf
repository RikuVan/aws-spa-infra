provider "aws" {
  region = var.region
}

### separate provider for aws resources in us-east-1
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}