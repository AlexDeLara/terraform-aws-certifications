locals {
  region   = "us-east-1"
  vpc_cidr = "10.16.0.0/16"

  azs   = ["a", "b", "c"]
  tiers = ["reserved", "web", "db", "app"]

  vpc_sn = flatten([for iaz in local.azs : [for itier in local.tiers : { az = "${local.region}${iaz}", name = "sn-${itier}-${upper(iaz)}", public = itier == "web" ? true : false }]])

  ec2_key_name = "AH-TRAINING-AWS-GENERAL-A4L"

}
