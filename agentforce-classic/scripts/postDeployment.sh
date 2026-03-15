sf org list --json > orgs.json
scratchorg=$(jq -r '.result.scratchOrgs[0].username' orgs.json)

sf org assign permset --name EinsteinGPTPromptTemplateManager -o $scratchorg
sf org assign permset --name AgentPlatformBuilder -o $scratchorg