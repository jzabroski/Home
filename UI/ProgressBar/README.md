[Toward a Progress Indicator for Machine Learning Model Building and Data Mining Algorithm Execution: A Position Paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5699516/)

* An indeterminate progress indicator like looped animation shows that the task is running, but gives no hint on when the task will finish.
* In contrast, a determinate progress indicator continuously estimates the remaining task execution time and/or the portion of the task that has been finished. This helps users better use their time. Frequently, even a rough estimate of the remaining task execution time can benefit user

> An ideal progress indicator should fulfill the following four goals [42, 43]:
> 
> * **Continuously revised estimates**: At any moment, for any information displayed to users, the progress indicator should provide an estimate based on all information available about the computer and model building task at that moment. The estimate should be continuously revised based on more accurate information about the task and changes in model building speed.
> 
> * **Acceptable pacing**: The progress indicator’s update rate should be sufficiently high for users to see a smooth display, but not be too high to overburden the user interface or users.
> 
> * **Minimal overhead**: The progress indicator should have little impact on model building efficiency.
> 
> * **Maximal functionality**: Many machine learning algorithms exist, each with one or more hyper-parameters. The progress indicator should support many algorithms and give useful information for each hyper-parameter value combination of a supported algorithm.

