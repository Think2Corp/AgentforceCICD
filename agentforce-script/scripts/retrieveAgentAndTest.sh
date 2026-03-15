sf project retrieve start -o so-dev --manifest agentforce-script/manifest.xml
sf project retrieve start -o so-dev --metadata AiEvaluationDefinition

///
sf project retrieve start -o so-dev --metadata aiAuthoringBundle
sf agent publish authoring-bundle -n Joker -o so-dev2 --skip-retrieve
