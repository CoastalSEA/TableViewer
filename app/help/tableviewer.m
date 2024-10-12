%% TableViewer
% App that enables tables of data to be loaded from text files, 
% spreadsheets, or .mat files containing tables.

%% Licence
% The code is provided as Open Source code (issued under a BSD 3-clause License).

%% Requirements
% TableViewer is written in Matlab(TM) and requires v2016b, or later. In addition, 
% TableViewer requires both the <matlab:doc('dstoolbox') dstoolbox> and the 
% <matlab:doc('muitoolbox') muitoolbox>

%% Background
% TableViewer App is a MatlabTM App to load tabular data from text files, 
% spreadsheets and table or dstable data held in a .mat file. This allows 
% the rapid viewing of a range of default plots, interactive plotting and 
% statistics tools and the ability to add bespoke analysis and plotting. 
% The latter has the advantage that the functions and outputs can be more 
% clearly documented than is often the case in a spreadsheet, thereby 
% maintaining the history (especially if the functions are maintained in a 
% version control repository, such as git or svn). If the latter is 
% intended use, you can clone the TableViewer from github (https://github.com/CoastalSEA) 
% if you want to build and maintain your own version of the App. 
% Alternatively, you can create a branch and contribute your additions to 
% the development.

%% TableViewer classes
% * *TableViewer* - defines the behaviour of the main UI.

%% TableViewer functions
% * *tableviewer_user_tools* - includes a function to create a figure t
% abulating a dataset and the option for the user to add functions as required.
% * *tableviewer_user_plots* - includes functions to plot a scatter diagram 
% of two variables from any case (selected variables must be the same 
% length) and a bar chart of a variable with the bars coloured based on a 
% selected classification variable (from the same dataset as the main variable). 

%% Manual
% The <matlab:tableviewer_open_manual manual> provides further details of setup and 
% configuration of the model. Sample input files can be found in
% the example folder <matlab:tableviewer_example_folder here>. 

%% See Also
% <matlab:doc('muitoolbox') muitoolbox>, <matlab:doc('dstoolbox') dstoolbox>.
	