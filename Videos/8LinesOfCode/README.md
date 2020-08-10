# [8 Lines of Code](https://www.infoq.com/presentations/8-lines-code-refactoring/), QCon keynote talk, by Greg Young

Every time I think I've made an advancement in my notation, somebody points out something wrong with it.
For example, inversion of control containers lets me abstract over N number of constructor parameters by mapping an interface to an implementation.

But then someone will say, "Well, how carefully have you thought of whether the dependencies you're injecting are matched to the lifetime of what uses those dependencies?
Can you do without IoC and instead just use this thing called Partial Application over and over until you have no free variables?"

And they will argue this is a cleaner approach, because in both cases, the end result is a lambda with no free variables, 
and all you have to understand to get it to work is higher order functions and partial application to gradually close off variables until you have a Component.

In both cases, I want n degrees of freedom in a system, because if I can write my systems as linear, independent combinations of features,
the chance for re-use increases and places to fix bugs decreases.
But, the downside to changing my notation to partial application is its a huge pain to refactor and introduce new parameters,
unless those parameters are aggregated by an object so that I can hide passing those values around.
But then we go back to the original objection of IoC and variable initialization matching actual required scope.
