# Integration tests — uses real provider, requires credentials.
#
# Prerequisites:
#   GITHUB_TOKEN — Personal Access Token or GitHub App installation token
#   GITHUB_OWNER — (optional) GitHub organization or user to scope to
#
# These tests create real GitHub repositories.
# Repositories are automatically destroyed after test completion.

run "creates_repository_with_required_inputs" {
  command = apply

  variables {
    name = "tftest-basic"
  }

  assert {
    condition     = output.name == "tftest-basic" && output.html_url != ""
    error_message = "The repository should be created and expose a non-empty HTML URL."
  }
}

run "creates_repository_with_extended_config" {
  command = apply

  variables {
    name                   = "tftest-complete"
    description            = "Integration test repository"
    visibility             = "private"
    has_issues             = true
    topics                 = ["terraform", "testing"]
    delete_branch_on_merge = true
  }

  assert {
    condition     = output.name == "tftest-complete" && output.full_name != ""
    error_message = "The repository should be created with the extended configuration."
  }
}
