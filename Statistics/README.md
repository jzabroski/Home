# Books
1. Statistical Re-thinking
2. [Modern Data Science in R](https://mdsr-book.github.io/mdsr2e/) - 4* on amazon; negative reviews were about print in black and white, not color.
3. [R for Data Science](https://r4ds.had.co.nz/) - 4.7* on amazon, 1,395 reviews.

# p-Values vs. Bayesian Inference

With Bayes, you only care about the likelihood of something occurring, so it is well-suited to "private analysis" for your own purposes.

With p-Values, there is a system effect, where other people can rely on your results (e.g., scientific community).


# Replication Crisis, R-INDEX and Inflation Rates

One problem with replication is that a lot of studies might measure for a 0.05 p-value, and so you end up with a lot of 0.04999 p-values in studies, so the question becomes: Did the researchers massage their data until they got the answer they were looking for?

# PCA vs. Factor Analysis

The fundamental difference is that Principal Components Analysis does not impose testable restrictions on the parameterization of the covariance matrix. This is because any real symmetric matrix can be decomposed into its eigenvalues and eigenvectors. PCA computes that decomposition, and then the user selects the linear combinations he thinks are most important. However, the identity between the covariance matrix and its decomposition means that PCA does not restrict the structure of the covariance matrix. Every covariance matrix can be decomposed into its principal components.

On the other hand, when the Factor Analysis model is written mathematically and the covariance matrix is computed, one can see that the factor loadings enter into the covariance matrix as squares and cross products. Factor analysis therefore imposes parameter restrictions on the covariance matrix that can be tested statistically. Therefore, unlike PCA, NOT every covariance matrix can be represented by the Factor Analysis model.

# Signal Detection Theory 

## True Positive Fraction (TPF)
## False Positive Fraction (FPF)
## Detection Threshold 

https://www.researchgate.net/publication/320867262_A_New_Standard_for_Assessing_the_Performance_of_High_Contrast_Imaging_Systems

> As planning for the next generation of high contrast imaging instruments (e.g. WFIRST, HabEx, and LUVOIR, TMT-PFI, EELT-EPICS) matures, and second-generation ground-based extreme adaptive optics facilities (e.g. VLT-SPHERE, Gemini-GPI) are halfway through their principal surveys, it is imperative that the performance of different designs, post-processing algorithms, observing strategies, and survey results be compared in a consistent, statistically robust framework. In this paper, we argue that the current industry standard for such comparisons -- the contrast curve -- falls short of this mandate. We propose a new figure of merit, the "performance map," that incorporates three fundamental concepts in signal detection theory: the true positive fraction (TPF), false positive fraction (FPF), and detection threshold. By supplying a theoretical basis and recipe for generating the performance map, we hope to encourage the widespread adoption of this new metric across subfields in exoplanet imaging.

# The Reign of the _p_-Value is Over: what alternative analyses could we employ to fill the power vacuum?

https://royalsocietypublishing.org/doi/10.1098/rsbl.2019.0174

> Abstract
> The p-value has long been the figurehead of statistical analysis in biology, but its position is under threat. p is now widely recognized as providing quite limited information about our data, and as being easily misinterpreted. Many biologists are aware of p's frailties, but less clear about how they might change the way they analyse their data in response. This article highlights and summarizes four broad statistical approaches that augment or replace the p-value, and that are relatively straightforward to apply. **First**, you can augment your p-value with information about how confident you are in it, how likely it is that you will get a similar p-value in a replicate study, or the probability that a statistically significant finding is in fact a false positive. **Second**, you can enhance the information provided by frequentist statistics with a focus on effect sizes and a quantified confidence that those effect sizes are accurate. **Third**, you can augment or substitute p-values with the Bayes factor to inform on the relative levels of evidence for the null and alternative hypotheses; this approach is particularly appropriate for studies where you wish to keep collecting data until clear evidence for or against your hypothesis has accrued. **Finally**, specifically where you are using multiple variables to predict an outcome through model building, Akaike information criteria can take the place of the p-value, providing quantified information on what model is best. Hopefully, this quick-and-easy guide to some simple yet powerful statistical options will support biologists in adopting new approaches where they feel that the p-value alone is not doing their data justice.
