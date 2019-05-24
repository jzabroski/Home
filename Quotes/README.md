> Recognizes right answer when told. ~ Tom Breuer

> Someone who majors in the minors and minors in the majors. ~ Tom Breuer

> Fulton's Folly

> He builds a mental castle before having to dig a moat. ~ Nelson

> Passwords are like underwear. You shouldn't leave them out where people can see them. You should change them regularly. And you shouldn't loan them out to strangers. ~ Source Unknown

> Discipline is not what you do to someone; it’s what you do for someone. - Lou Holtz

> Ability is what you're capable of doing; Motivation determines what you do; Attitude determines how well you do it. - Lou Holtz

> Getting on a player is not necessarily appreciated. But caring about players doesn’t mean making it easy for them. Caring is helping them to develop traits and talents. My job is to provide athletes with a chance to win. A coach can’t win, no coach has ever won a game. - Lou Holtz

> Sometimes the questions are complicated and the answers are simple. ~ Dr. Seuss (Theodor Seuss Geisel), American writer and cartoonist 

> Time is a flat circle. Everything we have done or will do we will do over and over and over again- forever. ~ True Detective TV show, but actually [Nietzsche's Doctrine of Eternal Recurrence](https://www.quora.com/What-does-the-expression-Time-is-a-flat-circle-mean)

> He who has a why to live can bear almost any how.
> ~ Friedrich Nietzsche

> One may know how to conquer without being able to do.
> ~ Sun Tzu

> We probably just had a Orville and Wilbur Kitty Hawk moment in science--and the analysts want to know why "only 59 seconds?"
> ~ SeekingAlpha user [dunwoody_joe](https://seekingalpha.com/user/1099753/comments), commenting on [Sangamo's Gene Therapy Results](https://seekingalpha.com/article/4204400-sangamos-gene-therapy-results)

> # Regularizing a Linear Model
> If I could leave readers with only one thought, it would be this: *the strength of your indicators is vastly more important than the strength of the predictive model that uses them to signal trades.* Some of the best, most stable, and profitable trading systems I've seen over the years use a simple linear or nearly linear model with high quality indicators as inputs. [...]
>
> There are many advantages to using a linear model for a predictive-model-based trading system, as opposed to a complex, nonlinear model:
> * Linear models are less likely, often *much* less likely to overfit the training data. As a result, the *training bias* is minimized. [...]
> * Linear models are easier to understand than  many or most nonlinear models. Understanding how indicator values relate to trade decisions can be an extremely valuable property of prediction models.
> * Linear models are usually faster to train than nonlinear models. [...]
>
> *Testing and Tuning Market Trading Systems Algorithms in C++* by Timothy Masters

> Comparing, say, Kx systems Q/KDB (80s technology which still sells for upwards of $100k a CPU, and is worth every penny) to Hive or Redis is an exercise in high comedy. Q does what Hive does. It does what Redis does. It does both, several other impressive things modern “big data” types haven’t thought of yet, and it does them better, using only a few pages of tight C code, and a few more pages of tight K code.
> ~ scottlocklin.wordpress.com

> There's been an explosion in raster data in just the last 5 years. Cheap satellites, cheap drones, and cheap platforms have really turned the firehose to "high". And the resolution on scientific data -- climate and weather model output, astronomy data, particle physics data, seismic data, etc. -- just keeps going up.
> 
> This is an area of massive growth for which no existing solution is quite adequate. 
> ~ [monodeldiablo](https://news.ycombinator.com/user?id=monodeldiablo) - https://news.ycombinator.com/item?id=13582631

> [The Discrete-time Stochastic Systems] class was the first time I saw probability applied to an algorithm. I had seen algorithms take an averaged value as input before, but this was different: the variance and mean were internal values in these algorithms. The course was about "time series" data where every piece of data is a regularly spaced sample. [... In the Machine Learning class] the data was not assumed to be uniformly spaced in time, and they covered more algorithms but with less rigor. I later realized that similar methods were also being taught in the economics, electrical engineering, and computer science departments. 
> Page xvii, Machine Learning in Action by Peter Harrington



> Consistency means not only using the same ratios or formulas; it also means using the correct time period. Let's use a simple example: Think about depositing $10,000 in a bank on January 1. At the end of the year, you receive your statement and see your interest for the year was $1,000, bringing your year-end balance to $11,000. *What is the return on your investment for the year?* It is 10% ()the year's earnings of $1,000 divided by the initial investmment, or opening balance, of $10,000). However, when we calculated ROA (ROE) above, we divided the income for the year by the assets (equity) at year-end. This calculation is comparable to divdiing the $1,000 of interest by the $11,000 year-end balance, giving a return of 9.1%, which is not correct. To accurately measure the yearly return on the assets invested, we need to divide the total yearly income by the initial investment, which is the beginning-of-the-year amount of total assets or equity.
> 
>    Initial Investment on January 1st = $10,000
>    Ending Investment on December 31st = $11,000
>    Earnings = $11,000 - $10,000 = $1,000
>    Return on investment = ?
>    The **correct** return calculation is: Earnings/Initial Investment = $1,000/$10,000 = 10%
>    The **incorrect** return calculation is: Earnings/Ending Investment = $1,000/$11,000 = 9.1%
>  
> Analysts often mistakenly divide income by end-of-year assets or equity to determine ROA or ROE. They do this because the numbers are readily available on each year's Income Statement and Balance Sheet. In contrast, many textbooks, when dividing an Income Statement number by a Balance Sheet number, average the Balance Sheet number over the year. The average is usually computed as the average of the begin-of-year (which is the same as the end of the previous year) and end-of-year balances. This alternative may make sense if a firm is growing rapidly and additional investments are being made during the year. However, in general, the opening numbers provide a more realistic ratio.
> ~ Determining a Firm's Financial Health (PIPES-A), Lessons in Corporate Finance: A Case Studies Approach to Financial Tools, Financial Policies, and Valuation by Paul Asquith

> # Dependencies and glue
> 
> While writing the preceding section, I ran into a difficulty that took me a while to resolve. Supposedly, it is advantageous to organise things such that the core is a sink in the dependency graph, but what does this mean for the language definition/implementation pieces?
> 
> Eventually I realised my mistake --- I had confused in my mind the two kinds of language embedding an interface could be. There is no problem if something is a data type, but there is if you use a Java-style interface. An interface, as I have stated, is a tagless-final embedding --- the interface defines a language; the implementors of the language define an interpreter. Components that are parameterised by an interface are _parameterised by the interpreter_. That is, in the ML sense, those components are functors, which take an instantiation of some signature to plug into its machinery.
> 
> Thus, the core of the application should consist of: a functor parameterised by a bunch of interface language signatures that it defines and controls. All external components that you wish to make communicate with the core logic must implement one of the well-defined IO signatures. That's it.
> [Language-oriented software engineering: (sort of) a book review of Clean Architecture](http://parametri.city/blog/2018-12-23-language-oriented-software-engineering/index.html)

> # What is a framework?
> 
> > A framework F is an interpreter from language Fi to language Fo (the API).
> 
> The trouble with frameworks is that to use it, you have to match your application to the language of the API. If you're not careful, you end up coupling your system to the framework. This means that you create a cycle between yourself and the framework by architecting your component as an interpreter from Fo to Fi. This gives rise to all sorts of awkwardness and bugs due to the inevitable semantic mismatch. Then when the authors of F decide to change that language, you're screwed. If you want to be in control, you design your own language.
> 
> The proper way to use a framework is as Bob describes: compartmentalise it in a module at the outer edges of the system. That means, writing a compiler from your internal output language L_o to F, keeping that away from everything else. Framework code wiring is just a interpreter!
> [Language-oriented software engineering: (sort of) a book review of Clean Architecture](http://parametri.city/blog/2018-12-23-language-oriented-software-engineering/index.html)


> But that's the point. Spreadsheets stay out of the way. They allow you to see the data and to touch (or at least click on) the data. There's freedom there. In order to learn these techniques, you need something vanilla, something everyone understands, but noiseless, something that will let you move fast and Light as you learn. That's a spreadsheet. 
> Page xviii, Data Snart: Using DTa Science to Transform Information to Insight by John W. Foreman

> # What About Google Drive? 
> Now, some of you might be wondering whether you can use Google Drive. It's an appealing option since Google Drive is in the cloud and can run on your mobile devices as well as your betide box. But it just won't work. 
> Google Drive is great for simple spreadsheets, but for where you're going, Google just can't hang. Adding rows and columns in Drive is a constant annoyance, the implementation of Solver is dreadful, and the charts don't even have trendlines. I wish it were otherwise. 
> Page xviii, Data Snart: Using DTa Science to Transform Information to Insight by John W. Foreman



> 
