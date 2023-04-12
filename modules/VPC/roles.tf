# Create an Iam role for ec2 instances
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = format("%s-aws-ec2-instance-assume-role-%s", var.name, var.environment)
    },
  )
}

# Create an Iam policy for ec2 instances
resource "aws_iam_policy" "policy" {
  name        = "ec2_instance_policy"
  description = "A test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]

  })

  tags = merge(
    var.tags,
    {
      Name = format("%s-aws-assume-policy-%s", var.name, var.environment)
    },
  )

}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.policy.arn
}

# Create an instance profile to attach the role to the ec2 instance
resource "aws_iam_instance_profile" "ip" {
  name ="aws_instance_profile_test"
  role = aws_iam_role.ec2_instance_role.name
}