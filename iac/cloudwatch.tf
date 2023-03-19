
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
    name = "every-5-minutes"
    description = "Fires every 5 minutes"
    schedule_expression = "rate(5 minutes)" # You can change timelapse!
}

resource "aws_cloudwatch_event_target" "lambda_mastadon_every_5_minutes" {
    rule = aws_cloudwatch_event_rule.every_5_minutes.name
    target_id = "lambda_mastadon"
    arn = aws_lambda_function.lambda_mastadon.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_mastadon" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_mastadon.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_5_minutes.arn
}

