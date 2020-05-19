resource "aws_alb" "application_load_balancer" {
  name               = "test-lb-tf" #  NOME DO LOAD BALANCER
  load_balancer_type = "application"
  subnets = [ # Referenciando as  subnets
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  # Referenciando o  security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Criando 1 security group, Especifico para o load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80 # Libera trafego na 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # trafego de todas as origens
  }

  egress {
    from_port   = 0 # SAIDA POR QUALQUER PORTA
    to_port     = 0 # SAIDA POR QUALQUER PORTA
    protocol    = "-1" # SAIDA POR QUALQUER PROTOCOLO
    cidr_blocks = ["0.0.0.0/0"] # SAIDA POR QUALQUER IP 
  }
}
