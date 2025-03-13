#!/bin/bash
source "../../../shared_libs/shell_functions.sh" &>/dev/null
load_vars_from_json_file "../infra/input.json"
load_vars_from_json_file "../infra/output.json"

# Set credentials
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}" >/dev/null
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

bash ../../../scripts/env2template/main.sh terraform.tfvars.tpl terraform.tfvars

terraform init

if [ "$1" == "up" ]; then
  terraform apply -auto-approve
elif [ "$1" == "down" ]; then
  terraform destroy -auto-approve
else
  echo "Usage: $0 {up|down}"
  exit 1
fi
