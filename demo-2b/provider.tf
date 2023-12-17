# COnfigure the AWS PROVIDER
# access_key = "AKIAU77SCMU3IVJGCAGC"
# secret_key = "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"
# region     = "eu-west-2"
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}