# cursoring
Control + down arrow
Moves to the last populated cell in a column

# pasting 
Paste Special
Paste as values. 
Paste Special also allows you to _transpose_ the data from vertical to horizontal and vice versa when pasting. 

# formulas for locating and pulling values
## MATCH
Sometimes you want to know the place in a line of some element in a column or row. 
```
=MATCH("HAMBURGER", A2:A:15,0)
```

## INDEX
Takes a range of values and a row and column number and returns the value in the range at that location. 
```

```

## OFFSET 
You provide a range which acts like a cursor which is moved around with row and olumn offsets (similar to Index except its 0-based).
```
=OFFSET(A1, 3,0)
```

## SMALL
Nth smallest value
```
=SMALL(SERIES, N)
```

## VLOOKUP HLOOKUP
The false at the end of the formula means you will not accept approximate matches. 
```
=VLOOKUP(A2, MATRIX, 2,FALSE)
```

# Filtering and Sorting
Put cursor in a1, then press shift+control+down arrow, then right arrow 
Then press Filter in the data ribbon

# Using array formulas
## SUMPRODUCT
## TRANSPOSE

# Solving stuff with Solver