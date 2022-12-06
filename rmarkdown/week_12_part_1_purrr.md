---
title: "Week 13 - Part I - Functional programming with Purrr - Continued"
author: "Jose Luis Rodriguez Gil"
date: "29/11/2022"
output: 
  html_document:
    toc: true
    toc_depth: 2
    toc_float:
      collapsed: false
      smooth_scroll: false
    theme: cosmo
    highlight: tango
    number_sections: true
    keep_md: true
---








## Example III - Using purrr to load multiple files at once

The approach we are going to take is to create a tibble with a column named `files` where we will list the address of all files contained in our target folder (in this case the `data` folder).

After that, we will use `map()` to iterate through that list and read each of the files, then we will bind the rows to have one single file.


```r
combined_data <- tibble(files = fs::dir_ls(here("data", "batches"))) %>%  # we create a tibble of files in that folder. Remember we are in an .Rmd file, so we need to use here()
  mutate(data = pmap(list(files), 
                     ~ read_csv(..1, col_names = TRUE))) %>%  # We load each individual file as a tibble-within-a-tibble
  select(data) %>% # select only the actual data tibbles
  map_df(bind_rows) %>%  # bind them all into one tibble
  clean_names() # clean the column names
```

```
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
combined_data
```

```
## # A tibble: 108 × 8
##    sample_id submission_date analysis_…¹ compo…² compo…³ compo…⁴ compo…⁵ compo…⁶
##    <chr>     <date>          <chr>         <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 TR_001    2018-01-27      30/3/2018 …    8.90    9.24  18.2     21.6    33.4 
##  2 TR_002    2018-01-27      30/3/2018 …    7.98   10.0   18.7     20.8    33.0 
##  3 TR_003    2018-01-27      30/3/2018 …    8.66    8.92  19.3     20.2    32.0 
##  4 TR_004    2018-01-27      30/3/2018 …    4.52    4.01   8.88    11.4    17.2 
##  5 TR_005    2018-01-27      30/3/2018 …    4.84    4.18   8.59    11.8    16.9 
##  6 TR_006    2018-01-27      30/3/2018 …    4.45    3.69   8.97     9.42   16.8 
##  7 TR_007    2018-01-27      30/3/2018 …    1.54    2.18   0.217    2.05    8.49
##  8 TR_008    2018-01-27      30/3/2018 …    1.65    2.02   0.216    2.40    9.07
##  9 TR_009    2018-01-27      30/3/2018 …    1.59    2.08   0.218    2.28    8.80
## 10 TR_010    2018-02-27      30/3/2018 …    7.83   13.4   18.3     20.1    31.4 
## # … with 98 more rows, and abbreviated variable names ¹​analysis_date_time,
## #   ²​compound_1, ³​compound_2, ⁴​compound_3, ⁵​compound_4, ⁶​compound_5
```

What if we wanted to keep important information stored in the file name (e.g. the batch number in this case)?


```r
combined_data <- tibble(files = fs::dir_ls(here("data", "batches"))) %>%  # we create a tibble of files in that folder
  mutate(data = pmap(list(files), 
                     ~ read_csv(..1, col_names = TRUE))) %>%  # We load each individual file as a tibble-within-a-tibble
  mutate(data = pmap(list(files, data), 
                     ~ mutate(..2, source_file = as.character(..1)))) %>% # To each individual dataset we add the name of the file it came from (for reference)
  select(data) %>% # select only the actual data tibbles
  map_df(bind_rows) %>%  # bind them all into one tibble
  clean_names() # clean the column names
```

```
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 27 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): sample_id, analysis_date_time
## dbl  (5): compound_1, compound_2, compound_3, compound_4, compound_5
## date (1): submission_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
combined_data
```

```
## # A tibble: 108 × 9
##    sample_id submissio…¹ analy…² compo…³ compo…⁴ compo…⁵ compo…⁶ compo…⁷ sourc…⁸
##    <chr>     <date>      <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl> <chr>  
##  1 TR_001    2018-01-27  30/3/2…    8.90    9.24  18.2     21.6    33.4  /Users…
##  2 TR_002    2018-01-27  30/3/2…    7.98   10.0   18.7     20.8    33.0  /Users…
##  3 TR_003    2018-01-27  30/3/2…    8.66    8.92  19.3     20.2    32.0  /Users…
##  4 TR_004    2018-01-27  30/3/2…    4.52    4.01   8.88    11.4    17.2  /Users…
##  5 TR_005    2018-01-27  30/3/2…    4.84    4.18   8.59    11.8    16.9  /Users…
##  6 TR_006    2018-01-27  30/3/2…    4.45    3.69   8.97     9.42   16.8  /Users…
##  7 TR_007    2018-01-27  30/3/2…    1.54    2.18   0.217    2.05    8.49 /Users…
##  8 TR_008    2018-01-27  30/3/2…    1.65    2.02   0.216    2.40    9.07 /Users…
##  9 TR_009    2018-01-27  30/3/2…    1.59    2.08   0.218    2.28    8.80 /Users…
## 10 TR_010    2018-02-27  30/3/2…    7.83   13.4   18.3     20.1    31.4  /Users…
## # … with 98 more rows, and abbreviated variable names ¹​submission_date,
## #   ²​analysis_date_time, ³​compound_1, ⁴​compound_2, ⁵​compound_3, ⁶​compound_4,
## #   ⁷​compound_5, ⁸​source_file
```

Now we can use what we know of working with strings to get the batch numbe rinto its own column.


```r
combined_data %>% 
  mutate(batch = stringr::str_extract(source_file, "(?<=Batch_)[:digit:]{1}")) %>% # extract the date using regex
  select(-source_file) # we dont need it anymore
```

```
## # A tibble: 108 × 9
##    sample_id submission_…¹ analy…² compo…³ compo…⁴ compo…⁵ compo…⁶ compo…⁷ batch
##    <chr>     <date>        <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl> <chr>
##  1 TR_001    2018-01-27    30/3/2…    8.90    9.24  18.2     21.6    33.4  1    
##  2 TR_002    2018-01-27    30/3/2…    7.98   10.0   18.7     20.8    33.0  1    
##  3 TR_003    2018-01-27    30/3/2…    8.66    8.92  19.3     20.2    32.0  1    
##  4 TR_004    2018-01-27    30/3/2…    4.52    4.01   8.88    11.4    17.2  1    
##  5 TR_005    2018-01-27    30/3/2…    4.84    4.18   8.59    11.8    16.9  1    
##  6 TR_006    2018-01-27    30/3/2…    4.45    3.69   8.97     9.42   16.8  1    
##  7 TR_007    2018-01-27    30/3/2…    1.54    2.18   0.217    2.05    8.49 1    
##  8 TR_008    2018-01-27    30/3/2…    1.65    2.02   0.216    2.40    9.07 1    
##  9 TR_009    2018-01-27    30/3/2…    1.59    2.08   0.218    2.28    8.80 1    
## 10 TR_010    2018-02-27    30/3/2…    7.83   13.4   18.3     20.1    31.4  1    
## # … with 98 more rows, and abbreviated variable names ¹​submission_date,
## #   ²​analysis_date_time, ³​compound_1, ⁴​compound_2, ⁵​compound_3, ⁶​compound_4,
## #   ⁷​compound_5
```



