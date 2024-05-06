### Conditional resources


variable "int_tg_flag" {
    description = "internal TG flag"
    type = bool
    default = true
}


resource "aws_lb_target_group" "internal" {
                        #   true : false
    count = var.int_tg_flag ? 1 : 0 
    # so if count = 0 it won't create ANY resources, or destroy if it changed to 0
    name  = "tg-${var.name}-internal"
    port = var.tg_port
    protocol = var.tg_protocol
    vpc_id = var.vpc_id
}