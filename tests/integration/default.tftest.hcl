# Integration tests — uses real provider, requires credentials.
#
# Prerequisites:
#   GITHUB_TOKEN  — Personal Access Token or GitHub App installation token.
#                   Requires `repo` scope for repository management.
#                   Requires `delete_repo` scope because these tests set archive_on_destroy = false
#                   so that teardown actually deletes repositories (clean slate for re-runs).
#                   In CI, sourced from repository secret GH_TOKEN.
#   GITHUB_OWNER  — (optional) GitHub organization or user to scope repository creation under.
#                   In CI, sourced from repository variable GH_OWNER.
#
# These tests create real GitHub repositories prefixed with "tftest-".
# archive_on_destroy is explicitly set to false so repositories are DELETED on teardown.
# Note: if a test run fails mid-execution, orphaned repositories may need manual cleanup via the GitHub UI or CLI.

run "creates_repository_with_required_inputs" {
  command = apply

  variables {
    name               = "tftest-basic-${formatdate("YYYYMMDDhhmmss", timestamp())}"
    archive_on_destroy = false
  }

  assert {
    condition     = startswith(output.name, "tftest-basic-") && output.html_url != ""
    error_message = "The repository should be created and expose a non-empty HTML URL."
  }
}

run "creates_repository_with_extended_config" {
  command = apply

  variables {
    name                   = "tftest-full-${formatdate("YYYYMMDDhhmmss", timestamp())}"
    description            = "Integration test repository"
    visibility             = "private"
    has_issues             = true
    topics                 = ["terraform", "testing"]
    delete_branch_on_merge = true
    archive_on_destroy     = false
  }

  assert {
    condition     = startswith(output.name, "tftest-full-") && output.full_name != ""
    error_message = "The repository should be created with the extended configuration."
  }
}
