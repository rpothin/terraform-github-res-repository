mock_provider "github" {}

run "valid_minimal_plan" {
  command = plan

  variables {
    name = "my-repo"
  }

  assert {
    condition     = output.name == "my-repo"
    error_message = "Output name should match the provided repository name."
  }
}

run "rejects_empty_name" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [
    var.name,
  ]
}

run "rejects_name_with_spaces" {
  command = plan

  variables {
    name = "my repo"
  }

  expect_failures = [
    var.name,
  ]
}

run "rejects_name_with_exclamation" {
  command = plan

  variables {
    name = "my-repo!"
  }

  expect_failures = [
    var.name,
  ]
}

run "rejects_name_too_long" {
  command = plan

  variables {
    name = join("", [for i in range(101) : "a"])
  }

  expect_failures = [
    var.name,
  ]
}

run "default_visibility_is_private" {
  command = plan

  variables {
    name = "test-repo"
  }

  assert {
    condition     = var.visibility == "private"
    error_message = "Visibility should default to private."
  }
}

run "rejects_invalid_visibility" {
  command = plan

  variables {
    name       = "test-repo"
    visibility = "unknown"
  }

  expect_failures = [
    var.visibility,
  ]
}

run "accepts_public_visibility" {
  command = plan

  variables {
    name       = "test-repo"
    visibility = "public"
  }

  assert {
    condition     = github_repository.this.visibility == "public"
    error_message = "Repository visibility should be set to public."
  }
}

run "rejects_uppercase_topic" {
  command = plan

  variables {
    name   = "test-repo"
    topics = ["MyTopic"]
  }

  expect_failures = [
    var.topics,
  ]
}

run "rejects_topic_with_space" {
  command = plan

  variables {
    name   = "test-repo"
    topics = ["my topic"]
  }

  expect_failures = [
    var.topics,
  ]
}

run "rejects_topic_too_long" {
  command = plan

  variables {
    name   = "test-repo"
    topics = [join("", [for i in range(51) : "a"])]
  }

  expect_failures = [
    var.topics,
  ]
}

run "rejects_too_many_topics" {
  command = plan

  variables {
    name   = "test-repo"
    topics = [for i in range(1, 22) : format("topic-%02d", i)]
  }

  expect_failures = [
    var.topics,
  ]
}

run "rejects_duplicate_topics" {
  command = plan

  variables {
    name   = "test-repo"
    topics = ["terraform", "terraform"]
  }

  expect_failures = [
    var.topics,
  ]
}

run "rejects_invalid_merge_commit_title" {
  command = plan

  variables {
    name               = "test-repo"
    merge_commit_title = "INVALID"
  }

  expect_failures = [
    var.merge_commit_title,
  ]
}

run "rejects_invalid_merge_commit_message" {
  command = plan

  variables {
    name                 = "test-repo"
    merge_commit_message = "INVALID"
  }

  expect_failures = [
    var.merge_commit_message,
  ]
}

run "rejects_invalid_squash_commit_title" {
  command = plan

  variables {
    name                      = "test-repo"
    squash_merge_commit_title = "INVALID"
  }

  expect_failures = [
    var.squash_merge_commit_title,
  ]
}

run "rejects_invalid_squash_commit_message" {
  command = plan

  variables {
    name                        = "test-repo"
    squash_merge_commit_message = "INVALID"
  }

  expect_failures = [
    var.squash_merge_commit_message,
  ]
}

run "merge_commit_settings_null_when_disabled" {
  command = plan

  variables {
    name               = "test-repo"
    allow_merge_commit = false
  }

  assert {
    condition     = github_repository.this.merge_commit_message == null && github_repository.this.merge_commit_title == null
    error_message = "Merge commit settings should be null when merge commits are disabled."
  }
}

run "squash_commit_settings_null_when_disabled" {
  command = plan

  variables {
    name               = "test-repo"
    allow_squash_merge = false
  }

  assert {
    condition     = github_repository.this.squash_merge_commit_message == null && github_repository.this.squash_merge_commit_title == null
    error_message = "Squash merge settings should be null when squash merges are disabled."
  }
}

run "fork_requires_source_fields" {
  command = plan

  variables {
    name = "test-repo"
    fork = true
  }

  expect_failures = [
    github_repository.this,
  ]
}

run "template_rejects_auto_init_true" {
  command = plan

  variables {
    name      = "test-repo"
    auto_init = true
    template = {
      owner                = "some-org"
      repository           = "some-template"
      include_all_branches = false
    }
  }

  expect_failures = [
    github_repository.this,
  ]
}

run "template_succeeds_without_explicit_auto_init" {
  command = plan

  variables {
    name = "test-repo"
    template = {
      owner      = "some-org"
      repository = "some-template"
    }
  }

  assert {
    condition     = github_repository.this.auto_init == false
    error_message = "auto_init should be false when template is provided, even without explicitly setting auto_init."
  }
}

run "rejects_all_merge_strategies_disabled" {
  command = plan

  variables {
    name               = "test-repo"
    allow_merge_commit = false
    allow_squash_merge = false
    allow_rebase_merge = false
  }

  expect_failures = [
    github_repository.this,
  ]
}

run "rejects_advanced_security_on_public_repo" {
  command = plan

  variables {
    name       = "test-repo"
    visibility = "public"
    security_and_analysis = {
      advanced_security = { status = "enabled" }
    }
  }

  expect_failures = [
    github_repository.this,
  ]
}

run "output_name_matches_input" {
  command = plan

  variables {
    name = "output-test"
  }

  assert {
    condition     = output.name == "output-test"
    error_message = "Output name should match the input value."
  }
}
