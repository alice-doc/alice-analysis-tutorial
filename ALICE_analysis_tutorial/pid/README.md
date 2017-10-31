# Particle Identification

In this section, we’ll try to identify particles, by using the amount of energy they have lost per distance traveled in the Time Projection Chamber (TPC). Some specific technical information on how to implement this in your task is given at the end of this document, but general steps to follow are explained here. First, the goals. What we want to do is

*   identify pions

*   check how ’pure’ our pion sample is

We’ll do this by looking at the TPC signal, and seeing how well this signal corresponds to the expected signal for a certain particle species. Look at the figure for clarification, you see lines (the expected signal a particle leaves in the TPC, ‘the hypothesis’) and in colors, the actual signals that were deposited.

Start by storing the TPC signals for all charged particles in your events, in a two-dimensional histogram (such as shown in the figure). First follow the ’technical steps’ from Sec. 8, and then try to make such a plot.

Hint, you can get this information by doing

```cpp
fYour2DHistogram->Fill(track->P(), track->GetTPCsignal());
```

If your histogram is _empty_ after running, try using Filterbit 1 rather than 128.

As a second step, you identify particles, and store only the TPC signal that corresponds to pions. Use the `NumberOfSigmasTPC` functions explained in Sec. 8.

If you are confident that you’ve ’isolated’ the pions, create new histograms to store the pion’s

* $$p_{T}$$ spectrum

* $$\eta$$

* $$\varphi$$

Change the centrality of collisions that you accept: select pions in 0-10% centraliy, and 50-60% centrality. Does the number of pions change in the way you would expect them to change ?