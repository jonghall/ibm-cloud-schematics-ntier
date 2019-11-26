#!/usr/bin/env bash
vsiname=$1
vpc="r006-6b62c36a-6375-4c6b-80c9-65fd03ce182d "
subnet="0717-bcf430b6-4fad-4a4a-96a3-0a5cd90f9a6f "
region="us-south-1"
profile="cx2-2x4"
image="99edcc54-c513-4d46-9f5b-36243a1e50e2"
securitygroup="r006-0815632a-34f1-484c-9fb7-c9bbe6afae85"
key="r006-870b4d7e-02dd-47c3-a1b8-733504a6b98a"

ibmcloud is target --gen 2
#ibmcloud is instance-create $vsiname $vpc $region $profile $subnet --key-ids $key --image-id $image --security-group-ids $securitygroup --user-data @RaxakProtectSetup.sh
NICID=$(ibmcloud is instance-create $vsiname $vpc $region $profile $subnet --key-ids $key --image-id $image --security-group-ids $securitygroup --user-data @RaxakProtectSetup.sh | awk '/Primary interface/ {print $3}' | sed 's/.*(\(.*\))/\1/')
sleep 5
ibmcloud is floating-ip-reserve $vsiname-fip --nic-id $NICID