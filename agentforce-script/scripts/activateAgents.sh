#!/bin/bash
TARGET_ORG=$1

if [ -z "$TARGET_ORG" ]; then
    echo "ERROR: No target org provided. Usage: bash activateAgents.sh <target-org>"
    exit 1
fi

for bundle_dir in agentforce-script/force-app/main/default/aiAuthoringBundles/*/; do
    agent_name=$(basename "$bundle_dir")

    VERSION=$(sf data query \
        --query "SELECT VersionNumber FROM BotVersion WHERE BotDefinition.DeveloperName='${agent_name}' ORDER BY VersionNumber DESC LIMIT 1" \
        --target-org="$TARGET_ORG" \
        --json | jq -r '.result.records[0].VersionNumber')

    if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
        echo "ERROR: Could not find latest version for agent ${agent_name}"
        exit 1
    fi

    echo "Activating ${agent_name} version ${VERSION}..."
    sf agent activate --api-name "$agent_name" --version "$VERSION" --target-org="$TARGET_ORG"
done
