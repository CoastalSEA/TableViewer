function tableviewer_user_tools(mobj)                       
%
%-------function help------------------------------------------------------
% NAME
%   tableviewer_user_tools.m
% PURPOSE
%   user functions to do additional analysis on data loaded in TableViewer
% USAGE
%   tableviewer_user_tools(mobj)
% INPUTS
%   mobj - ModelUI instance
% OUTPUT
%   user defined analysis outputs
% NOTES
%    called from TableViewer App.
% SEE ALSO
%   TableViewer and tableviewer_user_plots
%
% Author: Ian Townend
% CoastalSEA (c) Oct 2024
%--------------------------------------------------------------------------
%     
    listxt = {'Table figure','Another analysis','Yet another analysis'};  %<< edit list, cases and function calls below as required

    ok = 1;
    while ok>0
        selection = listdlg("ListString",listxt,"PromptString",...
                            'Select option:','SelectionMode','single',...
                            'ListSize',[150,200],'Name','tvtools');
        if isempty(selection), ok = 0; continue; end

        switch listxt{selection}
            case 'Table figure'
                get_dataTable(mobj);
            case 'Another analysis'
                another_analysis(mobj)
            case 'Yet anoher analysis'
                yet_another_analysis(mobj);
        end
    end
end

%%
function get_dataTable(mobj)
    %generate table figure of selected data set
    promptxt = 'Select Case to tabulate';
    [cobj,~,datasets,idd] = selectCaseDataset(mobj,promptxt);
    dst = cobj.Data.(datasets{idd});
    titletxt = sprintf('Data for %s(%s)',dst.Description,datasets{idd}); 

    %generate table
    table_figure(dst,titletxt)
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
function another_analysis(~)
    %dummy function
end

%%
function yet_another_analysis(~)
    %dummy function
end