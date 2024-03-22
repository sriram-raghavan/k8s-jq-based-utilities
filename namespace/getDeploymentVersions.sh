#!/bin/bash

source ../cluster/validateNamespace.sh

if [ -z "$1" ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

namespace="$1"

# Convert namespace to lowercase.
# lowercase_namespace=$(echo "$namespace" | tr '[:upper:]' '[:lower:]')
lowercase_namespace="${namespace,,}"

# Call the function to validate the namespace
validate_namespace "$lowercase_namespace"

# Check the return value of the function
if [ $? -eq 0 ]; then
    # Retrieve deployment names in the specified namespace
    deployment_names=$(kubectl get deployments --namespace="$lowercase_namespace" -o jsonpath='{.items[*].metadata.name}')

    # Check if any deployments exist in the namespace
    if [ -z "$deployment_names" ]; then
        echo "No deployments found in namespace '$lowercase_namespace'."
        exit 1
    fi

    # Loop through each deployment and fetch deployed version
    for deployment_name in $deployment_names; do
        # Retrieve deployment information
        deployment_info=$(kubectl get deployment "$deployment_name" --namespace="$lowercase_namespace" -o json 2>/dev/null)

        # Check if the deployment exists
        if [ -z "$deployment_info" ]; then
            echo "Deployment '$deployment_name' not found in namespace '$lowercase_namespace'."
        else
            # Get the deployed version using kubectl and jq
            deployed_version=$(kubectl get deployment "${deployment_name}" -n "${lowercase_namespace}" -o json | $jq -r '.spec.template.spec.containers[0].image' | cut -d':' -f2)

            # Output the deployed version
            echo "${deployment_name} : ${deployed_version}"
        fi
    done
else
    echo "Please enter a valid namespace. Exiting."
    exit 1
fi