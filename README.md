# COMPARING PREDICTIVE MODELS
### Generalized Linear Models and Neural Nets

#### A statistical analysis, using R.

Author: wj107

Email: will.johnson@gmail.com

For my Master's Project at [Northeastern Illinois University](https://www.neiu.edu), I am using two different methods for predictive
analysis -- Generalized Linear Models (GLM) and Neural Nets (NN) and comparing their accuracy, precision, and computational time, 
using the R statistical software.

The R scripts in this package run some pre-designed trials on pre-selected data sets in an effort to analyze the standard error for both 
GLM and NN predictive models.  The standard errors are computed across a number of re-sampled data sets, allowing us to view averages as 
a reasonable estimate for true standard error parameter for a model.

We look for trends: which model type is more accurate?  How much so?  The results are also presented graphically using ggplot. The detailed 
write-up on the models, as well as plenty of introductory description about predictive modelling, is given in the LaTeX documents.

#### Some features of v0.9:

* Title page!  Table of contents! References!!
* 'diamonds' data set and 'gamelogs' with NBA data for training/testing models
* six pre-designed trials, and a function that inputs data frame, response variable, and outputs SE estimates
* creates summary graphs of the SE results, distinguishing between trial size, response variable type, and model type (GLM/NN)
* options to save (w.out dimensions) or display graphs.
* 3 chapters of a write-up:  chap1 overview, chap2 introductions, chap3 methods & results
* some basic knitr:  tex file replaced by a Rnw file.  495knit file to convert Rnw to tex.
* make495 file to knit, typeset, and display the finished pdf in one call
* modularized tex write-up!  one file per chapter!

#### v0.7+ needs:

* flowcharts... can you make them better?
* work to broaden functions, fold them into SEestimate... make like an SEestimate.study function.
* add data to 495trials function
* separate 495trials/graphic from the project!  one can be generalized, the other... keep fixed results for the paper
* customize parameters for "output"... not always 50, 100, 200 test size
* improve dim's on graphs.  display both graphs in one function call??
* caption sizes for figures!
* careful listing of sources for the write-up
* can you do source([R file]) in a Rnw chunk??
* comments for R chunks??? width of chunks??
* kable_styling(latex_options="striped" ????
* create a wiki to host further research!!
* perceptron, exponential functions... add more figures
