resource "aws_db_instance" "nine" {
  allocated_storage           = 10
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "ramesh"
  parameter_group_name        = "default.mysql5.7"
}

resource "aws_elb" "ten" {
    name = "terraform-loadbalancer"
    availability_zones = ["us-east-1a", "us-east-1b"]

    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 5
        target              = "http:80/"
        interval            = 30
    }

    instances                 = ["${aws_instance.one.id}", "${aws_instance.two.id}"]
    cross_zone_load_balancing = true
    idle_timeout              = 400

    tags = {
        Name = "terraform-lb"
    }
}
