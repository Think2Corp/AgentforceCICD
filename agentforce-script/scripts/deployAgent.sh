sf agent publish authoring-bundle -n Joker -o so-dev2 --skip-retrieve
sf project deploy start -o so-dev2 --source-dir agentforce-script/force-app/main/default/aiEvaluationDefinitions
