function tableviewer_user_plots(mobj)                       
%
%-------function help------------------------------------------------------
% NAME
%   tableviewer_user_plots.m
% PURPOSE
%   user functions to do additional bespoke plots on data loaded in TableViewer
% USAGE
%   tableviewer_user_plots(mobj)
% INPUTS
%   mobj - ModelUI instance
% OUTPUT
%   user defined plot or other output
% NOTES
%    called as part of TableViewer App.
% SEE ALSO
%   TableViewer and tableviewer_user_tools
%
% Author: Ian Townend
% CoastalSEA (c) Oct 2024
%--------------------------------------------------------------------------
%  
listxt = {'Scatter plot','Type plot','Another plot','Yet another plot'};  %<< edit list, cases and function calls below as required
    ok = 1;
    while ok>0
        selection = listdlg("ListString",listxt,"PromptString",...
                            'Select option:','SelectionMode','single',...
                            'ListSize',[150,200],'Name','tvtools');
        if isempty(selection), ok = 0; continue; end

        switch listxt{selection}
            case 'Scatter plot'
                scatter_plot(mobj);
            case 'Type plot'
                type_plot(mobj);
            case 'Another plot'
                another_plot(mobj);
            case 'Yet another plot'
                yet_another_plot(mobj);
        end
    end
end

%%
function scatter_plot(mobj)
    %scatter plot of 2 variables of same length, with points that can be
    %scaled by a third variable.

    %prompt user to select type of scatter plot required
    questxt = 'Scatter plot with points (2D) or scaled data points (3D):';
    answer = questdlg(questxt,'Scatter','2D','3D','2D');

    %prompt user to select variables to be used in plot
    %NB uses =get_variable to restrict selection to variables only to
    %select variables or dimensions use get_selection
    promptxt = 'Select X-variable:';    
    [indvar,indsel] = get_selection(mobj,promptxt,'XYZmxvar',1);
    if isempty(indvar), return; end
    promptxt = 'Select Y-variable:';    
    [depvar,depsel] = get_variable(mobj,promptxt,'XYZmxvar',1);
    if isempty(depvar), return; end  
    isvalid = checkdimensions(indvar.data,depvar.data);
    if ~isvalid, return; end

    if strcmp(answer,'3D')
        promptxt = 'Select variable to scale scatter points:';    
        scalevar = get_variable(mobj,promptxt,'XYZmxvar',1);
        if isempty(scalevar), return; end 
        isvalid = checkdimensions(indvar.data,scalevar.data);
        if ~isvalid, return; end
        markersz = scalevar.data/max(scalevar.data)*1000; %scaling to give size in points
    else
        markersz = 36; %Matlab default value
    end

    %now do something with selected data
    %indvar and depvar are structs with the following fields:
    %name - variable name, data - selected data, label - variable axis label, 
    %desc - variable description, case - case description
    hf = figure('Tag','UserFig');    
    ax = axes (hf);
    legtxt = sprintf('%s(%s)',depvar.desc,indvar.desc);    
    hs = scatter(ax,indvar.data,depvar.data,markersz,'filled','DisplayName',legtxt);
    xlabel(indvar.label)
    if strcmp(indsel.scale,'Log')
        idx = find(mod(ax.XTick(:), 1) == 0);
        ax.XTick = ax.XTick(idx); %remove non integer exponents
        ax.XTickLabel = cellstr(num2str(ax.XTick(:), '10^{%d}'));
    end
    ylabel(depvar.label)
    if strcmp(depsel.scale,'Log')
        idy = find(mod(ax.YTick(:), 1) == 0);
        ax.YTick = ax.YTick(idy);  %remove non integer exponents
        ax.YTickLabel = cellstr(num2str(ax.YTick(:), '10^{%d}'));
    end
   
    legend('Location','best')
    seltxtX = get_selection_text(indvar,6,'X'); %full description of dimensions
    titxtX = get_selection_text(indvar,5,'X');  %short description of dimensions

    seltxtY = get_selection_text(depvar,6,'Y'); %full description of dimensions
    titxtY = get_selection_text(depvar,5,'Y');  %short description of dimensions            
                
    seltxt = sprintf('%s\n%s',seltxtX,seltxtY);         
    title(sprintf('%s\n%s',titxtX,titxtY))
    if strcmp(answer,'3D')
        hs.MarkerFaceAlpha = 0.5; %transparency
        seltxtZ = get_selection_text(scalevar,6,'Z'); %full description of dimensions
        titxtZ = get_selection_text(scalevar,5,'Z');  %short description of dimensions
        seltxt = sprintf('%s\n%s',seltxt,seltxtZ);
        subtitle(titxtZ)
    end
    
    %create button to allow user to view detailed selection description
    
    hf.Units = 'normalized';
    butxt = 'Selection';   %text to appear on button
    position = [0.85,0.92,0.1,0.05];          %position of button on parent (units as per parent)
    callback =  @(src,evt)display_selection(src,evt); %function to be called on button press
    tag = 'selbutton';
    tooltip = 'Details of selection made';
    hbut = setactionbutton(hf,butxt,position,callback,tag,tooltip);
    hbut.UserData = seltxt;
