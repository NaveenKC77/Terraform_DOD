# resource "null_resource" "main" {
#   triggers = {
#     updated_at = timestamp()
#   }

#   provisioner "local-exec" {
#     command     = "dir"
#     working_dir = "${path.module}/../"
#   }
# }

# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "Nabin779"
#     workspaces {
#       prefix = "mail-user-"
#     }
#   }
# }