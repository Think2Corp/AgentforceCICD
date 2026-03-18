#!/bin/bash
TARGET_ORG=$1

if [ -z "$TARGET_ORG" ]; then
    echo "ERROR: No target org provided. Usage: bash publishAgents.sh <target-org>"
    exit 1
fi

for bundle_dir in agentforce-script/force-app/main/default/aiAuthoringBundles/*/; do
    agent_name=$(basename "$bundle_dir")
    echo "Publishing authoring bundle for agent: ${agent_name}..."
    sf agent publish authoring-bundle -n "$agent_name" -o "$TARGET_ORG"
done
