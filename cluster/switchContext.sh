#!/bin/bash

# Location of 'jq' in local machine. If 'jq' is configured in the machine this is not needed and we can use 'jq' directly.
jq="C:\Users\sriram\Downloads\jq.exe"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed. Please install kubectl before running this script."
    exit 1
fi

# Check the current Kubernetes context
current_context=$(kubectl config current-context)

# Check if the current context is empty
if [ -z "$current_context" ]; then
    echo "Error: The current Kubernetes context is empty. Please configure a Kubernetes context before running this script."
    exit 1
fi

echo "Current Kubernetes Context: $current_context"

# Get the list of available Kubernetes contexts using kubectl
contexts=$(kubectl config view -o json | $jq -r '.contexts[] | .name')

# Check if there are any contexts available
if [ -z "$contexts" ]; then
    echo "No Kubernetes contexts found."
    exit 1
fi

# Print available contexts with corresponding indices
echo "Available Kubernetes Contexts:"
echo "$contexts" | awk '{print NR, $0}'

# Prompt user to choose a context
read -p "Enter the number corresponding to the context you want to use: " choice

# Validate user input
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid number."
    exit 1
fi

# Get the context name based on user input
selected_context=$(echo "$contexts" | sed -n "${choice}p")

# Check if the selected context is not empty
if [ -z "$selected_context" ]; then
    echo "Invalid choice. Please select a valid context."
    exit 1
fi

# Switch to the selected context
kubectl config use-context "$selected_context"
echo "Switched to Kubernetes context: $selected_context"
