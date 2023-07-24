At this point, you have:
1. Defined your question
2. Reviewed GRACE/GLDAS 
3. Determined which data sources to get your data from
4. Downloaded your data
5. Organized, subsetted, and processed your data
6. Validated your outputs

Let's now take a step back to understand what our data looks like and how to interpret it.

# Data Structure
You now have your data in the form of two Pandas **dataframes**: one containing data from GRACE/GRACE-FO and one containing data from GLDAS. This can also be thought of as being in a tabular format, which can be easily saved as a .CSV file. 

<p align="center">
    <img src="images/gracegldas_df.png" width="750" /> 
</p>


## Deviation from the Mean



In order to compute the deviation from the mean ($d_i$), for each measurement $p_i$, you compute

$$d_i = p_i - \mu$$

where $\mu$ is the average value over the time series*. We then plot these distances to obtain the devations from the mean over time.

*Note that GRACE data is computed based upon a basetime time period of January 2004 to December 2009. 

<p align="center">
    <img src="images/plots.png" width="750" />
</p>

# Sources 
[1] https://education.nationalgeographic.org/resource/latitude/
[2] https://www.usgs.gov/faqs/how-much-distance-does-a-degree-minute-and-second-cover-your-maps#:~:text=One%20degree%20of%20latitude%20equals,one%20second%20equals%2080%20feet.