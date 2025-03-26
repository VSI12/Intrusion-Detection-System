output "sqs_queue_arn" {
  value = aws_sqs_queue.file_upload_queue.arn
}

output "queue" {
  value = aws_sqs_queue.file_upload_queue.name
  description = "The name of the SQS queue"
}

output "queue_policy" {
  value = aws_sqs_queue_policy.file_upload_queue_policy.policy
  description = "The policy for the SQS queue"
  
}