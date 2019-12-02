resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example-HAProxy" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the public SSH key
  key_name      = aws_key_pair.mykey.key_name

  # the VPC subnet  
  subnet_id = aws_subnet.main-public.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]


  provisioner "file" {
    source      = "script_HA.sh"
    destination = "/tmp/script_HA.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script_HA.sh",
      "sudo /tmp/script_HA.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

}

resource "aws_instance" "example-Web-1" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the public SSH key
  key_name      = aws_key_pair.mykey.key_name

  # the VPC subnet
  subnet_id = aws_subnet.main-private.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]


  provisioner "file" {
    source      = "script_Apache.sh"
    destination = "/tmp/script_Apache.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script_Apache2.sh",
      "sudo /tmp/script_Apache2.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

}

resource "aws_instance" "example-Web-2" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the public SSH key
  key_name      = aws_key_pair.mykey.key_name

  # the VPC subnet
  subnet_id = aws_subnet.main-private.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]


  provisioner "file" {
    source      = "script_Apache.sh"
    destination = "/tmp/script_Apache.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script_Apache.sh",
      "sudo /tmp/script_Apache.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

}
