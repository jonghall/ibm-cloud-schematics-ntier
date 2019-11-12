#!/usr/bin/env bash
NICID=$(ibmcloud is instance-create $1 r006-6b35433f-d432-410f-8869-db1a5869e8db us-south-1 cx2-2x4 0717-9a5dbf4d-6da1-4a1a-8879-611bf29e7da8 --key-ids r006-870b4d7e-02dd-47c3-a1b8-733504a6b98a --image-id 99edcc54-c513-4d46-9f5b-36243a1e50e2  --security-group-ids r006-19abc92d-bd71-4855-9aa4-8d2afe5d7f1f --user-data @RaxakProtectSetup.sh | awk '/Primary interface/ {print $3}' | sed 's/.*(\(.*\))/\1/')
echo $NICID
ibmcloud is floating-ip-reserve $1-fip --nic-id $NICID