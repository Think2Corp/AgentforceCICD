#!/bin/bash
TARGET_ORG=$1

if [ -z "$TARGET_ORG" ]; then
    echo "ERROR: No target org provided. Usage: bash activateAgents.sh <target-org>"
    exit 1
fi

for bundle_dir in agentforce-script/force-app/main/default/aiAuthoringBundles/*/; do
    agent_name=$(basename "$bundle_dir")

    echo "Activating latest version of ${agent_name}..."
    sf agent activate --api-name "$agent_name" --target-org="$TARGET_ORG" --json
done
