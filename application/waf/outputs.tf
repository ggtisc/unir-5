output "waf_id" {
  value       = aws_wafv2_web_acl.app_waf.id
  description = "ID of the WAF Web ACL"
}

output "waf_arn" {
  value       = aws_wafv2_web_acl.app_waf.arn
  description = "ARN of the WAF Web ACL"
}
