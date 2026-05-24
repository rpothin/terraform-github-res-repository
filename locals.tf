locals {
  archived                    = var.lifecycle_state == "inactive" || var.archived
  merge_commit_message        = var.allow_merge_commit ? var.merge_commit_message : null
  merge_commit_title          = var.allow_merge_commit ? var.merge_commit_title : null
  squash_merge_commit_message = var.allow_squash_merge ? var.squash_merge_commit_message : null
  squash_merge_commit_title   = var.allow_squash_merge ? var.squash_merge_commit_title : null
}
