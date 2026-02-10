variable "sa_account_tier" {
  description = "The tier of the storage account. Possible values are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "sa_account_replication_type" {
  description = "The replication type of the storage account. Possible values are LRS, GRS, RAGRS, and ZRS."
  type        = string
  default     = "LRS"
}

variable "sa_name" {
  description = "The name of the storage account. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "ws_name" {
  description = "The name of the Log Analytics workspace. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "ai_name" {
  description = "The name of the Application Insights instance. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "asp_name" {
  description = "The name of the App Service Plan. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "fa_name" {
  description = "The name of the Function App. If blank, a random name will be generated."
  type        = string
  default     = ""
}

variable "runtime_name" {
  description = "The name of the language worker runtime."
  type        = string
  default     = "dotnet-isolated" # Allowed: dotnet-isolated, java, node, powershell, python
}

variable "runtime_version" {
  description = "The version of the language worker runtime."
  type        = string
  default     = "8.0" # Supported versions: see https://aka.ms/flexfxversions
}

variable "env" {
  description = "environment"
  type        = string
  default     = "development"
}