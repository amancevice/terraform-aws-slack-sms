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

variable "callback_id" {
  description = "Slack callback ID."
  default     = ""
}

variable "publish_policy_arn" {
  description = "ARN of group SMS publish policy."
}

variable "role_name" {
  description = "Name of slash command role."
  default     = ""
}

variable "role_path" {
  description = "Path for slash command role role."
  default     = ""
}

variable "secret" {
  description = "Name of Slackbot secret in AWS SecretsManager."
}

variable "secrets_policy_arn" {
  description = "Slackbot KMS key decryption permission policy ARN."
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

variable "slash_command_dialog_element_hint" {
  description = "Dialog textarea hint."
  default     = "This will send a text to a group."
}

variable "slash_command_dialog_element_label" {
  description = "Dialog textarea label."
  default     = "Message"
}

variable "slash_command_dialog_element_max_length" {
  description = "Dialog textarea max characters."
  default     = 160
}

variable "slash_command_dialog_title" {
  description = "Dialog title."
  default     = "Group SMS"
}

variable "slash_command_lambda_description" {
  description = "Lambda function description."
  default     = "Open dialog to send SMS message."
}

variable "slash_command_lambda_function_name" {
  description = "Lambda function name"
  default     = ""
}

variable "slash_command_lambda_memory_size" {
  description = "Lambda function memory size."
  default     = 512
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

variable "target_topic_arn" {
  description = "ARN of target SNS topic for sending SMS messages."
}

variable "sms_description" {
  description = "Lambda function description."
  default     = "Forward SMS message to SNS topic for sending."
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
