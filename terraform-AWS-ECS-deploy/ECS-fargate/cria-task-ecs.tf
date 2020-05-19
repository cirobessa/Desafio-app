resource "aws_ecs_task_definition" "task_aplicativos" {
  family                   = "task-aplicativos" # Nome da ECS  task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "task-aplicativos",
      "image": "874001116236.dkr.ecr.us-east-1.amazonaws.com/cb-counter",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8082,
          "hostPort": 8082
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Definindo o uso do Fargate
  network_mode             = "awsvpc"    # Declara a awsvpc  para o Fargate
  memory                   = 512         # Memoria reservada para o container 
  cpu                      = 256         # CPU reservada para o container
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
