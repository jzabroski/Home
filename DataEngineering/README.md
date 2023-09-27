# Data Testing Test Heuristics

## Zero-One-Some Testing

See: http://blogs.lessthandot.com/index.php/datamgmt/datadesign/zero-one-some-testing/

Definition:
Zero-One-Some says that if multiple instances of a value are allowed, then there should be a test for zero of them; one of them; and some of them. Zero-One-Some is sometimes referred to as Zero-One-Many and is often related to cardinality in the database.

Special Cases:
Joins: When multiple tables are joined together in a query, we must often consider the cardinality of the relationship between the tables. Is there a one-to-one relationship between the tables (and is that relationship enforced)? How about a one-to-many or a many-to-many relationship? These impact what tests are needed.

The join type (e.g. inner, left or right outer, full) must also be considered. These are a few of the possibilities:

1. A record exists in the left table, but there are no matches in the right table.
2. A record exists in the left table and there is exactly one match in the right table.
3. A record exists in the left table and has multiple matches in the right table.
4. A record exists in the right table, but has no matches in the left table.

And so on…
