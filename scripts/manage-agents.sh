#!/bin/bash
# manage-agents.sh
# Dynamically activate or deactivate all Agentforce agents found in the repo.
# Usage: bash scripts/manage-agents.sh [activate|deactivate] <target-org-alias>

set -euo pipefail

ACTION="${1:-}"
TARGET_ORG="${2:-}"

if [[ "$ACTION" != "activate" && "$ACTION" != "deactivate" ]]; then
  echo "Usage: $0 [activate|deactivate] <target-org-alias>"
  exit 1
fi

if [[ -z "$TARGET_ORG" ]]; then
  echo "Error: target org alias is required."
  exit 1
fi

# Discover agent names from bot-meta.xml files (ignores empty bot directories)
BOT_NAMES=()
while IFS= read -r file; do
  bot_name=$(basename "$file" .bot-meta.xml)
  BOT_NAMES+=("$bot_name")
done < <(find force-app -name "*.bot-meta.xml" | sort)

if [[ ${#BOT_NAMES[@]} -eq 0 ]]; then
  echo "No bot-meta.xml files found. Skipping agent management."
  exit 0
fi

echo "Agents found in repo: ${BOT_NAMES[*]}"
echo "Action: $ACTION on org: $TARGET_ORG"

# Build the Apex Set literal: 'Bot_A','Bot_B',...
BOT_NAMES_APEX=$(printf "'%s'," "${BOT_NAMES[@]}")
BOT_NAMES_APEX="${BOT_NAMES_APEX%,}"

if [[ "$ACTION" == "deactivate" ]]; then
  CURRENT_STATUS="Active"
  NEW_STATUS="Inactive"
else
  CURRENT_STATUS="Inactive"
  NEW_STATUS="Active"
fi

APEX_FILE=$(mktemp /tmp/manage_agents_XXXXXX.apex)
trap 'rm -f "$APEX_FILE"' EXIT

cat > "$APEX_FILE" <<APEX
Set<String> botNames = new Set<String>{${BOT_NAMES_APEX}};

// Query all relevant BotVersions for agents present in the repo
List<BotVersion> versions = [
    SELECT Id, Status, Bot.DeveloperName, VersionNumber
    FROM BotVersion
    WHERE Bot.DeveloperName IN :botNames
    AND Status = '${CURRENT_STATUS}'
    ORDER BY Bot.DeveloperName ASC, VersionNumber DESC
];

// Keep only the latest version per bot
Map<String, BotVersion> latestByBot = new Map<String, BotVersion>();
for (BotVersion bv : versions) {
    String botName = bv.Bot.DeveloperName;
    if (!latestByBot.containsKey(botName)) {
        latestByBot.put(botName, bv);
    }
}

List<BotVersion> toUpdate = latestByBot.values();
for (BotVersion bv : toUpdate) {
    bv.Status = '${NEW_STATUS}';
}

if (!toUpdate.isEmpty()) {
    update toUpdate;
    System.debug('${ACTION}d ' + toUpdate.size() + ' agent(s): ' + latestByBot.keySet());
} else {
    System.debug('No agents with status ${CURRENT_STATUS} found in org. Nothing to ${ACTION}.');
}
APEX

echo "Running Apex to ${ACTION} agents..."
sf apex run --target-org="$TARGET_ORG" --file="$APEX_FILE"
echo "Done: agents ${ACTION}d successfully."
