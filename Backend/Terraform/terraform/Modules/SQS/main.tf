resource "aws_sqs_queue" "file_upload_queue" {
  name = var.queue_name
}

data "aws_iam_policy_document" "queue" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.file_upload_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.upload_bucket_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "file_upload_queue_policy" {
  queue_url = aws_sqs_queue.file_upload_queue.id
  policy    = data.aws_iam_policy_document.queue.json
}
