# documentation : http://docs.octopusdeploy.com/display/OD/Octo.exe+Command+Line

# Install Octo.exe - Chocolatey

choco install octopustools

# Export Project 

octo export --server=http://... --apikey=API-... --type=project --name="..." --filepath abc.json

# Import Project

octo import --server=http://... --apikey=API-... --filepath=abc.json --type=project

