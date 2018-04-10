# COMPARING PREDICTIVE MODELS
### Generalized Linear Models and Neural Nets

#### A statistical analysis, using R.

Author: Will Johnson

Email: will.johnson@gmail.com

For my Master's Project at [Northeastern Illinois University](https://www.neiu.edu), I am using two different methods for predictive
analysis -- Generalized Linear Models (GLM) and Neural Nets (NN) and comparing their accuracy, precision, and computational time, 
using the R statistical software.

The R scripts in this package run some pre-designed trials on pre-selected data sets in an effort to analyze the standard error for both 
GLM and NN predictive models using the function SE.estimate.  [I wrote the SE.estimate function](https://github.com/wj107/SEestimate) to carry out
these trials: the train/test splits, the model creation, the re-sampling, and the error calculation.  After using the function to create a number
of models (we will use 50-fold cross validation), we can use the model averages as a reasonable estimate for true standard error parameter for a 
model. 

We look for trends: which model type is more accurate?  How much so?  The results are also presented graphically using ggplot. The detailed 
write-up on the models, as well as plenty of introductory description about predictive modelling, is given in the LaTeX documents.


#### Some features of v0.94:

* Title page!  Table of contents! References!!
* 'diamonds' data set and 'gamelogs' with NBA data for training/testing models
* six pre-designed trials using SE.estimate
* creates summary graphs of the SE.estimate results, distinguishing between trial size, response variable type, and model type (GLM/NN)
* Full write-up of trials: chap1 modeling overview, chap2 technical intro to GLM and NN, chap3 trial methods & results
* modularized tex write-up!  one file per chapter!
* some basic knitr:  tex file replaced by a Rnw file.  495knit file to convert Rnw to tex.
* make495 file to knit, typeset, and display the finished pdf in one call

#### v0.94+ needs:

* flowcharts... can you make them better?
* do you need both make and knit function?  create Rnw folder.  Organize!!
* work to broaden functions, fold them into SEestimate... make like an SEestimate.study function. (this is probably for the SE.estimate project)
	* add data to 495trials function
	* separate 495trials/graphic from the project!  one can be generalized, the other... keep fixed results for the paper
	* customize parameters for "output"... not always 50, 100, 200 test size
* caption sizes for figures!
* can you do source([R file]) in a Rnw chunk??
* comments for R chunks??? width of chunks??
* kable_styling(latex_options="striped" ????
* create a wiki to host further research!!
* perceptron, overfitting, exponential functions... add more figures
