variable "api_name" {
  description = "Slackbot REST API Gateway Name."
}

variable "api_execution_arn" {
  description = "Slackbot REST API Gateway deployment execution ARN."
}

variable "api_invoke_url" {
  description = "Slackbot REST API Gateway invocation URL."
}

variable "api_parent_id" {
  description = "Slackbot slash commands parent resource ID."
}

variable "auto_encrypt_tokens" {
  description = "Flag to automatically encrypt tokens."
  default     = true
}

variable "callback_id" {
  description = "Slack callback ID."
  default     = ""
}

variable "dialog_element_hint" {
  description = "Dialog textarea hint."
  default     = "This will send a text to a group."
}

variable "dialog_element_label" {
  description = "Dialog textarea label."
  default     = "Message"
}

variable "dialog_element_max_length" {
  description = "Dialog textarea max characters."
  default     = 140
}

variable "dialog_title" {
  description = "Dialog title."
  default     = "Group SMS"
}

variable "group_sms_default_sender_id" {
  description = "A custom ID, such as your business brand, displayed as the sender on the receiving device. Support for sender IDs varies by country."
  default     = ""
}

variable "group_sms_default_sms_type" {
  description = "Promotional messages are noncritical, such as marketing messages. Transactional messages are delivered with higher reliability to support customer transactions, such as one-time passcodes."
  default     = "Promotional"
}

variable "group_sms_delivery_status_iam_role_arn" {
  description = "The IAM role that allows Amazon SNS to write logs for SMS deliveries in CloudWatch Logs."
  default     = ""
}

variable "group_sms_delivery_status_success_sampling_rate" {
  description = "Default percentage of success to sample."
  default     = ""
}

variable "group_sms_monthly_spend_limit" {
  description = "The maximum amount to spend on SMS messages each month. If you send a message that exceeds your limit, Amazon SNS stops sending messages within minutes."
  default     = ""
}

variable "group_sms_role_name" {
  description = "The IAM role that allows Amazon SNS to write logs for SMS deliveries in CloudWatch Logs."
  default     = "SNSSuccessFeedback"
}

variable "group_sms_subscriptions" {
  description = "List of telephone numbers to subscribe to SNS."
  type        = "list"
  default     = []
}

variable "group_sms_topic_display_name" {
  description = "Display name of the AWS SNS topic."
}

variable "group_sms_usage_report_s3_bucket" {
  description = "The Amazon S3 bucket to receive daily SMS usage reports. The bucket policy must grant write access to Amazon SNS."
}

variable "kms_key_id" {
  description = "Slackbot KMS Key ID."
}

variable "role_inline_policy_name" {
  description = "Name of inline slash command role policy."
  default     = ""
}

variable "role_name" {
  description = "Name of role for slash command Lambda."
  default     = ""
}

variable "role_path" {
  description = "Path for slash command role."
  default     = "/service-role/"
}

variable "slack_verification_token" {
  description = "Slack verification token."
}

variable "slack_web_api_token" {
  description = "Slack Web API token."
}

variable "slash_command" {
  description = "Name of slash command."
}

variable "slash_command_auth_channels_exclude" {
  description = "Optional list of Slack channel IDs to blacklist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_channels_include" {
  description = "Optional list of Slack channel IDs to whitelist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_channels_permission_denied" {
  description = "Permission denied message for channels."
  type        = "map"

  default {
    text = "Sorry, you can't do that in this channel."
  }
}

variable "slash_command_auth_users_exclude" {
  description = "Optional list of Slack user IDs to blacklist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_users_include" {
  description = "Optional list of Slack user IDs to whitelist."
  type        = "list"
  default     = []
}

variable "slash_command_auth_users_permission_denied" {
  description = "Permission denied message for users."
  type        = "map"

  default {
    text = "Sorry, you don't have permission to do that."
  }
}

variable "slash_command_auto_encrypt_tokens" {
  description = "Flag to automatically encrypt tokens."
  default     = true
}

variable "slash_command_lambda_description" {
  description = "Lambda function description."
  default     = "Slack slash command handler."
}

variable "slash_command_lambda_function_name" {
  description = "Lambda function name"
  default     = ""
}

variable "slash_command_lambda_memory_size" {
  description = "Lambda function memory size."
  default     = 128
}

variable "slash_command_lambda_tags" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    deployment-tool = "terraform"
  }
}

variable "slash_command_lambda_timeout" {
  description = "Lambda function timeout."
  default     = 3
}

variable "slash_command_role_inline_policy_name" {
  description = "Name of inline Slackbot role policy."
  default     = ""
}

variable "slash_command_role_name" {
  description = "Name of role for Slackbot Lambdas."
  default     = ""
}

variable "slash_command_role_path" {
  description = "Path for Slackbot role."
  default     = "/service-role/"
}

variable "slash_command_response_type" {
  description = "Direct or dialog."
  default     = "direct"
}

variable "slash_command_response" {
  description = "Slack response object."
  type        = "map"

  default {
    text = "OK"
  }
}

variable "sms_description" {
  description = "Lambda function description."
  default     = "Slack slash command handler."
}

variable "sms_function_name" {
  description = "Lambda function name"
  default     = ""
}

variable "sms_memory_size" {
  description = "Lambda function memory size."
  default     = 128
}

variable "sms_tags" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    deployment-tool = "terraform"
  }
}

variable "sms_timeout" {
  description = "Lambda function timeout."
  default     = 3
}
