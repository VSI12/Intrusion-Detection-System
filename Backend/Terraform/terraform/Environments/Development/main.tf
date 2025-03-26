module "s3" {
  source       = "../../modules/s3"
  bucket_name  = var.bucket_name
  environment  = var.environment
  queue_name   = var.queue_name
  queue_arn    = module.sqs.queue_arn
  queue_policy = module.sqs.queue_policy
}

module "sqs" {
  source            = "../../modules/sqs"
  queue_name        = var.queue_name
  upload_bucket_arn = module.s3.bucket_arn

}
