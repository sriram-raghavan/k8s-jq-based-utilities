#!/bin/bash
# Unable to check if namespace is part of the current cluster! To do this cluster level access is needed as kubectl get namespace does not work!

# Location of '$jq' in local machine. If '$jq' is configured in the machine this is not needed and we can use '$jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

# Prompt user to enter namespace
read -p "Enter the namespace: " namespace

# Convert namespace to lowercase
# lowercase_namespace=$(echo "$namespace" | tr '[:upper:]' '[:lower:]')
lowercase_namespace="${namespace,,}"
# echo "Namespace: " $lowercase_namespace

# Check if namespace is not empty
if [ -z "$lowercase_namespace" ]; then
    echo "Please enter a namespace."
    exit 1
fi

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
