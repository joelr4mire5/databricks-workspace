
resource "aws_security_group" "workspace_sg" {
  name        = "${var.project_name}-workspace-security-group"
  description = "Inbound / Outbound for the workspace"
  vpc_id      = aws_vpc.main_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "outbound_rules_sg" {
  for_each                     = toset(["tcp", "udp"])
  security_group_id            = aws_security_group.workspace_sg.id
  referenced_security_group_id = aws_security_group.workspace_sg.id
  ip_protocol                  = each.key
  from_port   = 0
  to_port     = 65535
  description                  = "Self-permission access to ${each.value} port"
  depends_on                   = [aws_security_group.workspace_sg]
}

resource "aws_vpc_security_group_egress_rule" "outbound_rules_tcp" {
  for_each          = toset(["443", "3306", "6666", "2443", "8443", "8444", "8445", "8446", "8447", "8448", "8449", "8450", "8451"])
  security_group_id = aws_security_group.workspace_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = each.key
  to_port           = each.key
  description       = "TCP access to ${each.value} port"
  depends_on        = [aws_security_group.workspace_sg]
}

resource "aws_vpc_security_group_ingress_rule" "inbound_rules_sg" {
  for_each                     = toset(["tcp", "udp"])
  security_group_id            = aws_security_group.workspace_sg.id
  referenced_security_group_id = aws_security_group.workspace_sg.id
  ip_protocol                  = each.key
  from_port   = 0
  to_port     = 65535
  description                  = "Self-permission access to ${each.value} port"
  depends_on                   = [aws_security_group.workspace_sg]
}