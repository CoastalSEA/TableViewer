# TableViewer
App that enables tables of data to be loaded from text files, spreadsheets, or .mat files containing tables.

## Licence
The code is provided as Open Source code (issued under a BSD 3-clause License).

## Requirements
TableViewer is written in Matlab(TM) and requires v2016b, or later. In addition, TableViewer requires the _dstoolbox_ and the _muitoolbox_.

## Background
TableViewer App is a MatlabTM App to load tabular data from text files, spreadsheets and table or dstable data held in a .mat file. This allows  he rapid viewing of a range of default plots, interactive plotting and statistics tools and the ability to add bespoke analysis and plotting. The latter has the advantage that the functions and outputs can be more clearly documented than is often the case in a spreadsheet, thereby maintaining the history (especially if the functions are maintained in a version control repository, such as git or svn). If the latter is intended use, you can clone the TableViewer from github (https://github.com/CoastalSEA) if you want to build and maintain your own version of the App. Alternatively, you can create a branch and contribute your additions to the development.

## TableViewer classes
* *TableViewer* - defines the behaviour of the main UI.
* *TVparameters* - defines input parameters. This is a template for user to define any inputs required for bespoke data analysis functions. The class file has to be edited to define the requied inputs.

## TableViewer functions
* *tableviewer_user_tools* - includes a function to create a figure tabulating a dataset and the option for the user to add functions as required.
* *tableviewer_user_plots* - includes functions to plot a scatter diagram of two variables from any case (selected variables must be the same length) and a bar chart of a variable with the bars coloured based on a selected classification variable (from the same dataset as the main variable). 

## Manual
The TableViewer manual in the app/doc folder provides further details of setup and configuration of the model. The files for the example use case can be found in the app/example folder. 
## See Also
The repositories for _dstoolbox_, _muitoolbox_ and _muiAppLIb_.