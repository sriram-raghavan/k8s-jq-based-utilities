#!/bin/bash

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

# Function to validate namespace
validate_namespace() {
    namespace="$1"
    
    # Check if the namespace exists
    namespace_exists=$(kubectl get namespaces -o json | $jq -r --arg ns "$namespace" '.items[] | select(.metadata.name == $ns) | .metadata.name')

    if [ -z "$namespace_exists" ]; then
        echo "Namespace '$namespace' does not exist."
        return 1
    else
        echo "Namespace '$namespace' exists."        
        return 0
    fi
}
