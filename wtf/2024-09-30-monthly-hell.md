---
title: Monthly SQL hell
---

Recently, I learned from [MySQL 8.0 docs](https://dev.mysql.com/doc/refman/8.0/en/explain-output.html#explain-extra-information), that:

> If you want to make your queries as fast as possible, look out
> for Extra column values of Using filesort and Using temporary,
> or, in JSON-formatted EXPLAIN output, for using_filesort and
> using_temporary_table properties equal to true.

So, I guess that I should probably stay away from these filesort
and temporary table things. That sounds fair 🤔

You already know where this is going, but let's see what
`EXPLAIN` has to say about this suspiciously large query.

```
> EXPLAIN select '' -- Lots and lots of gibbe^Wperfectly valid SQL.
+----+--------------+-----------------------------------+---------------------------------+
| id | select_type  | table                             | Extra                           |
+----+--------------+-----------------------------------+---------------------------------+
+ Truncated...
| 13 | UNION RESULT | <union1,2,3,4,5,6,7,8,9,10,11,12> | Using temporary; Using filesort |
+----+--------------+-----------------------------------+---------------------------------+
25 rows in set, 1 warning (0.10 sec)
```

Oh, that doesn't look too great (also, sorry if you're on mobile). I sure
hope no one runs that query in a loop, or things could go wrong, right? Right?

![Oh no](https://static.cyprio.net/pics/2024-09-mysql-cpu-usage.png)
