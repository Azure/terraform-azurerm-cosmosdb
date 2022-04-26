variable "identity" {
  type = object({
    enabled = bool
    type    = string
    id      = string
  })
  default = {
    enabled = false
    id      = ""
    type    = ""
  }
  description = "Identity block to enable either system assigned identity, user assigned identity or both. Type should be set to either: \"SystemAssigned\", \"UserAssigned\" or \"SystemAssigned,UserAssigned\""
}