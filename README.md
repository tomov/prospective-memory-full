This is all the final code for the Prospective Memory Project from 2014 -- for the simulations, and to generate the figures.

To simulate Experiment 1:

1. Open MATLAB and cd to the current directory
2. run `Experiment_1_gen_data/RUNME.m`

To generate a figure from the paper, e.g. Figure 9:

1. Open `FIGURE_9.m` and comment out the first line that says `load('exp1-data.mat')` -- this is so you can just use the previously generated data easily to make the figures
2. run `Figure_9.m`

To generate other figures, repeat the same steps except running `RUNME.m` from the appropriate experiment directory and running the appropriate `FIGURE_XX.m` file.
