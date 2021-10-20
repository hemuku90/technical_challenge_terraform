variable "service_configuration" {
  default     = [
  {
    serviceName     = "possums-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-dev"
    mongoCollection = ["possums"]
  },
  {
    serviceName     = "numbats-data-store"
    mongoCluster    = "animals-mongo"
    mongoDatabase   = "marsupials-qa"
    mongoCollection = ["numbats"]
  }
]
  description = "description"
  type = list(object({
      serviceName    = string
      mongoCluster   = string
      mongoDatabase  = string
      mongoCollection = list(string)
    }))
}