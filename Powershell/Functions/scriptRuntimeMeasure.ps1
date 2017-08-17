# Script Runtime measure

# Get Start Time
$startDTM = (Get-Date)

# Script ...

# Get End Time
$endDTM = (Get-Date)

# Echo Time elapsed
"Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"
