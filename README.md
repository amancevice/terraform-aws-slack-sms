# Slack SMS

Send group SMS messages from Slack slash commands.

## Quickstart

Create a `main.tf` file with the following contents:

```terraform
# main.tf

module "group_sms" {
  source             = "amancevice/group-sms/aws"
  topic_display_name = "MyOrg"
  topic_name         = "mysms"

  subscriptions = [
    "+19876543210",
    "+12345678910",
    "+15555555555",
    "..."
  ]
}

module "slackbot" {
  source                   = "amancevice/slackbot/aws"
  slack_verification_token = "<slack-verification-token>""
  callback_ids             = ["mysms"]
}

module "slack_sms" {
  source                              = "amancevice/slack-sms/aws"
  api_execution_arn                   = "${module.slackbot.api_execution_arn}"
  api_invoke_url                      = "${module.slackbot.api_invoke_url}"
  api_name                            = "${module.slackbot.api_name}"
  api_parent_id                       = "${module.slackbot.slash_commands_resource_id}"
  kms_key_id                          = "${module.slackbot.kms_key_id}"
  target_topic_arn                    = "${module.group_sms.topic_arn}"
  slack_verification_token            = "<slack-verification-token>"
  slack_web_api_token                 = "<slack-web-api-token>"
  slash_command                       = "mysms"
}
```

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```
