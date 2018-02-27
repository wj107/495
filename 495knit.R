########################################################################
########## Quick File to KNIT all the chapters in the 495 report
########################################################################

require(knitr)

knit("top.Rnw")
knit("chap1.Rnw")
knit("chap2.Rnw")
knit("chap3.Rnw")

knit("495.Rnw")
