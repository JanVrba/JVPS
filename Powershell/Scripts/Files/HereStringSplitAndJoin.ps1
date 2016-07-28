$xpath = @" 
.project
.properties
.'hudson.model.ParametersDefinitionProperty'
.parameterDefinitions
.'hudson.model.ChoiceParameterDefinition'
.choices
.a
.string
"@

[string]$xpathJoin = $xpath.Split("`n") -join("")