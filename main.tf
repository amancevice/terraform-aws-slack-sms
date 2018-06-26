provider "archive" {
  version = "~> 1.0"
}

locals {
  callback_id                        = "${coalesce("${var.callback_id}", "${replace("${var.slash_command}", "-", "_")}")}"
  log_arn_prefix                     = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
  role_name                          = "${coalesce("${var.role_name}", "${local.function_name}-role")}"
  role_inline_policy_name            = "${coalesce("${var.role_inline_policy_name}", "${local.role_name}-inline-policy")}"
  slack_verification_token_encrypted = "${element(coalescelist("${data.aws_kms_ciphertext.verification_token.*.ciphertext_blob}", list("${var.slack_verification_token}")), 0)}"
  slack_web_api_token_encrypted      = "${element(coalescelist("${data.aws_kms_ciphertext.web_api_token.*.ciphertext_blob}", list("${var.slack_web_api_token}")), 0)}"
  function_name                      = "${coalesce("${var.sms_function_name}", "slack-callback-${replace("${local.callback_id}", "_", "-")}")}"

  dialog {
    callback_id  = "${local.callback_id}"
    submit_label = "Send"
    title        = "${var.dialog_title}"
    elements     = [
      {
        hint       = "${var.dialog_element_hint}"
        label      = "${var.dialog_element_label}"
        max_length = "${var.dialog_element_max_length}"
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

data "aws_iam_policy_document" "inline" {
  statement {
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  }

  statement {
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${local.log_arn_prefix}:log-group:/aws/lambda/${aws_lambda_function.lambda.function_name}:*"
    ]
  }

  statement {
    actions   = ["sns:Publish"]
    resources = ["${module.group_sms.topic_arn}"]
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
  path               = "${var.role_path}"
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "${local.role_inline_policy_name}"
  role   = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.inline.json}"
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
      TOPIC_ARN   = "${module.group_sms.topic_arn}"
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
  source                          = "amancevice/slack-slash-command/aws"
  version                         = "0.1.0"
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
  auto_encrypt_tokens             = "${var.auto_encrypt_tokens}"
  kms_key_id                      = "${var.kms_key_id}"
  lambda_description              = "${var.slash_command_lambda_description}"
  lambda_function_name            = "${var.slash_command_lambda_function_name}"
  lambda_memory_size              = "${var.slash_command_lambda_memory_size}"
  lambda_tags                     = "${var.slash_command_lambda_tags}"
  lambda_timeout                  = "${var.slash_command_lambda_timeout}"
  role_name                       = "${var.slash_command_role_name}"
  role_path                       = "${var.slash_command_role_path}"
  role_inline_policy_name         = "${var.slash_command_role_inline_policy_name}"
  response_type                   = "dialog"
  response                        = "${local.dialog}"
  slack_verification_token        = "${local.slack_verification_token_encrypted}"
  slack_web_api_token             = "${local.slack_web_api_token_encrypted}"
  slash_command                   = "${var.slash_command}"
}

module "group_sms" {
  source                                = "amancevice/group-sms/aws"
  version                               = "0.3.0"
  default_sender_id                     = "${var.group_sms_default_sender_id}"
  default_sms_type                      = "${var.group_sms_default_sms_type}"
  delivery_status_iam_role_arn          = "${var.group_sms_delivery_status_iam_role_arn}"
  delivery_status_success_sampling_rate = "${var.group_sms_delivery_status_success_sampling_rate}"
  monthly_spend_limit                   = "${var.group_sms_monthly_spend_limit}"
  role_name                             = "${var.group_sms_role_name}"
  subscriptions                         = ["${var.group_sms_subscriptions}"]
  topic_display_name                    = "${var.group_sms_topic_display_name}"
  topic_name                            = "${local.callback_id}"
  usage_report_s3_bucket                = "${var.group_sms_usage_report_s3_bucket}"
}
