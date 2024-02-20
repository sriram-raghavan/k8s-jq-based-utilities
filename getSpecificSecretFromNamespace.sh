#!/bin/bash
# Unable to check if namespace is part of the current cluster! To do this cluster level access is needed as kubectl get namespace does not work!

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <secret-name>"
    exit 1
fi

namespace="$1"

# Reversing all the characters of the input parameter to lowercase. This is OPTIONAL.
lowercase_namespace="${namespace,,}"
# echo "Namespace: " $lowercase_namespace
secret_name="$2"

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

# Retrieve the specified secret
# 2>/dev/null prevents the error from getting displayed on screen
secret_info=$(kubectl get secret "$secret_name" --namespace="$lowercase_namespace" -o json 2>/dev/null)

# Check if the secret exists
if [ -z "$secret_info" ]; then
    echo "Secret '$secret_name' not found in namespace '$lowercase_namespace'."
    exit 1
else
	# Output the secret information
	formatted_output=$(echo "$secret_info" | $jq -c -r '.metadata.name as $name | .data | to_entries | "\($name)\n{\n  " + (map("\"\(.key)\": \"\(.value)\"") | join(",\n  ")) + "\n}"')

	echo -e "Secret Information for '$secret_name' in namespace '$lowercase_namespace':\n$formatted_output"
fi
