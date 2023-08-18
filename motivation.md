> ## Introduction

Our overarching goals for the 2023 Data Science for Social Good (DSSG) Program involved:
* **Understanding how groundwater has changed over time in the Colorado River Basin (CRB);** and
* **Developing a reproducible workflow (i.e., gathering, formatting, analyzing, and visualizing data) that can be applied to other regions around the world.**

Groundwater is critical for water supply in the Colorado River Basin; however, it has historically not been considered in water governance and management at the basin-wide scale. This project uses satellite data (Gravity Recovery and Climate Experiment, Global Land Data Assimilation System, etc.) to measure and analyze groundwater change dynamics in the basin. Satellite data, in contrast to in-situ measurements, is cost-advantageous and scalable – yet, is highly under-utilized in exploring complex groundwater change dynamics.
Ultimately, our research aims to enable a diverse set of audiences to understand groundwater changes in the Colorado River Basin. Moreover, we aim for our workflow to be easily extendable to other areas outside the basin that may be facing a water crisis. To accomplish this, we produce: (1) **interactive maps and charts to understand regional groundwater differences within the Colorado River Basin;** (2) **Jupyter notebooks with accessible and functional code that details our workflow**; and (3) **a detailed report outlining our methods and findings**.

<br>
<br>

> ## Background

The Colorado River Basin, a large region across the Southwestern United States, parts of Mexico, and several Tribal Nations, faces unprecedented water stress. Colloquially known as “the lifeblood of the Southwest”, the Colorado River provides water for 40 million people, supplies irrigation for 5 million acres of farmland, and underpins $1.4 trillion in yearly economic activity[^1]. 
[^1]: American Rivers (2022). [Accessible from here](https://www.americanrivers.org/wp-content/uploads/2022/04/ColoradoRiver_MER2022_Report_Final_03302022.pdf) 

Vitally important for social, economic, and cultural purposes, the river is facing record shortages largely due to climate change and regional increases in development and water-use. Indeed, the Bureau of Reclamation recently declared the first ever water shortage in the region[^2].
[^2]: Bureau of Reclamation (2021). Reclamation announces 2022 operating conditions for Lake Powell and Lake Mead. Accessible from: https://www.usbr.gov/newsroom/news-release/3950 
Previous discussions and policy decisions on water allocation in the region have largely focused on surface water – i.e., water that is visible above ground, such as the water in Lakes Mead or Powell. In contrast, groundwater exists below the Earth’s surface in aquifers. Despite the lack of focus on groundwater, it remains a crucial resource for water supply in the region, particularly for agricultural areas, rural areas, and for compensating for surface water shortages during drought. Still, measurement and allocation of groundwater remains difficult and inconsistent.

Current regulations governing water allocation in the Colorado River Basin will expire in 2026. Given the unprecedented water shortage in the region and upcoming policy decisions, making data and information about groundwater in the region easily available and accessible has the potential to provide crucial information that can help inform this important decision. A dataset, reproducible workflow, and clear communication on groundwater levels could thus be impactful for water allocation decisions in the area. Moreover, as other areas in the world face similar water crises, an easy-to-modify workflow that can be adapted to other regions has the potential to globally help manage water shortages.

<br>
<br>

> ## Actors with Interest

We have taken into account the perspectives of key actors throughout this project.

**General Public**: The estimation of groundwater usage and insecurity demands significant technical expertise, often excluding a range of actors, including the general public. We want to make information about groundwater usage and insecurity in the Basin readily accessible to everyone.

**Policymakers**:  Groundwater is often overlooked when making policy decisions regarding water allocations in the Colorado River Basin. As we approach the 2026 negotiations, we aim to provide compelling data and insights that highlight the significance of including groundwater considerations in policy-making decisions.

**Scientists**: Satellite data, such as GRACE, represents a powerful yet complex tool for understanding and conducting statistical analyses. We aim to develop a reproducible workflow that can be readily adapted and applied to the Colorado River Basin and other regions. This will empower scientists to conduct research with increased efficiency and effectiveness, thereby advancing our understanding of the groundwater.

**Advocacy Groups**: We are dedicated to ensuring that our tools are accessible to individuals without extensive technical expertise. Our objective is to provide visualizations and reports that support advocacy groups in their endeavors to raise awareness and utilize scientific data. By doing so, we aim to assist these groups in advocating for sustainable groundwater management practices and fostering a greater understanding of the groundwater among broader audiences.

<br>
<br>

> ## Ethics

Working on groundwater and water insecurity in this project brings up complex ethical issues across multiple domains. Politically, groundwater management varies significantly across government levels. Additionally, Tribal Nations, and Mexico are often influenced by basin-wide management decisions, but are not always included in the discussions. Groundwater depletion and water insecurity impact different groups in disproportionate ways – financially, socially, and culturally. Moreover, given the complexity of the datasets we work with, presenting our products and documentation in standard fashion could prevent audiences with less technical background from fully utilizing our products.

Given these ethical considerations, we prioritized inclusion, accessibility, transparency/integrity in our product design process.

**Inclusion**: We recognize there are a multitude of actors with varying interests in this arena that makes it difficult for our project to cater to all their needs simultaneously. However, we are committed to considering how our work may differentially impact various parties, and we explicitly kept these groups in mind throughout our decision making process. Recognizing that the influence of designers wanes once a product is deployed, we emphasize the design process as a critical stage for building an inclusive product. We pay detailed attention to ensuring our product is not monopolized by a single party to the disadvantage of others. While our focus is primarily on the Colorado River Basin, we recognize that other regions worldwide can also benefit from a deeper understanding of groundwater and from the utilization of the dataset we use. We aim to create an inclusive product for users interested in diverse regions. Our approach includes making the data pipeline easily adaptable to other locations, keeping the needs of users interested in different regions in mind when communicating our dataset’s limitations, and openly acknowledging the geographical constraints of our products.

**Accessibility**: As technologists and designers, we understand that the dataset we employ will be interpreted by users with varying levels of technical expertise. We meticulously document our work, making our product accessible and easily understandable to users across different backgrounds.

**Transparency and Integrity**: The datasets we use are complex and not perfectly applicable in every scenario.To prevent overgeneralization of our results, we ensure clear communication about the limitations of our data and our product in our documentations. For example, granularity limits make it difficult to zoom into smaller regions, such as specific neighborhoods and smaller Tribal nations.

