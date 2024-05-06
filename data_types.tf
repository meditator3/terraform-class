String   


    variable name {
        type = string
        default = "Test"
    }

BOOL

    variable enabled {
        type = bool
        default  = false
    }

NUMBER


    variable count {
        type = number
        default = 0 # anything you want, amount of instances, etc.
    }

List

    variable ids {
        type = list
        default = [1,2,3]
    }

Map

    variable tags {
        type = map
        default = {
            "type" = "app"
            "mode" = "front"
        }
    }
