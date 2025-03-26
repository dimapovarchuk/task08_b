location = "East US"

name_prefix = "${resources_name_prefix}"

redis_hostname_secret_name    = "${redis_hostname}"
redis_primary_key_secret_name = "${redis_password}"
tags = {
  Creator = "${student_email}"
}