end

%%
function type_plot(mobj)
    %bar plot of variable against table rows, with bars shaded to reflect a
    %classification variable (e.g. Type)

    promptxt = 'Select Case to plot';
    [cobj,~,datasets,idd] = selectCaseDataset(mobj,promptxt);
    if isempty(cobj), return; end
    dst = cobj.Data.(datasets{idd});  %selected dataset
    promptxt = 'Select Variable to plot:'; 
    [~,idv] = selectAttribute(dst,1,promptxt); %1 - select a variable
    if isempty(idv), return; end

    [ax,idx,ids] = userPlot(cobj,idd,idv); %idx sort order of x-variable if a scalarplot
                                           %ids indices of selected sub-set (after sorting)

    %select variable to use for classification (restrict to selection from
    %same case but allow different dataset to be used
    promptxt = 'Select classification variable:'; 
    datasetname = getDataSetName(cobj,promptxt); 
    classdst = cobj.Data.(datasetname);    
    [~,idc] = selectAttribute(classdst,1,promptxt); %1 - select a variable
    if isempty(idc), return; end
    varname = classdst.VariableNames{idc};
    vardesc = classdst.VariableDescriptions{idc};
    typevar = classdst.(varname);  
    typevar = typevar(idx); %if sorted in userPlot ensure same order

    if isnumeric(typevar)
        %find set of unique index values
        types = unique(typevar);
    elseif ischar(typevar{1}) || isstring(typevar{1})
        %if char or string convert to categorical and ordinal
        typevar = categorical(typevar);    
        types = categories(typevar);
    end
    ntypes = length(types);

    typevar = typevar(ids); 

    %amend X-ticks if too many labels to fit easily
    if length(ax.Children.XData)>50
        nvar = length(ax.Children.XData);
        promptxt = sprintf('%d X-tick labels. Replace with integers?',nvar);
        answer = questdlg(promptxt,'Type plot','Yes','No','Yes');
        if strcmp(answer,'Yes')
            nint = 10;
            ints = 0:nint:nvar; ints(1) = 1;
            ax.XTick = num2ruler(ints,ax.XAxis);
            ax.XTickLabel =  ints;
            ax.XAxis.TickDirection = 'out';
        end
    end

    %set color map to identify each type
    mycolormap = cmap_selection();  %prompts user to select a colormap
    ncolor = size(mycolormap,1);
    %subsample the colormap for the number of types required
    custom_colormap = colormap(mycolormap(1:round(ncolor/ntypes):ncolor,:));

    %adjust bar face color to class colors    
    hb = findobj(ax.Children,'Type','bar');
    hb.FaceColor = 'flat';
    for k = 1:size(typevar)
        %assign color to variable bar based on typevar
        hb.CData(k,:) = custom_colormap(types==typevar(k),:);
    end
    cb = colorbar;
    cb.Ticks = (0.5:1:length(types)-0.5)/ntypes;
    if isnumeric(types)
        cb.TickLabels = num2str(types);  %unique index numbers
    else
        cb.TickLabels = types;           %categories
    end
    %add label above colorbar so it does not disappear off side of figure
    cb.Label.String = vardesc;       %add variable description to colorbar
    cb.Label.Rotation = 0; % Set rotation to 0 degrees
    cb.Label.Position = [0.5, 1.05]; % Adjust position to be above the colorbar
    cb.Label.VerticalAlignment = 'bottom'; % Align the label vertically
    cb.Label.HorizontalAlignment = 'left';
end

%%
function isvalid = checkdimensions(x,y)
    %check that the dimensions of the selected data match
    if length(x)==length(y)
        isvalid = true;
    else
        isvalid = false;
    end
    %
    if ~isvalid
        warndlg('Dimensions of selected variables do not match')
    end
end

%%
function [cobj,classrec,datasets,idd] = selectCaseDataset(mobj,promptxt)
    %select case and dataset for use in plot or analysis
    [cobj,classrec] = selectCaseObj(mobj.Cases,[],{'muiTableImport'},promptxt);
    datasets = fields(cobj.Data);
    idd = 1;
    if length(datasets)>1
        idd = listdlg('PromptString','Select table:','ListString',datasets,...
                            'SelectionMode','single','ListSize',[160,200]);
    end
end

%% additional functions here or external
function another_plot(~)
    %dummy function
end

%%
function yet_another_plot(~)
    %dummy function
end

