# Define variables for start and end dates
start_date="2003-01-01T00:00:00Z"
end_date="2013-12-01T00:00:00Z"

# Run the podaac-data-subscriber command with the specified dates
podaac-data-subscriber -c TELLUS_GRAC_L3_CSR_RL06_LND_v04 -d ./data/TELLUS_GRAC_L3_CSR_RL06_LND_v04 --start-date "$start_date" --end-date "$end_date"
