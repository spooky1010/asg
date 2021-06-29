   IaC TERRAFORM INFRUSTRUCTURE
   
   We develop AWS infrastructure using Terraform to IaC. For developing different infrastructure (dev, prod, staging) we have variable "env", change its value from ''dev" to "prod" we can create a different environment for developing products. Also, we can change the region where deploying infrastructure.
   
   If we don't have specific requirements and need to create infrastructure for various languages and frameworks, we need to implement the most common and varied infrastructure. We choose ec2 instances in autoscaling groups. It's demonstrative, more simple for PoC and debugging . Also, it may be cheaper and more flexible, in most cases.

   At first, we get data from existing vpc to create forward resources. Create security groups to allow communication with resources.
Сreate the application load balancer, that balances traffic thru 80 port to our targetgroup application, and split traffic between scaled instances. ASG scales its capacity under workload, and we can connect them thru ALB.

   To deploy applications we can use different CI/CD methods. For example, we use the Bash script. But deployment isn't for terraform tasks, most commonly uses Ansible for configuring and gitlabCI or Jenkins for build and deploying.
   
   Autoscaling group manages instances count thru scaling policy. They depend on cloudwatch metrics that apply to scale when CPU or memory utilization amount 75% 2 periods 300s each. And scale down when utilization down to 25%. We can control min and max instance count by variables ("asg_min_size"; "asg_max_size").

   At last, we get outputs that contain ALB DNS name. Its endpoint to check and communicate with our infrastructure.
