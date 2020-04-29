provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "jenkins-devops-poc-backend"
    key    = "dev/backend"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "${var.profile}"
  alias   = "us-east-1"
  region  = "us-east-1"
}