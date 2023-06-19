https://www.kyvosinsights.com/glossary/calculated-measures/

# Calculated Measures
Calculated Measures are the expressions that operate on aggregations of data defined and are computed at run time to return values based on the current context.

Calculated Measures are evaluated for understanding context-based calculations in real-time. It is evaluated in the context of the cell assessed in a report or in a DAX query and the cell context depends on user selections in the report or on the state of the DAX query. For instance, when you use aggregation SUM(Sales[SalesAmount]) in a measure, this indicates that you need the sum of all the cells that are aggregated under this cell.

Due to this reason, they are not stored in your database and each time the user changes filters in the report such as rows, column selection, and slicer in a pivot table, or axes applied to a chart, the context changes, which results in slow responses as it uses processing power to execute a query at run time. So, you must know when to use Calculated Measures.

## When to use it
Calculated Measures are defined in situations where you need the resulting calculation values based on user selections and are displayed in the value area of a pivot table. For instance –

* When you want to calculate profit percentage on a particular selected data.
* When you want to calculate ratios of one product compared to all other products, and the filters are applied by year and region.

One of the requirements of the DAX language is, you need to define a Calculated Measure in a table. However, this doesn’t mean that the measure belongs to that particular table. Moreover, you can easily move a Calculated Measure from one table to another without mislaying its functionality.

## How does Kyvos use Calculated Measures?
A leading global investment bank needed to analyze billions of daily trades conducted in more than 200 different currencies to understand its daily risk exposure more accurately and prevent fraudulent activities. They needed a solution that can handle run-time currency conversions more effectively and can work on data at a massive scale.

Kyvos resolves the currency conversion problem by using its innovative OLAP technology to handle run-time currency conversions on trillions of rows of data stored on the cloud or on-premise data lakes. Its unique cubing technology enables you to build multi-fact cubes using its Smart OLAP technology where the currency dimension act as a fact and Calculated Measures are used for run-time currency conversion.

Once the OLAP model is created, you can use any BI tool to drag and drop dimensions into your visualization, select filters and switch currencies on the dashboard and perform analysis on it. For instance, You have created a visualization with three dimensions –

* Transaction Id
* Transaction Amount
* Amount in Reporting Currency

The currently applied Reporting Currency filter is EURO and you want to set it to INR and get the Transaction Amount immediately converted from EURO to INR. Kyvos achieved these On-the-fly conversions using Calculated Measures. As on-the-fly conversions eliminate the need to store all combinations, Kyvos scheduled automatic incremental cube builds provision to the needs of changing conversion rates and delivers instantaneous responses for trillions of rows of data.
