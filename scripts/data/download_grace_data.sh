

#!/bin/bash

# Define variables for start and end dates
start_date="2002-04-04T00:00:00Z"
end_date="2023-09-01T00:00:00Z"

# Run the podaac-data-subscriber command with the specified dates
# Note that this assumes you are executing your shell script from the first level in the repository; update path as needed
podaac-data-subscriber -c TELLUS_GRAC-GRFO_MASCON_CRI_GRID_RL06.1_V3 -d /data/TELLUS_GRAC-GRFO_MASCON_CRI_GRID_RL06.1_V3 --start-date "$start_date" --end-date "$end_date"
