# create terraform module with path to env folder
module "env" {
  source = "../env"
  for_each = toset(var.bg_list)
  # pass variables to module
  bg_indicator = each.value
}
