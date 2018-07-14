provider "archive" {
  version = "~> 1.0"
}

locals {
  callback_id   = "${coalesce("${var.callback_id}", "${replace("${var.slash_command}", "-", "_")}")}"
  function_name = "${coalesce("${var.sms_function_name}", "slack-${var.api_name}-callback-${replace("${local.callback_id}", "_", "-")}")}"
  lambda_policy = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role_name     = "${coalesce("${var.role_name}", "${local.function_name}-role")}"
  role_path     = "${coalesce("${var.role_path}", "/${var.api_name}/")}"

  dialog {
    callback_id  = "${local.callback_id}"
    submit_label = "Send"
    title        = "${var.slash_command_dialog_title}"
    elements     = [
      {
        hint       = "${var.slash_command_dialog_element_hint}"
        label      = "${var.slash_command_dialog_element_label}"
        max_length = "${var.slash_command_dialog_element_max_length}"
        name       = "${local.callback_id}"
        type       = "textarea"
      }
    ]
  }
}

data "archive_file" "package" {
  type        = "zip"
  output_path = "${path.module}/dist/package.zip"
  source_dir  = "${path.module}/src"
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_region" "current" {
}

data "aws_sns_topic" "trigger" {
  name = "slack_callback_${local.callback_id}"
}

resource "aws_iam_role" "role" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
  name               = "${local.role_name}"
  path               = "${local.role_path}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "${local.lambda_policy}"
  role       = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "publish" {
  policy_arn = "${var.publish_policy_arn}"
  role       = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "secrets" {
  policy_arn = "${var.secrets_policy_arn}"
  role       = "${aws_iam_role.role.name}"
}


resource "aws_lambda_function" "lambda" {
  description      = "${var.sms_description}"
  filename         = "${data.archive_file.package.output_path}"
  function_name    = "${local.function_name}"
  handler          = "index.handler"
  memory_size      = "${var.sms_memory_size}"
  role             = "${aws_iam_role.role.arn}"
  runtime          = "nodejs8.10"
  source_code_hash = "${data.archive_file.package.output_base64sha256}"
  tags             = "${var.sms_tags}"
  timeout          = "${var.sms_timeout}"

  environment {
    variables = {
      CALLBACK_ID = "${local.callback_id}"
      TOPIC_ARN   = "${var.target_topic_arn}"
    }
  }
}

resource "aws_lambda_permission" "trigger" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${data.aws_sns_topic.trigger.arn}"
  statement_id  = "AllowExecutionFromSNS"
}

resource "aws_sns_topic_subscription" "trigger" {
  topic_arn = "${data.aws_sns_topic.trigger.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda.arn}"
}

module "slash_command" {
  source                          = "amancevice/slackbot-slash-command/aws"
  version                         = "1.1.2"
  api_name                        = "${var.api_name}"
  api_execution_arn               = "${var.api_execution_arn}"
  api_invoke_url                  = "${var.api_invoke_url}"
  api_parent_id                   = "${var.api_parent_id}"
  auth_channels_exclude           = "${var.slash_command_auth_channels_exclude}"
  auth_channels_include           = "${var.slash_command_auth_channels_include}"
  auth_channels_permission_denied = "${var.slash_command_auth_channels_permission_denied}"
  auth_users_exclude              = "${var.slash_command_auth_users_exclude}"
  auth_users_include              = "${var.slash_command_auth_users_include}"
  auth_users_permission_denied    = "${var.slash_command_auth_users_permission_denied}"
  lambda_description              = "${var.slash_command_lambda_description}"
  lambda_function_name            = "${var.slash_command_lambda_function_name}"
  lambda_memory_size              = "${var.slash_command_lambda_memory_size}"
  lambda_tags                     = "${var.slash_command_lambda_tags}"
  lambda_timeout                  = "${var.slash_command_lambda_timeout}"
  role_arn                        = "${aws_iam_role.role.arn}"
  response_type                   = "dialog"
  response                        = "${local.dialog}"
  secret                          = "${var.secret}"
  slash_command                   = "${var.slash_command}"
}
