%% Menu Options
% Summary of the options available for each drop down menu.

%% File
% * *New*: clears any existing model (prompting to save if not already saved) and a popup dialog box prompts for Project name and Date (default is current date). 
% * *Open*: existing Asmita models are saved as *.mat files. User selects a model from dialog box.
% * *Save*: save a file that has already been saved.
% * *Save as*: save a file with a new or different name.
% * *Exit*: exit the program. The close window button has the same effect.

%% Tools
% * *Refresh*: updates Cases tab.
% * *Clear all > Project*: deletes the current project, including all Setup data and all Cases.
% * *Clear all > Figures*: deletes all results plot figures (useful if a large number of plots have been produced).
% * *Clear all > Cases*: deletes all Cases listed on the Cases tab but does not affect the model setup.

%% Project
% * *Project Info*: edit the Project name and Date
% * *Cases > Edit Description*: user selects a Case to edit the Case description.
% * *Cases > Edit DS properties*: initialises the  UI for editing Data Set properties (DSproperties).
% * *Cases > Edit Data Set*: initialises the Edit Data UI for editing data sets.
% * *Cases > Modify Variable Type*: select a variable and modify the data type of that variable. Used mainly to make data categorical or ordinal.
% * *Cases > Save*: user selects a data set to be saved from a list box of Cases and the is then prompted to name the file. The data are written to an Excel spreadsheet. 
% * *Cases > Delete*: user selects Case(s) to be deleted from a list box of Cases and results are then deleted (model setup is not changed).
% * *Cases > Reload*: user selects a Case to reload as the current parameter settings.
% * *Cases > View settings*: user selects a Case to display a table listing the parameters used for the selected Case. 
% * *Export/Import > Export*: user selects a Case class instance to export as a mat file.
% * *Export/Import > Import*: user selects an exported Case class instance (mat file) to be loaded.
%%
% *NB*: to export the data from a Case for use in another application 
% (eg text file, Excel, etc), use the *Project>Cases>Edit Data Set* option 
% to make a selection and then use the ‘Copy to Clipboard’ button to paste 
% the selection to the clipboard.

%% Setup
% * *Import Data*: dialogue to import data from a file. See
% <matlab:tableviewer_open_manual manual> for details of file formats.
% * *Input Parameters*: dialogue to define input parameters (template for user to define inputs required).
% * *Model Constants*: a number of constants are used in the model. Generally, the default values are appropriate but these can be adjusted and saved with the project if required.

%%
% _*Accessing the Input Parameters:*_
% The data are saved to _mobj.Inputs.TVparameters_, where _mobj_ is an 
% instance of the *TableViewer* class. The parameters are set using: 
%%
% * _setClassObj(mobj, 'Inputs', 'TVparameters', obj)_, where _obj_ is an 
% instance of *TVparameters*; and can be accessed using:
% * _getClassObj(mobj, 'Inputs', 'TVparameters')_, or directly using 
% _mobj.Inputs.TVparameters_. 
%%
% Both return the saved instance of the 
% *TVparameters* object. Alternatively, use _getProperties_ to return a cell 
% array, _getPropertiesStruct_ to return a struct, or _getPropertiesTable_ to return 
% a table; e.g., 
%%
%   params = getProperties(mobj.Inputs.TVparameters);
%   paramtable = getPropertiesTable(mobj.Inputs.TVparameters);


%% Run
% * *User Tools*: calls function for user defined functions. Default version 
% includes a function to create a figure tabulating a dataset and the 
% option for the user to add functions as required.
% * *Derive Output*: initialises the Derive Output UI to select and define manipulations of the data or call external functions and load the result as new data set.

%% Analysis
% * *Plots*: initialises the Plot UI to select variables and produce various types of plot. The user selects the Case, Dataset and Variable to used, along with the Plot type and any Scaling to be applied from a series of drop down lists, 
% * *Statistics*: initialiss the Statistics UI to select data and run a range of standard statistical methods.
% * *User Plots*: calls function for user defined plots. default version 
% includes functions to plot a scatter diagram 
% of two variables from any case (selected variables must be the same 
% length) and a bar chart of a variable with the bars coloured based on a 
% selected classification variable (from the same dataset as the main variable). 

%% Help
% * *Help>Documentation*: access the online documentation for TableViewer.
% * *Help>Manual*: access the <matlab:tableviewer_open_manual manual> pdf file.

%% See Also
% The <matlab:tableviewer_open_manual manual> provides further details of setup and 
% configuration of the model.