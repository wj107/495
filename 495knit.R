########################################################################
########## Quick File to KNIT all the chapters in the 495 report
########################################################################

require(knitr)
require(ggplot2)
require(magrittr)
require(kableExtra)

#---knit cover/intro(abstract &toc)
	knit("cover.Rnw")
	knit("intro.Rnw")

#---knit chapters and subsections
	knit("chap1.Rnw")
	
	knit("chap2.Rnw")
	
	knit("chap3.Rnw")
		knit("chap31.Rnw")
		knit("chap32.Rnw")
		knit("chap33.Rnw")
		knit("chap34.Rnw")
		knit("chap35.Rnw")

#---bibliography!
	knit("references.Rnw")

#---put it ALL together!!
	knit("495.Rnw")
