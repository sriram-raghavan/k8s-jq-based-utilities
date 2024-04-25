#!/bin/bash

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="..\lib\jq.exe"

# Function to validate namespace
validate_namespace() {
    namespace="$1"

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

    # Check if the namespace exists
    namespace_exists=$(kubectl get namespaces -o json | $jq -r --arg ns "$namespace" '.items[] | select(.metadata.name == $ns) | .metadata.name')

    if [ -z "$namespace_exists" ]; then
        echo "Namespace '$namespace' does not exist in $current_context."
        return 1
    else
        echo "Namespace '$namespace' exists in $current_context."        
        return 0
    fi
}
