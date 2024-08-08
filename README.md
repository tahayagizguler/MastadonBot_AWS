# Mastodon Bot using Terraform, AWS Lambda, S3, CloudWatch, and SSM

This code creates a Mastodon bot using AWS Lambda functions and Terraform infrastructure. The bot takes periodic screenshots from a preloaded video file and shares them on your Mastodon account at specified intervals.

The bot uses the S3 storage service to store the video file. AWS Lambda randomly selects screenshots stored in S3 and enables sharing. The bot is triggered periodically through AWS CloudWatch Events.

The bot's configuration is structured in the Terraform files. 

The bot runs using the Mastodon API. The Mastodon API access token is stored in the AWS SSM Parameter Store. This way, the token is securely stored and not directly exposed in the Terraform files.

This code could be used for promoting a product or announcing an event, for example. The periodic screenshots shared by the bot provide information about the event or product and attract potential customers' attention.


Here it is used to share screenshots from the movie Taxi Driver. [Click](https://botsin.space/@taxidriverframes) to access the bot!

## If you want to know more about this project, you should read [my blog post](https://dev.to/tahayagizguler/mastadon-bot-with-aws-lambda-s3-cloudwatch-and-ssm-2bmf)!
