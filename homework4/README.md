Homework [4]: Text
==============================

| **Name**  | Rachel  |
|----------:|:-------------|
| **Email** | rasmith2@dons.usfca.edu |

## Instructions ##

The following packages must be installed before running this code: 

- `ggplot2`
- `shiny`
- `scales`
- `tm`
- `SnowballC`
- `wordcloud`
- `RColorBrewer`

Use the following code to run this `shiny` app:

- `library(shiny)`
- `runGitHub("msan622", "rasmirac", subdir = "homework4")`


## Discussion ##

I created a Shiny App with minimal interactivity that allows users to compare screenplay and novel versions of some of my favorite works of fiction. 

### Dataset ###

For this project, I used text from the following screenplays and novels: Fight Club, No Country for Old Men, and Pride and Prejudice. I chose these three texts because they are works that I am very familiar with in both forms. I found the movie scripts from the Internet Movie Script Database, and I found the full text of the novels online through school websites. I used the `tm` package to munge the data and put it into a usable format. I removed stopwords along with some repetitive words (e.g. 'Jean' because it's the second half of the name 'Carla Jean'). I stored each of these datasets as a separate text `data.frame` and allowed the user to choose which one to use the visualizations. I was also careful to keep the novel and screenplay text separate as I was interested in seeing the differences in the two. 

### Technique 1: Bar Plot ###

![](barplot.png)

This plot is just a simple plot of word frequencies by text and form of media. I chose this technique because it is a very clean and simple way of indicating how many words are in each document. I decided not to show a faceted bar plot because I wasn't able to order the bars consistently in both. It also makes it harder to read the x-axis labels. 

I chose the color to be consistent with the other plots used in this Shiny App. I removed the vertical gridlines as they are unneccessary for bar plots. I also increased the text size of the plot title and axis labels. 

Interactivity: 

- Responds to user choice of text and media
- User can choose how many words to show

### Technique 2: Word Cloud ###

![](wordcloud.png)

Although I don't usually like word clouds, I chose this technique because it allows the user to visually compare two types of media very quickly without having to look along an axis line. I feel that it works very well in conjunction with the simple bar plot. 