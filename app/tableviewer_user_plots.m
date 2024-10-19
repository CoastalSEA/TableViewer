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
    promptxt = 'Select X-variable:';    
    indvar = get_variable(mobj,promptxt);
    promptxt = 'Select Y-variable:';    
    depvar = get_variable(mobj,promptxt);
    if isempty(indvar) || isempty(depvar), return; end  
    isvalid = checkdimensions(indvar.data,depvar.data);
    if ~isvalid, return; end

    if strcmp(answer,'3D')
        promptxt = 'Select variable to scale scatter points:';    
        scalevar = get_variable(mobj,promptxt);
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
    legtxt = sprintf('%s(%s)',depvar.name,indvar.name);
    hs = scatter(ax,indvar.data,depvar.data,markersz,'filled','DisplayName',legtxt);
    xlabel(indvar.label)
    if strcmp(indvar.scale,'Log')
        idx = find(mod(ax.XTick(:), 1) == 0);
        ax.XTick = ax.XTick(idx); %remove non integer exponents
        ax.XTickLabel = cellstr(num2str(ax.XTick(:), '10^{%d}'));
    end
    ylabel(depvar.label)
    if strcmp(depvar.scale,'Log')
        idy = find(mod(ax.YTick(:), 1) == 0);
        ax.YTick = ax.YTick(idy);  %remove non integer exponents
        ax.YTickLabel = cellstr(num2str(ax.YTick(:), '10^{%d}'));
    end
    

    legend('Location','best')
    title(sprintf('%s v %s',depvar.desc,indvar.desc))
    if strcmp(answer,'3D')
        hs.MarkerFaceAlpha = 0.5; %transparency
        stxt = sprintf('Circles scaled by %s',scalevar.desc);
        subtitle(stxt)  
    end
end

%%
function type_plot(mobj)
    %bar plot of variable against table rows, with bars shaded to reflect a
    %classification variable (e.g. Type)

    promptxt = 'Select Case to tabulate';
    [cobj,~,datasets,idd] = selectCaseDataset(mobj,promptxt);

    [ax,idx,ids] = userPlot(cobj); %idx sort order of x-variable if a scalarplot
                                   %ids indices of selected sub-set (after sorting)

    %select variable to use for classification
    dst = cobj.Data.(datasets{idd});
    varnames = dst.VariableNames;
    vardesc = dst.VariableDescriptions;
    
    promptxt = 'Select classification variable:';   
    idv = listdlg('PromptString',promptxt,'ListString',vardesc,...
                            'SelectionMode','single','ListSize',[180,300]);
    if isempty(idv), return; end
    typevar = dst.(varnames{idv}); 
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
    cb.Label.String = vardesc{idv};  %add variable description to colorbar
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
        if isempty(idd), return; end
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

