#!/bin/bash

source ../cluster/validateNamespace.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <namespace> <secret-name>"
    exit 1
fi

namespace="$1"

# Reversing all the characters of the input parameter to lowercase. This is OPTIONAL.
lowercase_namespace="${namespace,,}"
# echo "Namespace: " $lowercase_namespace
secret_name="$2"

# Call the function to validate the namespace
validate_namespace "$lowercase_namespace"

# Check the return value of the function
if [ $? -eq 0 ]; then

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

else
    echo "Please enter a valid namespace. Exiting."
    exit 1
fi
