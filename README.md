# Clinical Data Dasboard

## Objective

This application is built as a specific tool for data accumulation for the P20 research grant. The application has two primary functions

1.  interface for accumulating serial data collections
2.  generating summary reports of the data

## Overview

### Welcome

This tab contains background information regarding the app, including this overview and information regarding the state of the application variable inputs (see Variable State)

### Dataset

This tab contains the current dataset. The dataset can be filtered using the options on the table, but it is read-only. When new data is added the page can be refreshed to reload the dataset.

### Report

This tab allows generation of summary reports from selected data. The summary report can be downloaded as a pdf. Allows for selection of variables to output dataset and for filtering of the summarized variables by Date data uploaded and ID of upload. More summary report options will be added in the future (see roadmap)

### Load

This tab contains the upload feature of the app. It is password protected, so only certain users can upload data. The upload feature allows for upload of single ".xlsx" files only. (Multiple files need to be loaded sequentially) The selected upload file is docked and pre-processed before addition to dataset. The preprocess features include a variable name confirmation and a visulization of the data. More preprocess features will be added in the future (see roadmap) Once the data is confirmed as appropriate it can be added to the existing dataset. A summary report of the uploaded data can be generated in the Report tab by selecting the date or ID of upload.

## Variable State

Default State of key in-app variables, which can be found in global.R.

#### Upload Pasword

`upload_password = "admin"`

#### Variable Name Check

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

## Roadmap

#### Load

1.  filter out fully null observations
2.  flag values outside of normal range of variable values

#### Report

1.  stratified reports
2.  modeling

#### Other

1.  upgrade load password protection
2.  many of the functions need to be wrapped in try-catch blocks to reduce bugs. Many of the features have been built to reduce or adapt to inconsitencies of input, but a full code review is still required. (notably file input/output extension)
3.  full unit testing
4.  code comment
5.  better database backends
