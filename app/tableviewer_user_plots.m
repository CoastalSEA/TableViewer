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
                scatter_plot(mobj);       %muitoolbox function
            case 'Type plot'
                type_plot(mobj);          %muitoolbox function
            case 'Another plot'
                another_plot(mobj);       %dummy call
            case 'Yet another plot'
                yet_another_plot(mobj);   %dummy call
        end
    end
end

%%
% Default functions can be found in muitoolbox/psfunctions folder
% function scatter_plot(mobj)
% function type_plot(mobj)

%% additional functions here or external
function another_plot(~)
    %dummy function
end

%%
function yet_another_plot(~)
    %dummy function
end

