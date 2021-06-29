## Choice and concept
AWS infrastructure has been developed using Terraform as IaC provider. The 'env' variable is used for specifying different development environments (dev, prod, staging), changing this value from ''dev" to "prod" helps with creating a different environment for developing products. Also, it's possible to change the region where infrastructure will be deployed.

In the absence of specific requirements and the need to create infrastructure for various languages and frameworks, the most common and varied infrastructure should be implemented.

Ec2 instances in autoscaling groups were chosen to simplify PoC and debugging. Also, it may be cheaper and more flexible, in most cases.

## Technical solutions
First, data is retrieved from existing VPC to create forward resources. Security groups are configured to manage communication with resources. Application load balancer is created and set up on port 80. It distributes traffic between scaled instances of the targetgroup.

Different CI/CD methods could be used to deploy applications. This project is using the Bash script as one of the possible options. Normally, deployment is done outside of the Terraform tasks and is handled by specific tools like Ansible for configuring, GitlabCI or Jenkins for building and deploying.

Auto Scaling group manages instance count through a scaling policy. The number of instances 
depends on cloudwatch metrics that apply to scale when CPU or memory utilization amount reaches 75% 2 periods 300s each. Scale down takes place when utilization decreases to 25%. Minimal and maximum number of instances is controlled with the corresponding variables ("asg_min_size"; "asg_max_size").

As a result, ALB DNS-name is generated. It should be used as a public network endpoint that routes all traffic to the application hosted on AWS infrastructure.

