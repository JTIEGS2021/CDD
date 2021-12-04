#gt summary

df_base %>% gtsummary::tbl_summary()

df_base
table(df_base$`ui:2`)
df_base_f <- df_base %>% mutate_if(is.character, as.factor)


## tbl_sum
## - args: dataframe, list of variables inclusion variables
## - outputs a gtsummary tb_summary
tbl_sum <- function(df, add, categorical) {
  df %>% select(add) %>%
    tbl_summary(type = all_of(categorical) ~ "categorical") %>%
    as_gt
}
tbl_sum(df_base, add, categorical)

#tbl_sum(df_base, drop = c("pid","ui:2"))

        