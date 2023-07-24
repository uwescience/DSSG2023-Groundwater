#  Unraveling the Mystery of Groundwater Measurement

Traditionally, governmental bodies and water agencies relied on [in situ measurement](https://www.usgs.gov/faqs/how-can-i-find-depth-water-table-specific-location#:~:text=The%20most%20reliable%20method%20of,placing%20electric%20or%20acoustic%20probes.)  to monitor groundwater in the U.S. However, such approach has several limitations:
- Groundwater can only be monitored in places where monitoring wells are available, making wells drilled on private property difficult to monitor[^1].
- Drilling monitoring wells can be time consuming and costly across large areas[^2].


Scientists have responded to these constraints by turning to space. More specifically, they use the Gravity Recovery and Climate Experiment (GRACE) and the Gravity Recovery and Climate Experiment Follow-On (GRACE-FO) data collected by NASA. These datasets track changes in terrestrial water storage around the globe, encompassing water found in lakes, rivers, soil, snowpack, and underground aquifers.

## The Formula and Datasets

The formula to derive groundwater measurement using GRACE data is as follows:

$$
\Delta Groundwater = \Delta Terrestrial Water Storage - \Delta SoilMoisture - \Delta Snow Water Equivalent - \Delta Surface Water
$$

We list the datasets used to derive each variable in the image below:
<img src="https://github.com/uwescience/DSSG2023-Groundwater/blob/main/notebooks-and-markdowns/Formula.png">

## Digging Deeper: What are GRACE and GRACE-FO?

The GRACE mission, a collaboration between NASA and German space agencies (DLR), is designed to track changes in Earth's gravity field by monitoring the distance between two satellites orbiting our planet. By utilizing specific models, scientists can convert changes in the gravity field into changes in Earth's terrestrial water storage. Initiated in March 2002 and concluded in October 2017, the GRACE mission provided critical data on a monthly basis. Picking up where GRACE left off, GRACE-FO was launched in May 2018 to continue this important work.

Interested in the finer details of how GRACE and GRACE-FO measure changes in terrestrial water storage? Continue reading the following section. If not, feel free to proceed to the next page to start exploring the data.

### Frequently Asked Questions about GRACE and GRACE-FO

**Q: How do scientists measure change in Earth's gravity fields?**

**A:** In both the GRACE and GRACE-FO missions, two satellites work in tandem, following each other and orbiting the Earth at a distance of about 137 miles (220 km). They continuously send microwaves to each other to measure their distance, accurate to a micron - about the diameter of a blood cell. When the satellites pass over an area with stronger gravitational pull (like a mountain), the gravity causes the leading satellite to accelerate, increasing the distance between the satellites. This distance reduces once they pass the area of stronger gravity. By detecting these distance changes and identifying where they occur, scientists can map the changes in gravity fields globally. More details can be found on the [GRACE website](https://grace.jpl.nasa.gov/mission/gravity-101/).

**Q: How do scientists derive changes in terrestrial water storage from changes in Earth's gravity fields?**

**A:** Gravity is a function of mass. By measuring changes in gravity, scientists can model changes in mass. Since most parts of Earth's surface are relatively static, changes in surface mass are primarily due to variations in water storage in hydrologic reservoirs, shifting ocean, atmospheric and land ice masses, and mass exchanges between these Earth system compartments. Once the change in Earth's gravity field data is recorded, scientists use specific models to solve for gravity variations. Initially, spherical harmonic solutions were the only solution employed. In 2015, mass concentration (mascon) solutions were also developed.

**Q: What's the difference between Mascon solution and spherical harmonic solutions?** 

**A:** Spherical harmonic solutions account for the Earth's oblate shape. Mascon solutions divide the earth into a grid. Each grid, or 'mascon', has a specific known geophysical location that isn't provided by each spherical harmonic coefficient. This allows scientists to be more precise in modeling and removes relevant errors in the processing step. Mascon solutions typically have less error and higher resolutions compared to spherical harmonic solutions. Different models with different assumptions mean they are suited for different use cases - the mascon solution is recommended for Hydrology applications. For an overview of the mechanisms of the two solutions, click [here](https://grace.jpl.nasa.gov/data/monthly-mass-grids/). For a detailed comparison, visit [this site](https://grace.jpl.nasa.gov/data/choosing-a-solution/).

**Q:  Why are measurements presented as changes rather than fixed numbers?**

**A:** GRACE cannot directly measure absolute water storage. Instead, it compares observations at a specific time point to a set time-mean baseline. This is done by first calculating the average for each grid point from 2004 to 2009, and then subtracting this value from each grid point for all time steps. The resulting data product varies around zero. A positive number at time point _yyyy-mm_ and location _lat-lon_ indicates more terrestrial water at that location compared to the 2004 to 2009 average. Further details on the computation process and units can be found [here](https://grace.jpl.nasa.gov/about/faq/).

**Q: Where can I find more information about GRACE and GRACE-FO?**

**A:** For more information that's relevant to hydrological information, you could refer to their [Level-3 Data Product User Handbook](https://deotb6e7tfubr.cloudfront.net/s3-edaf5da92e0ce48fb61175c28b67e95d/podaac-ops-cumulus-docs.s3.us-west-2.amazonaws.com/gracefo/open/docs/GRACE-FO_L3_Handbook_JPL.pdf?A-userid=None&Expires=1690241615&Signature=bNV~ixhHoOupQqiGtGhqH9Hfe7t7cc3OV7lpXOdLs0pOTMY1IgS2hYr2XRFtszFYucNVarcxrmIQGkwIB4CP5svHDiY3VuX4Gdy428RmNQ3BdAyiOhS6zxkkFJ77Osmu9t2P~JAu7CbijgeGxObAXtv9fsVb6sQgpllMB5PA9LplawrqBipZIs-84VX5CSDSFYIKZogv~d1jT8~AaE7I3GG79~osAsIaZ3v66OTDNJ4wHnjOLixptO5-85MrjtrHW07fQXXdyYfSLafNfDaFQCkaawGE1XZSpTSf8Krr0t~Zzl97wAUPzlvmr74HtWcHo6kuC70Qkzi9BLVkGADykA__&Key-Pair-Id=K353YVLLPST7AQ). Other documentations of GRACE and GRACE-FO mission are accessible [here](https://podaac.jpl.nasa.gov/gravity/gracefo-documentation).
[^1]: https://grace.jpl.nasa.gov/applications/groundwater/
[^2]: https://nap.nationalacademies.org/read/25754/
