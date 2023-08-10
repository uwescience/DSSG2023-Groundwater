# Understanding Uncertainty in Groundwater Calculation

The calculation of groundwater involves multiple variables that each has its associated uncertainties in measurement. In this page, we will talk about the uncertainties associated with them and walk through the main ideas for calculating uncertainties.

## Uncertainty in GRACE
Uncertainties and errors exist in the processing of satellite measurements and processing. Examples of sources of errors include the difficulty to separate signals from land and ocean along the coast lines and the lack of observability in some area of the Earth due to how the satellites are moving. More details on uncertainties and error can be found in the Section 5.1 Known Uncertainties & Sources of Error of the [GRACE User Handbook](). Scientists have used multiple techniques to reduce the error and documented the uncertainty associated with each observation. In the mascon solution data we are using, the uncertainty is stored as another variable in the dataset along with the terrestrial water storage variable. We have converted the units of uncertainty to cubic kilometer to align with other units of our variables and stored it in the final dataframe for you to use. 

To obtain the confidence interval of the observation of terrestrial water storage at a pixel, use the following equation:
$$
Confidence Interval~lat-lon~ = Terrestrial Water Storage~lat-lon~ ± Uncertainty~lat-lon
$$
where



- sources of uncertainty
- confidence interval
- uncertainty in a region
- castle paper: other sources of uncertainty
- combine errors from different measurement