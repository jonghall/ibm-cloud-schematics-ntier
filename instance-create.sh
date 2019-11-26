#!/usr/bin/env bash
vsiname=$1
vpc="7b4bd245-37eb-456a-b5e2-458b43ddb98c"
subnet="0ea2283c-f545-44a5-ad2b-d2c5343bc214"
region="us-south-1"
profile="cc1-2x4"
image="cc8debe0-1b30-6e37-2e13-744bfb2a0c11"
securitygroup="2d364f0a-a870-42c3-a554-000002178570"
key="636f6d70-0000-0001-0000-000000170bf4"

NICID=$(ibmcloud is instance-create $vsiname $vpc $region cc1-2x4 $subnet --key-ids $key --image-id $image --security-group-ids $securitygroup --user-data @RaxakProtectSetup.sh | awk '/Primary interface/ {print $3}' | sed 's/.*(\(.*\))/\1/')
sleep 5
ibmcloud is floating-ip-reserve $vsiname-fip --nic-id $NICID