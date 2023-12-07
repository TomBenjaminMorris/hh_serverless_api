resource "aws_instance" "web" {
   
  #checkov:skip=CKV_AWS_79:Metadata of EC2 Instance not required
  ami                    = "ami-0573ef119dcb77219"
  instance_type          = "t2.micro"
  key_name               = "demo"
  iam_instance_profile   = "demo-profile"
  
  #tfsec:ignore:aws-ec2-enforce-http-token-imds 
  metadata_options {
    
  }
}
