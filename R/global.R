read_df_base <- function() {
  df_base <- readRDS("df_base.rds")
  return(df_base)
}
df_base <- read_df_base()

df <- tibble(                     `pid` = "" ,
                                  `ui:2` = "" ,
                                  `proc:2` = "",
                                  `med:2` = "",
                                  `ui_any:2` = "" ,
                                  `age_bin_5:14` = "",
                                  `charlson_comorb:5 (1-5, 1 being mild 5 being extreme)` = "",
                                  `zip3:20 (not accurately distributed)` = "",
                                  `date_dx_proc_med:91` = "" ,
                                  `referal:3` = "",
                                  `PRO_1:4` = "",
                                  `id` = "",
                                  `date` = "")



#upload_df <- tibble()

upload_password = "admin"

ncheck <- c(
  "pid"  ,
  "ui:2" ,
  "proc:2",
  "med:2",
  "ui_any:2" ,
  "age_bin_5:14" ,
  "charlson_comorb:5 (1-5, 1 being mild 5 being extreme)",
  "zip3:20 (not accurately distributed)",
  "date_dx_proc_med:91" ,
  "referal:3" ,
  "PRO_1:4"#,
  #"id",
  #"date"
)
