#!/bin/bash
aws ec2 describe-instances --filter Name=tag-key,Values=Name --query "Reservations[*].Instances[*].{Instance:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value}" --output text | grep APP-Servers |cut -f 1 > dynainvent.aws
sed -i '/None/d' dynainvent.aws