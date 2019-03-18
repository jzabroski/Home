# Multi-line CSS ellipsis

# Ellipsis in a table-cell (td element)
> Text overflow can only happen on block or inline-block level elements, because the element needs to have a width in order to be overflow-ed. The overflow happens in the direction as determined by the direction property or related attributes.<br/>
> Source: https://css-tricks.com/almanac/properties/t/text-overflow/

1. https://stackoverflow.com/questions/9789723/css-text-overflow-in-a-table-cell
> Apparently, adding:
> ```css
> td {
>   display: block; /* or inline-block */
> }
> ```
> solves the problem as well.

2. https://stackoverflow.com/questions/9789723/css-text-overflow-in-a-table-cell/30362531
> To clip text with an ellipsis when it overflows a table cell, you will need to set the max-width CSS property on each td class for the overflow to work. No extra layout div's are required
>
> ```css
> td {
>    max-width: 100px;
>    overflow: hidden;
>    text-overflow: ellipsis;
>    white-space: nowrap;
> }
> ```

> For responsive layouts; use the max-width CSS property to specify the effective minimum width of the column, or just use max-width: 0; for unlimited flexibility. Also, the containing table will need a specific width, typically width: 100%;, and the columns will typically have their width set as percentage of the total width
> 
> ```css
> table {
>    width: 100%;
> }
> td {
>    max-width: 0;
>    overflow: hidden;
>    text-overflow: ellipsis;
>    white-space: nowrap;
> }
> td.columnA {
>    width: 30%;
> }
> td.columnB {
>    width: 70%;
> }
> ```
> 
> Historical: For IE 9 (or less) you need to have this in your HTML, to fix an IE-specific rendering issue
> ```css
> <!--[if IE]>
> <style>
>     table {
>        table-layout: fixed;
>        width: 100px;
>     }
> </style>
> <![endif]-->
> ```
