resource "random_password" "password" {
  count            = 2
  length           = 16
  special          = true
  override_special = "_%@"
}
##############################################################
########################  Outputs ###########################
##############################################################
locals {
connection_string = {
  for service in var.service_configuration: 
    service.serviceName => flatten([
      for password in random_password.password.*.result: 
      [
        for collection in service.mongoCollection: "mongodb+srv://${service.serviceName}:${password}@${service.mongoCluster}/${service.mongoDatabase}/${collection}"
      ]
    ])
  }
}

output connection_uri {
  value = local.connection_string 
}

