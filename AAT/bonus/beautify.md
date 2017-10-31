# Make it presentable

By now, you have made quite a few nice plots. Modify the code such that the labels, titles, markers, colors, legends of your plots look decent and presentable for fellow colleagues

* Did you know that you can use LaTeXin root? this comes in handy when you are labeling axes, etc

* Store one or two of your pictures. You can store them as ROOT files, macros, or as graphics. Always use vector graphics (.ps, .pdf)!

* Never be afraid to make titles and axis labels larger, it’s better if things look a bit ’cartoonish’ than when half of the collaboration cannot read what’s on your plots - especially when they are broadcast or projected

In practice, we usually don’t use the TBrowser for ’postprocessing’, but write dedicated code that opens our AnalysisResults.root files, does some final calculations, and makes our plot pretty.