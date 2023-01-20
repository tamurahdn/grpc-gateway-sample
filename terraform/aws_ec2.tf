# /*
# DB見る踏み台用
# */
# resource "aws_instance" "demo_bastion_ec2" {
#   ami                    = "ami-09d28faae2e9e7138" # Amazon Linux 2
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.demo_public_subnet_a.id
#   vpc_security_group_ids = [aws_security_group.demo_ec2_sg.id]

#   tags = {
#     Name = "demo_bation_ec2"
#   }
# }

# //固定IP
# resource "aws_eip" "demo_ec2_eip" {
#   instance = aws_instance.demo_bastion_ec2.id
#   vpc      = true

#   tags = {
#     Name = "demo_eip"
#   }
# }

/*
ECS接続ALB周り
*/
//ターゲットグループ(ECS接続で利用)
resource "aws_lb_target_group" "demo_targetgroup" {
  name        = "demo-tag"
  port        = 15000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.demo_vpc.id

  health_check {
    enabled  = true
    path     = "/grpc/health"
    protocol = "HTTP"
    port     = "traffic-port"
    interval = 90
    timeout  = 60 // 間隔が狭過ぎるととhealth checkに失敗するので注意
  }
}

//Application Load Balancer(ECS接続で利用)
resource "aws_lb" "demo_alb" {
  name               = "demo-alb"
  internal           = false //internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo_alb_sg.id]
  //ループで書きたい
  subnets = [aws_subnet.demo_public_subnet_a.id, aws_subnet.demo_public_subnet_c.id]

  enable_deletion_protection = false

  tags = {
    Name = "demo_alb"
  }
}

resource "aws_lb_listener" "demo_alb_lisnter" {
  port     = "15000"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.demo_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_targetgroup.arn
  }

}