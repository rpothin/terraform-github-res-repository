module "this" {
  source = "rpothin/res-repository/github"

  name        = var.name
  description = var.description
  visibility  = var.visibility

  # Create from a template repository
  template = var.template

  # Repository features
  has_discussions = false
  has_issues      = true
  has_projects    = false
  has_wiki        = false

  # Merge strategy
  allow_merge_commit          = true
  allow_squash_merge          = true
  allow_rebase_merge          = false
  delete_branch_on_merge      = true
  merge_commit_title          = "PR_TITLE"
  merge_commit_message        = "PR_BODY"
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"

  # Topics
  topics = var.topics

  # Governance
  web_commit_signoff_required = true

  # Lifecycle management
  # To decommission this repository gracefully (archive instead of delete):
  #   1. Set lifecycle_state = "inactive" in your tfvars
  #   2. Run terraform plan && terraform apply  (archives the repository)
  #   3. Optionally run terraform destroy to clean up Terraform state
  #
  # lifecycle_state = "inactive"
}
