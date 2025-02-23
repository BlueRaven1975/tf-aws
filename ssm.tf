resource "aws_ssm_maintenance_window" "this" {
  cutoff      = 1
  description = "Patch Manager maintenance window"
  duration    = 3
  name        = "patch-manager"
  schedule    = "cron(30 20 ? * * *)"
}

resource "aws_ssm_maintenance_window_target" "this" {
  description   = "All instances"
  name          = "all-instances"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:tfe_workspace"
    values = ["tf-aws"]
  }

  window_id = aws_ssm_maintenance_window.this.id
}

resource "aws_ssm_maintenance_window_task" "this" {
  description     = "Apply patches to all instances"
  name            = "patch-all"
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
