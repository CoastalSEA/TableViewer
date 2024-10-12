function tableviewer_open_manual()
%find the location of the asmita app and open the manual
appname = 'TableViewer';
appinfo = matlab.apputil.getInstalledAppInfo;
idx = find(strcmp({appinfo.name},appname));
fpath = [appinfo(idx(1)).location,[filesep,'doc',filesep,'TableViewer manual.pdf']];
open(fpath)
