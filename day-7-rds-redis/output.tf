output "rds_port" {
  value = aws_db_instance.db_instance.port
}

output "redis_port" {
  value = aws_elasticache_serverless_cache.redis.endpoint[0].port
}

output "rds_endpoint" {
  description = "Primary MySQL RDS endpoint"
  value       = aws_db_instance.db_instance.address
}

output "redis_endpoint" {
  description = "Serverless Redis endpoint"
  value       = aws_elasticache_serverless_cache.redis.endpoint[0].address
}