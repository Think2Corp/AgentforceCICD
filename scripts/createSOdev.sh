sf org create scratch --definition-file config/project-scratch-def.json --target-dev-hub DevOrg --wait 30 --duration-days 30 --alias so-dev

sf org assign permset --name EinsteinGPTPromptTemplateManager --target-org so-dev
sf org assign permset --name AgentPlatformBuilder --target-org so-dev
