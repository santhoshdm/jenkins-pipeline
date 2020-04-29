module "us-east-1" {
  source = "./modules/r53"
  
  providers = {
    aws = "aws.us-east-1"
  }
}