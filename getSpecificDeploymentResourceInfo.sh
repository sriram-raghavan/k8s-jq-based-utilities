#!/bin/bash

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <deployment-name>"
    exit 1
fi

namespace="$1"
deployment_name="$2"

# Retrieve deployment information
deployment_info=$(kubectl get deployment "$deployment_name" --namespace="$namespace" -o json)

# Check if the deployment exists
if [ -z "$deployment_info" ]; then
    echo "Deployment '$deployment_name' not found in namespace '$namespace'."
    exit 1
fi

# Extract replicas, CPU, memory request, and limit information
replicas=$(echo "$deployment_info" | $jq -r '.spec.replicas // empty')
cpu_request=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.requests.cpu // empty')
memory_request=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.requests.memory // empty')
cpu_limit=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.limits.cpu // empty')
memory_limit=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.limits.memory // empty')

# Output the extracted information
echo "Deployment Information for '$deployment_name' in namespace '$namespace':"
echo "Replicas: $replicas"
echo "Limits: "
echo "  CPU Limit: $cpu_limit"
echo "  Memory Limit: $memory_limit"
echo "Requests: "
echo "  CPU Request: $cpu_request"
echo "  Memory Request: $memory_request"
