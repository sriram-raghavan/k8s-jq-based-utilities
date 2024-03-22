#!/bin/bash

source ../cluster/validateNamespace.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <deployment-name>"
    exit 1
fi

namespace="$1"
deployment_name="$2"

# Reversing all the characters of the input parameter to lowercase. This is OPTIONAL.
lowercase_namespace="${namespace,,}"

# Call the function to validate the namespace
validate_namespace "$lowercase_namespace"

# Check the return value of the function
if [ $? -eq 0 ]; then
	# Retrieve deployment information
	deployment_info=$(kubectl get deployment "$deployment_name" --namespace="$lowercase_namespace" -o json 2>/dev/null)

	# Check if the deployment exists
	if [ -z "$deployment_info" ]; then
		echo "Deployment '$deployment_name' not found in namespace '$lowercase_namespace'."
		exit 1
	else
		# Extract replicas, CPU, memory request, and limit information
		replicas=$(echo "$deployment_info" | $jq -r '.spec.replicas // empty')
		cpu_request=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.requests.cpu // empty')
		memory_request=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.requests.memory // empty')
		cpu_limit=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.limits.cpu // empty')
		memory_limit=$(echo "$deployment_info" | $jq -r '.spec.template.spec.containers[0].resources.limits.memory // empty')

		# Output the extracted information
		echo "Deployment Information for '$deployment_name' in namespace '$lowercase_namespace':"
		echo "Replicas: $replicas"
		echo "Limits: "
		echo "  CPU Limit: $cpu_limit"
		echo "  Memory Limit: $memory_limit"
		echo "Requests: "
		echo "  CPU Request: $cpu_request"
		echo "  Memory Request: $memory_request"
	fi
else
    echo "Please enter a valid namespace. Exiting."
    exit 1
fi
