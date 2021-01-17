http://www.virtuallyimpossible.co.uk/using-ssd-drives-for-sql-server/

> * SSD write performance will degrade over time as it gets full.
> * SSD read performance stays roughly the same.
> * TRIM will help slow this down:
>     * Check your OS supports TRIM by running this command
>       ```
>       fsutil behavior query DisableDeleteNotify (should return 0)
>       ```
>     * If not 0, try to set it with this command:
>       ```
>       fsutil behavior set DisableDeleteNotify 0
>       ```
