#!/bin/bash

source ../cluster/validateNamespace.sh

# Validate the number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <deployment-name>"
    exit 1
fi

# Assign arguments to variables
namespace=$1
deployment_name=$2

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
        # Get the deployed version using kubectl and jq
        deployed_version=$(kubectl get deployment "${deployment_name}" -n "${lowercase_namespace}" -o json | $jq -r '.spec.template.spec.containers[0].image' | cut -d':' -f2)

        # Output the deployed version
        echo "Deployed version of ${deployment_name} in namespace ${lowercase_namespace}: ${deployed_version}"
    fi 
else
    echo "Please enter a valid namespace. Exiting."
    exit 1
fi
