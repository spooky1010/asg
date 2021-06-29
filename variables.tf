variable region {
  description = "region"
  default = "us-west-2"
}

variable env {
  description = "work environment"
  default = "dev"
}

variable instance_type {
  description = "instance type"
  default = "t2.micro"
}


variable asg_min_size {
  description = "min size asg group "
  default = "1"
}

variable asg_max_size {
  description = "max size asg group "
  default = "10"
}
