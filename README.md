# fta
**Frequency-tagging analysis for EEG data.**

The pipeline computes the entrainment to the oscillatory stimulation in three ways:
1) Computing the average power spectrum like here:
https://www.sciencedirect.com/science/article/abs/pii/S1053811908009981
and here:
https://www.pnas.org/content/116/10/4625.short
2) Computing the inter-trial coherence like here:
https://www.sciencedirect.com/science/article/abs/pii/S0093934X15000565
3) Computing the power spectrum of the ERP like here:
https://elifesciences.org/articles/6564

The main script listing all the others is: fta_workflow_generic.m
where all the main steps are commented.
