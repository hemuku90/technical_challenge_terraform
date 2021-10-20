#!/bin/bash
set -xe

terraform init
terraform apply --auto-approve