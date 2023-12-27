# this terraform block is for the tfstate, i guess to connect to the bucket
# it involves bucket and a table in dynamodb, to save states of terraform
# in case there are certain development stages.

terraform {
    backend "s3" {
        bucket = "tfstate-bucket-ariel" # the name of the bucket
        key = "eu-west-2/states/terraform.tfstate" # these are the folders inside the bucket
        # state can't get variables, because its a fixed state.not changable.
        region = "eu-west-2"
        dynamodb_table = "ariel-terraform-statelock"
        encrypt = true
    }
}




provider "aws" {
    region = "eu-west-2"
}
