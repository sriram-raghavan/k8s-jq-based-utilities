#!/bin/bash
# Unable to check if namespace is part of the current cluster! To do this cluster level access is needed as kubectl get namespace does not work!

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

# Validate the number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <deployment_name>"
    exit 1
fi

# Assign arguments to variables
namespace=$1
deployment_name=$2

# Reversing all the characters of the input parameter to lowercase. This is OPTIONAL.
lowercase_namespace="${namespace,,}"
echo "Namespace: " $lowercase_namespace

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed. Please install kubectl and try again."
    exit 1
fi

# Get the current context
current_context=$(kubectl config current-context)

# Check if the current context is empty
if [ -z "$current_context" ]; then
    echo "Error: No current context found. Make sure your kubeconfig is properly configured."
    exit 1
fi

# Print the current context
echo "Current context: $current_context"

# Retrieve deployment information
deployment_info=$(kubectl get deployment "$deployment_name" --namespace="$namespace" -o json 2>/dev/null)

# Check if the deployment exists
if [ -z "$deployment_info" ]; then
    echo "Deployment '$deployment_name' not found in namespace '$namespace'."
    exit 1
else
	# Get the deployed version using kubectl and jq
	deployed_version=$(kubectl get deployment "${deployment_name}" -n "${lowercase_namespace}" -o json | $jq -r '.spec.template.spec.containers[0].image' | cut -d':' -f2)

	# Output the deployed version
	echo "Deployed version of ${deployment_name} in namespace ${lowercase_namespace}: ${deployed_version}"
fi 
