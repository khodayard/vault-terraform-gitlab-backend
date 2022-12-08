variable project { default="xxx" }

variable stage { default="xxx" }

variable sz { default="xxxx" }

variable "domains" {
  type = map(object({
    name     = string
    url = string
    mount = string
  }))
  default = {
    "control" = {
      name     = "xxx"
      url = "ldap://xxxx"
      mount = "xx"
    }
    "digen" = {
      name     = "xx"
      url = "ldap://xxxx"
      mount = "xxx"
    }
  }
}

variable "users" {
  type = map(object({
    name     = string
    var1 = string
    var2 = string
  }))
  default = {
    "user1" = {
      name     = "user11"
      var1 = "xxxx"
      var2 = "xxx"
    }
    "user2" = {
      name     = "user22"
      var1 = "xx"
      var2 = "xx"

    }
  }
}