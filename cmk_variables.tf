variable "key_vault_name" {
  type        = string
  description = "Name of the existing key vault. It is needed for encryption using customer managed key."
  default     = ""
}

variable "key_vault_rg_name" {
  type        = string
  description = "Name of the resource group in which key vault exists."
  default     = ""
}

variable "key_vault_key_name" {
  type        = string
  description = "Name of the existing key in key vault. It is needed for encryption using customer managed key."
  default     = ""
}