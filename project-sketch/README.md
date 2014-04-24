Project Sketch
==============================

<<<<<<< HEAD
This assignment will help you prepare for the final project. You should have already chosen a dataset to visualize. Next, you will sketch out the tools and packages you will use to prepare your dataset, and the initial set of techniques you will try to implement.

:warning: Try not to spend over an hour on this assignment. The goal is to get you thinking about your final project, and planning a way forward for working on it.

Planned Tools
------------------------------

Include which `R` packages or other tools you plan to use for your final project, how you plan to use them, and why you choose them. Your final project should use at a minimum a combination of `R`, `ggplot2`, and `shiny` to visualize your dataset. 

However, you may also want to use other packages or tools. In particular, we will **not** cover how to implement map or graph-based visualizations in `ggplot2`, as this may not be the best tool for those types of visualizations. You are welcome to learn and use the appropriate tool(s) for those types of visualizations if you want.

Planned Techniques
------------------------------

Include a list of four different techniques you plan to implement, why you choose those techniques for your dataset, and what you hope to learn. You should have approximately 3 to 5 sentences per technique.

Keep in mind you will be asked to implement 1 to 2 prototypes for peer review.

Planned Interaction
------------------------------

Describe the types of interaction you want to include (filtering, brushing, zooming, panning, sorting, and so on). You can discuss this per technique or overall if you plan to integrate all of the techniques into a single `shiny` app.

Keep in mind you will be asked to implement at least one of your planned interactions along with your prototype.

Planned Interface
------------------------------

Draw an annotated sketch illustrating the interface you plan to create for your prototypes and interactions. You can draw this on paper and upload a scan, use the free Google Drive Drawing tool, or use any other tool that allows you to upload the result as a PDF.

This does not have to be anything fancy. Just enough to show you have thought about how you would like to bring everything together. 
=======
| **Name**  | Rachel Smith  |
|----------:|:-------------|
| **Email** | rasmith2@dons.usfca.edu |

Project Sketch
==============================


## Planned Tools ##
I will probably use R's Shiny and ggplot2 packages to implement my visualizations. I might look into some map visualization tools to implement some of my techniques -- I'm thinking of doing a simple choropleth. I hope also to try to implement some simple techniques (like hovering for a line plot) in D3. 

## Planned Techniques ##

- Line plot

I'd defintely like to do some time series visualizations with this dataset. I plan to implement a simple multi-line plot of food purchases over time with each line representing a separate food group. I'd add the interactivity of breaking these food groups out into more granualar groups -- for example, the line for fats breaks down into margarine, butter, and oil. I'd also like to add the option of filtering by region. 

- Choropleth

Because I have the option of breaking this data down into regional purchases, it could be interesting to have a map based heat map of purchases by region and year. I'd like to add in a small bit of animation and allow the user to 'play' the years. This way we could see the change in purchase habits by consumers over the years. 


- Parallel Coordinates Plot

I think that this technique could be interesting because I have numeric data that might be related (e.g. does more meat consumption imply less vegetable consumption?). Again, I'd like to add in the option to see these relationships by year. I'd also like to allow the user to choose which variables to show in this plot. 


- Small multiples line plot

This technique could go well with the other line plot. Users would have the option to separate out the line plot by a variable of choice (region, year span, etc. ). I am most likely going to focus on the other plots mentioned above because I think they offer more information, but I like this plot as a backup. 


## Planned Interaction ##

I'd like to add the options to filter or brush (depending on if I use D3) for the line plots. The choropleth will allow the user to choose which food variable to color by and for which year to show data (I'd like to add in a play button for the user to see the change over years). I want to also add in a hover feature or a table that shows the value of the variable for each region. For the parallel coordinates plot, I'd probably add in the options to choose which numeric variables to show and add a play button to see the change in variable relationships over the years. 

## Planned Interface ## 

![Rough Sketch of Lineplot](LinePlot.png)

![Rough Sketch of Choropleth](Choropleth.png)
>>>>>>> bea5278cc2cc9d72375c5937fbcaab22323c770f
