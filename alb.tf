resource "aws_lb_target_group_attachment" "target_1" {
  target_group_arn = "${module.application_load_balancer.alb_target_group_arn}"
  target_id        = "${aws_instance.webserver_az1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "target_2" {
  target_group_arn = "${module.application_load_balancer.alb_target_group_arn}"
  target_id        = "${aws_instance.webserver_az2.id}"
  port             = 80
}
