module "connection_uri"{
    source = "./connection_string_module"
}
output connection_url {
  value       = module.connection_uri
  sensitive   = false #This should ideally be True
  description = "Connection URL for MongoDB collections"
}
