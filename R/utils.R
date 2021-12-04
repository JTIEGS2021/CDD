#gt summary


## tbl_sum
## - args: dataframe, list of variables inclusion variables
## - outputs a gtsummary tb_summary
tbl_sum <- function(df, add, categorical) {
  df %>% select(add) %>%
    tbl_summary(type = all_of(add) ~ "categorical") %>%
    as_gt
}
#tbl_sum(df_base, add, categorical)



## select_var levels
select_var <- function(df, var) {
  df %>% select(var) %>% distinct()
}
#select_var(df_base, "id")


## filter data
## - return filtered dataset
filter_df <- function(dfnt, ids=NULL, dates=NULL) {
  if(is.null(ids) & !is.null(dates)) {
    print("1")
    df <- dfnt %>% filter(date %in% as.Date(dates))
  } else if (!is.null(ids) & is.null(dates)) {
    print("2")
    df <- dfnt %>% filter(id %in% ids)
  } else if (!is.null(ids) & !is.null(dates)) {
    print("3")
    df <- dfnt %>% filter(id %in% ids, date %in%as.Date(dates))
  } else {
    df <- dfnt
  }
  return(df)
}
#filter_dat(df_base, "20211202asf", c("2021-12-03"))


