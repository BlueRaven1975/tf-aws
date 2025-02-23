resource "aws_ssm_default_patch_baseline" "this" {
  baseline_id      = aws_ssm_patch_baseline.this.id
  operating_system = aws_ssm_patch_baseline.this.operating_system
}

resource "aws_ssm_maintenance_window" "this" {
  cutoff      = 1
  description = "Production maintenance window"
  duration    = 3
  name        = "production"
  schedule    = "cron(0 1 ? * * *)"
}

resource "aws_ssm_maintenance_window_target" "this" {
  description   = "Production instances"
  name          = "production-instances"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:tfe_workspace"
    values = ["tf-aws"]
  }

  window_id = aws_ssm_maintenance_window.this.id
}

resource "aws_ssm_maintenance_window_task" "this" {
  description     = "Apply patches to production instances"
  name            = "production-patch"
  max_concurrency = 1
  max_errors      = 1
  priority        = 1

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.this.id]
  }

  task_arn = "AWS-RunPatchBaseline"

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = ["RebootIfNeeded"]
      }
    }
  }

  task_type = "RUN_COMMAND"
  window_id = aws_ssm_maintenance_window.this.id
}

resource "aws_ssm_patch_baseline" "this" {

  approval_rule {
    approve_after_days  = 0
    compliance_level    = "CRITICAL"
    enable_non_security = false

    patch_filter {
      key    = "PRODUCT"
      values = ["Ubuntu24.04"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Required"]
    }

  }

  approval_rule {
    approve_after_days  = 3
    compliance_level    = "HIGH"
    enable_non_security = false

    patch_filter {
      key    = "PRODUCT"
      values = ["Ubuntu24.04"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Important"]
    }

  }

  approval_rule {
    approve_after_days  = 7
    compliance_level    = "MEDIUM"
    enable_non_security = true

    patch_filter {
      key    = "PRODUCT"
      values = ["Ubuntu24.04"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Required", "Important", "Standard"]
    }

  }

  approval_rule {
    approve_after_days  = 15
    compliance_level    = "LOW"
    enable_non_security = true

    patch_filter {
      key    = "PRODUCT"
      values = ["Ubuntu24.04"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Optional"]
    }

  }

  description      = "Ubuntu patch baseline"
  name             = "ubuntu"
  operating_system = "UBUNTU"
}
