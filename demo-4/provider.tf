# COnfigure the AWS PROVIDER
# access_key = "AKIAU77SCMU3IVJGCAGC"
# secret_key = "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"
# region     = "eu-west-2"
provider "aws" {

    region     = "${var.region}"
}