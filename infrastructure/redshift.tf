# resource "aws_redshift_cluster" "demo_redshift" {
#   cluster_identifier      = "redshift-cluster"
#   database_name           = "dev"
#   master_username         = "admin"
#   master_password         = "Password123456"
#   node_type               = "dc2.large"
#   cluster_type            = "single-node"
#   skip_final_snapshot     = true
# }
