# Understanding Uncertainty in Groundwater Calculation

The calculation of groundwater involves multiple variables that each has its associated uncertainties in measurement. In this page, we will talk about the uncertainties associated with them and walk through the main ideas for calculating uncertainties.

## Uncertainty in Terrestrial Water Storage from GRACE
Uncertainties and errors exist in the processing of satellite measurements and processing. Examples of sources of errors include the difficulty to separate signals from land and ocean along the coast lines and the lack of observability in some area of the Earth due to how the satellites are moving. More details on uncertainties and error can be found in the Section 5.1 Known Uncertainties & Sources of Error of the [GRACE User Handbook](https://deotb6e7tfubr.cloudfront.net/s3-edaf5da92e0ce48fb61175c28b67e95d/podaac-ops-cumulus-docs.s3.us-west-2.amazonaws.com/gracefo/open/docs/GRACE-FO_L3_Handbook_JPL.pdf?A-userid=None&Expires=1691775191&Signature=hg9xblOoxGYd6Y4nT6lDtUVJfyYE9iB4GuXJi8rBsajgAq1CW2ctZHK-nHkLGDB4U0GbLKywoUI4h3QIN27MZorTUU2osEa6PDDEqniPfumQLqTdES7sgK2eBwYHKp8ac07-hFyfJ6bxhFwj-OKYMfS5mw1SLtGbjenc3LGLEOaQ-SVA~aNDQ-2QjCzFqtb-H9CXBGy6ZLNaU6fEzTmTUXIVqTXu8mZaB7423exrYNWxzbjLKctErOF-NX3gV8-ThrAt-VsLh~PBaT9epFamMOH18hs6Uv3t0~GwwF4UQTPS7wPndO4vnpApDni7F3u9ElnlK~OED7BX3sQ3S72nsw__&Key-Pair-Id=K2T4XLW1Q8DT9E). Scientists have used multiple techniques to reduce the error and documented the uncertainty associated with each observation. In the mascon solution data we are using, the uncertainty is stored as another variable in the dataset along with the terrestrial water storage variable. We have converted the units of uncertainty to cubic kilometer to align with other units of our variables and stored it in the final dataframe for you to use. 

To obtain the confidence interval of the observation of terrestrial water storage at a pixel at a given time, use the following equation:

$$\text{Confident Interval} _\text{lat-lon-time} = \text{Terrestrial Water Storage} _\text{lat-lon-time} ± \text{Uncertainty} _\text{lat-lon-time}$$

where the $`lat`$, $lon$ identifies the pixel we are focusing on, $time$ identifies the time we are focused on, the $\text{Terrestrial Water Storage} _\text{lat-lon-time}$ and $\text{Uncertainty} _\text{lat-lon-time}$ are the variable values stored under the lwe_thickness_km3 column and the uncertainty_km3 column for the row we are interested in.

The resulted uncertainty is considered to be conservative. The original uncertainty is measured at the 3 degree pixel level, corresponding to the shape of each individual mascon. Then, scientists scaled the orginal uncertainty to derive the uncertainty at the 0.5 degree level. Integrating the uncertainty over a region is also complicated because there are correlation of errors across individual mascons. More details are documented on [the GRACE Tellus Mascons website](https://grace.jpl.nasa.gov/data/get-data/jpl_global_mascons/) and the paper [Wiese, Landerer and Watkins (2016)](http://dx.doi.org/10.1002/2016WR019344)



## Uncertainty in Other Variables
Uncertainties in Soil Moisture and Snow Water Equivalent from GLDAS are not documented in their [README document](https://hydro1.gesdisc.eosdis.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/doc/README_GLDAS2.pdf). Similarly, reservoir storage provided by the Bureau of Reclamation also does not incorporate uncertainty. USGS, another provider of reservoir storage data, mentioned in their [website](https://waterdata.usgs.gov/nwis/sw) that the data are collected by automatic recorders and manual field measurements, which verify the accuracy of the auto matically recorded observations. Papers have tried to estimate uncertainty for these variables and incorporate them in the calculation of groundwater anomalies, one example is the paper [Castle et al. (2014)](https://agupubs.onlinelibrary.wiley.com/doi/10.1002/2014GL061055).

## Propagating Uncertainty
To propagate uncertainty and obtain the uncertainty of the groundwater anomaly, we can assume that uncertainties are uncorrelated between different datasets. The following formula is used:

$$\text{Uncertainty} _\text{groundwater} = \sqrt{\text{Uncertainty} _\text{Terrestrial Water Storage}^2 + \text{Uncertainty} _\text{Soil Moisture}^2 + \text{Uncertainty} _\text{Snow Water Equivalent}^2 + \text{Uncertainty} _\text{Reservoir Storage}^2}$$
