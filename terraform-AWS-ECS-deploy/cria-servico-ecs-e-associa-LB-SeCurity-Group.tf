resource "aws_ecs_service" "service_aplicativos" {
  name            = "service-aplicativos" 
  cluster         = "${aws_ecs_cluster.cb_cluster.id}"   
  task_definition = "${aws_ecs_task_definition.task_aplicativos.arn}" 
  launch_type     = "FARGATE"
  desired_count   = 2  # QUANTIDADE DE CONTAINERS RODANDO

#### ASSOCIADO AO LOAD BALANCER
  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # APONTO o target group
    container_name   = "${aws_ecs_task_definition.task_aplicativos.family}"
    container_port   = 8082 # Porta do container 
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true 
  }
}


### CRIA SECURITY GROUP PARA O CONTAINER
resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Permite trafego de entrada somente do LOAD BALANCER 
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # PERMITINDO SAIDA de todas portas
    to_port     = 0 # PERMITINDO SAIDA por todas portas
    protocol    = "-1" #  PERMITINDO SAIDA por todas portas
    cidr_blocks = ["0.0.0.0/0"] # PERMITINDO SAIDA para todos os IPs
  }
}
