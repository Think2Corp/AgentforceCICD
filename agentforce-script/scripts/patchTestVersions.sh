#!/bin/bash
TARGET_ORG=$1

if [ -z "$TARGET_ORG" ]; then
    echo "ERROR: No target org provided. Usage: bash patchTestVersions.sh <target-org>"
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

    VERSION_TAG="v${VERSION}"
    echo "Patching test definitions for ${agent_name} to ${VERSION_TAG}..."

    for test_file in agentforce-script/force-app/main/default/aiEvaluationDefinitions/*.aiEvaluationDefinition-meta.xml; do
        if grep -q "<subjectName>${agent_name}</subjectName>" "$test_file"; then
            sed "s|<subjectVersion>.*</subjectVersion>|<subjectVersion>${VERSION_TAG}</subjectVersion>|g" "$test_file" > "$test_file.tmp" && mv "$test_file.tmp" "$test_file"
            echo "  Patched: $test_file"
        fi
    done
done
