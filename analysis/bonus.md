# Bonus contents

## Minimal systematics

As you can see in the figure, the TPC signals of different particle species cross each other. In
these regions, it is difficult (or impossible) to identify particles. Because of this ambiguity,
we have to estimate what the uncertainty on our identification routine is.

* Run the main code multiple times, varying the number of standard deviations that you require the signal to be in from 3 to 4, and from 3 to 2.

* How do your spectra change? Do these changes make sense to you?

If you are very enthusiastic,

* Try to estimate the _systematic uncertainty_ that particle identification introduces to your measurement.


## Make it presentable

By now, you have made quite a few nice plots. Modify the code such that the labels, titles, markers, colors, legends of your plots look decent and presentable for fellow colleagues

* Did you know that you can use LaTeX in ROOT? This comes in handy when you are labeling axes, etc.

* Store one or two of your pictures. You can store them as ROOT files, macros, or as graphics.
Always use vector graphics (`.ps`, `.pdf`)!

* Never be afraid to make titles and axis labels larger, it’s better if things look a bit
"cartoonish" than when half of the collaboration cannot read what’s on your plots - especially
when they are broadcast or projected

In practice, we usually don’t use the TBrowser for "postprocessing", but write dedicated code that opens our `AnalysisResults.root` files, does some final calculations, and makes our plot pretty.
