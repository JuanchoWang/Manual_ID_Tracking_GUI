function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 07-Feb-2018 14:13:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

addpath('\\hi2crsmb\external\wan4hi\Code\ID_Tracking_GUI_v2.1\src');
I = imread('bosch-logo-Kopie.jpg');
axes(handles.axes1);
imshow(I);
set(handles.framenum,'String','No frame now');

handles.pictag = false;
handles.datentag = false;
handles.posetag = false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Undo_Callback(hObject, eventdata, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.datentag == false
    % set(handles.info,'String','Please read data file first.');
    return
end
if handles.rollbacktag == true
    handles.zt = handles.objd;
    id_all = [];
    for i = 2:length(handles.zt)    
        id_all = [id_all; handles.zt{1,i}.ID];
    end
    set(handles.ResIDMenu,'String',id_all);
    handles.rollbacktag = false;
    all_list = [handles.zt{1,:}];
    id_all = [all_list(:).ID]';
    set(handles.ResIDMenu,'Value',1);
    set(handles.OriIDMenu,'Value',1);
    handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
    set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
    set(handles.ResIDMenu,'String',id_all);
    handles.rollbacktag = true;
    if handles.posetag == true
        ue_index = get(handles.OriIDMenu,'Value');
        KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
    end
    guidata(hObject, handles);
else
    % set(handles.info,'String','You do not have to or cannot rollback any more.');
end

% --------------------------------------------------------------------
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function browser_image_Callback(hObject, eventdata, handles)
% hObject    handle to browser_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[picname picpath] = uigetfile({'*.png;*.jpg;*.jpeg'},'Please select one of your pictures','.');
if isequal(picname,0)
    % if user cancel selection, nothing happens
    return
end
I = imread(strcat(picpath,picname));
handles.pres = size(I);
handles.pres = handles.pres(2:-1:1);
set(handles.axes1,'Position',[30 27 handles.pres]);
axes(handles.axes1);

handles.pname = picname;
handles.ppath = picpath;
pt_pos = strfind(handles.pname,'.');
handles.ptype = handles.pname(pt_pos(end):end);
fnum_pos = regexp(handles.pname, strcat('\d+',handles.ptype));
handles.fnum = str2double(handles.pname(fnum_pos:pt_pos-1));

set(handles.framenum,'String',strcat(int2str(handles.fnum),' frame'));
if handles.datentag == true
    ue_index = get(handles.OriIDMenu,'Value');
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
    ori_ID = str2double(oriID_cell{1,1});
    handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
    newID_cell = regexp({handles.ue(:,1).ID},'\d+','match');
    ID_array = [newID_cell{1,:}];
    [booln, val_index] = ismember(int2str(ori_ID), ID_array);
    if booln == 1
        set(handles.OriIDMenu,'Value',val_index);        
    else
        set(handles.OriIDMenu,'Value',1);
    end
    set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
    if handles.posetag == true
        ue_index = get(handles.OriIDMenu,'Value');
        KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
    end
else
    imshow(I)
end

handles.pictag = true;
guidata(hObject, handles);

% --------------------------------------------------------------------
function CVMLre_Callback(hObject, eventdata, handles)
% hObject    handle to CVMLre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.pictag == false
    %set(handles.info,'String','Please select your pictures first.');
    return
end
[cvmlname cvmlpath] = uigetfile({'*.cvml'},'Please select your CVML-File','.');
if isequal(cvmlname,0)
    %set(handles.info,'String','User selected Cancel.');
    return
end
wb = waitbar(0.5,'Please wait...');
[obj res] = readCVMLFileAdvanced(cvmlpath,cvmlname);
close(wb);

%set(handles.info,'String','CVML-File has been imported');
handles.zt = obj.withID;
empty_idx = cellfun('isempty',handles.zt);
handles.zt(empty_idx) = [];
handles.zt = {[] handles.zt{:}};
handles.objd = handles.zt;
handles.datentag = true;
handles.rollbacktag = false;
% handles.splittime = 0;

handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'Value',1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end

all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.ResIDMenu,'String',id_all);

guidata(hObject, handles);

% --------------------------------------------------------------------
function JSONre_Callback(hObject, eventdata, handles)
% hObject    handle to JSONre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.pictag == false
    %set(handles.info,'String','Please select your pictures first.');
    return
end
PicDir = dir(strcat(handles.ppath,'*',handles.ptype));
pt_pos = strfind(PicDir(1).name,handles.ptype);
fnum_pos = regexp(PicDir(1).name, strcat('\d+',handles.ptype));
fa_num = str2double(PicDir(1).name(fnum_pos:pt_pos-1));

[jsonname jsonpath] = uigetfile({'*.json'},'Please select one of your .JSON-file','.');
if isequal(jsonname,0)
    %set(handles.info,'String','User selected Cancel.');
    return
end
wb = waitbar(0.5,'Please wait...');
erge = readJSONFile(fa_num,strcat(jsonpath,jsonname));
close(wb);

handles.zt = erge;
handles.objd = erge;
handles.datentag = true;
handles.rollbacktag = false;
% handles.splittime = 0;

handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'Value',1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end

all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.ResIDMenu,'String',id_all);

guidata(hObject, handles);

% --------------------------------------------------------------------
function MATre_Callback(hObject, eventdata, handles)
% hObject    handle to MATre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.pictag == false
    %set(handles.info,'String','Please select your pictures first.');
    return
end
[matname matpath] = uigetfile({'*.mat'},'Please select one of your .MAT-file');
if isequal(matname,0)
    %set(handles.info,'String','User selected Cancel.');
    return
end
load(strcat(matpath,matname));
%set(handles.info,'String','.MAT-File has been imported');
handles.zt = erge;
handles.objd = erge;
handles.datentag = true;
handles.rollbacktag = false;
% handles.splittime = 0;

handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'Value',1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end

all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.ResIDMenu,'String',id_all);

guidata(hObject, handles);

% --------------------------------------------------------------------
function ExCVML_Callback(hObject, eventdata, handles)
% hObject    handle to ExCVML (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.datentag == false
    %set(handles.info,'String','You have not opened any data file by far.');
    return
end

PicDir = dir(strcat(handles.ppath,'*',handles.ptype));
f_name = PicDir(1).name;
pt_pos = strfind(f_name,handles.ptype);
fnum_pos = regexp(f_name, strcat('\d+',handles.ptype));
fa_num = str2double(f_name(fnum_pos:pt_pos-1));
f_name = PicDir(end).name;
pt_pos = strfind(f_name,handles.ptype);
fnum_pos = regexp(f_name, strcat('\d+',handles.ptype));
fe_num = str2double(f_name(fnum_pos:pt_pos-1));

t_path = uigetdir('.','Please choose a directory');
if t_path == 0
    % if user cancel selection, nothing happens
    return
end
pt_pos = strfind(handles.ppath,'\');
file_name = handles.ppath((pt_pos(end-1)+1):end-1);
file_name = strcat(handles.ppath((pt_pos(end-2)+1):(pt_pos(end-1)-1)),'_',file_name);
file_name = strcat(file_name,'.cvml');

frate = 25;%%%%%%%%%%%%%%%%%%%%%%%%%%Frame rate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% shift all the id to make the minimal id is 1
all_list = [handles.zt{:}];
minID = min([all_list(:).ID]);
for zt_idx = 2:length(handles.zt)
    handles.zt{zt_idx}.ID = handles.zt{zt_idx}.ID - minID + 1;
end

ExportCVMLFile(handles.zt,handles.pres,frate,fa_num,fe_num,t_path,file_name);

% --------------------------------------------------------------------
function ExMat_Callback(hObject, eventdata, handles)
% hObject    handle to ExMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.datentag == false
    %set(handles.info,'String','You have not opened any data file by far.');
    return
end
erge = handles.zt;
uisave('erge','Annotated Dataset')


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

if handles.pictag == false
   return
end
PicDir = dir(strcat(handles.ppath,'*',handles.ptype));
[bool_pic pic_idx] = ismember(handles.pname, {PicDir.name});

if eventdata.VerticalScrollCount > 0    
    pic_idx = pic_idx + 1;
else if eventdata.VerticalScrollCount < 0 
    pic_idx = pic_idx - 1;
    end
end

try
    I = imread(strcat(handles.ppath,PicDir(pic_idx).name));
catch ME
    % if user is watching the first/last picture and he tries to scroll, nothing happens
    return
end

handles.pname = PicDir(pic_idx).name;
pt_pos = strfind(handles.pname,handles.ptype);
fnum_pos = regexp(handles.pname, strcat('\d+',handles.ptype));
handles.fnum = str2double(handles.pname(fnum_pos:pt_pos-1));
set(handles.framenum,'String',strcat(int2str(handles.fnum),' frame'));

if handles.datentag == true
    ue_index = get(handles.OriIDMenu,'Value');
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
    ori_ID = str2double(oriID_cell{1,1});
    handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
    newID_cell = regexp({handles.ue(:,1).ID},'\d+','match');
    ID_array = [newID_cell{1,:}];
    [booln, val_index] = ismember(int2str(ori_ID), ID_array);
    if booln == 1
        set(handles.OriIDMenu,'Value',val_index);        
    else
        set(handles.OriIDMenu,'Value',1);
    end
    set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
    if handles.posetag == true
        ue_index = get(handles.OriIDMenu,'Value');
        KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
    end
else
    imshow(I)
end
guidata(hObject, handles);


% --- Executes on selection change in OriIDMenu.
function OriIDMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OriIDMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OriIDMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OriIDMenu


% --- Executes during object creation, after setting all properties.
function OriIDMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OriIDMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KF_toggle.
function KF_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to KF_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ue_index = get(handles.OriIDMenu,'Value');
if handles.datentag == true && handles.pictag == true
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
    ori_ID = str2double(oriID_cell{1,1});
    
    if handles.fnum ~= handles.ue(ue_index).frames(1)
        KFnum = handles.ue(ue_index).frames(1);
    else
        KFnum = handles.ue(ue_index).frames(end);
    end
    % subfix = subfixmodi(KFnum);
    handles.fnum = KFnum;
    set(handles.framenum,'String',strcat(int2str(handles.fnum),' frame'));
    fnum_pos = regexp(handles.pname, strcat('[1-9]\d+',handles.ptype)); % regular expression:\d -- [1-9]
    %%
    if KFnum < 10
        handles.pname = strcat('00',int2str(KFnum),handles.ptype);
    else
        if KFnum < 100
            handles.pname = strcat('0',int2str(KFnum),handles.ptype);
        else
            handles.pname = strcat(int2str(KFnum),handles.ptype);
        end
    end
    %%
    %handles.pname = strcat(handles.pname(1:fnum_pos-1),int2str(KFnum),handles.ptype);
    
    handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
    newID_cell = regexp({handles.ue(:,1).ID},'\d+','match');
    ID_array = [newID_cell{1,:}];
    [booln, val_index] = ismember(int2str(ori_ID), ID_array);
    set(handles.OriIDMenu,'Value',val_index);  
    set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
    if handles.posetag == true
        ue_index = get(handles.OriIDMenu,'Value');
        KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
    end
end
guidata(hObject, handles);


% --- Executes on button press in Pose_toggle.
function Pose_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to Pose_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.pictag == false || handles.datentag == false
    return
end

if handles.posetag == false
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
    handles.posetag = true;
else
    handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
    handles.posetag = false;
end
guidata(hObject, handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in ResIDMenu.
function ResIDMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ResIDMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ResIDMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ResIDMenu


% --- Executes during object creation, after setting all properties.
function ResIDMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResIDMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_restKF.
function view_restKF_Callback(hObject, eventdata, handles)
% hObject    handle to view_restKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.datentag == false
   return
end
ue_index = get(handles.OriIDMenu,'Value');
oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
ori_ID = str2double(oriID_cell{1,1});

kf_index = get(handles.ResIDMenu,'Value');
handles.fnum = handles.zt{1, kf_index+1}.frames(1);

set(handles.framenum,'String',strcat(int2str(handles.fnum),' frame'));
fnum_pos = regexp(handles.pname, strcat('[1-9]\d+',handles.ptype));
%%
if handles.fnum < 10
    handles.pname = strcat('00',int2str(handles.fnum),handles.ptype);
else
    if handles.fnum < 100
        handles.pname = strcat('0',int2str(handles.fnum),handles.ptype);
    else
        handles.pname = strcat(int2str(handles.fnum),handles.ptype);
    end
end
%%
%handles.pname = strcat(handles.pname(1:fnum_pos-1),int2str(handles.fnum),handles.ptype);

handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
newID_cell = regexp({handles.ue(:,1).ID},'\d+','match');
ID_array = [newID_cell{1,:}];
[booln, val_index] = ismember(int2str(ori_ID), ID_array);
if booln == 1
    set(handles.OriIDMenu,'Value',val_index);        
else
    set(handles.OriIDMenu,'Value',1);
end
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end
guidata(hObject, handles);


% --- Executes on button press in Merge_Timeline.
function Merge_Timeline_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_Timeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ue_index = get(handles.OriIDMenu,'Value');
try
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
catch ME
    % set(handles.info,'String','You should choose the person of interest first.');
    return
end

if handles.rollbacktag == true
    handles.objd = handles.zt;
end

ori_ID = str2double(oriID_cell{1,1});

zt_index = get(handles.ResIDMenu,'Value');
zt_cell = get(handles.ResIDMenu,'String');
new_ID = str2double(zt_cell(zt_index,:));

all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
[booltemp ori_index] = ismember(ori_ID, id_all);
[booltemp new_index] = ismember(new_ID, id_all);
ori_index = ori_index + 1;
new_index = new_index + 1;
% [ori_index, new_index] = searchID(handles.zt, ori_ID, new_ID);

com_frame = intersect(handles.zt{1,new_index}.frames,handles.zt{1,ori_index}.frames);
if isempty(com_frame)
    sortMatrix = [handles.zt{1,new_index}.frames, handles.zt{1,new_index}.KP, handles.zt{1,new_index}.BB;...
        handles.zt{1,ori_index}.frames, handles.zt{1,ori_index}.KP, handles.zt{1,ori_index}.BB];
    sortMatrix = sortrows(sortMatrix);
    handles.zt{1,new_index}.frames = sortMatrix(:,1);
    handles.zt{1,new_index}.KP = sortMatrix(:,2:55);
    handles.zt{1,new_index}.BB = sortMatrix(:,56:59);
    handles.zt{1,new_index}.bool = repmat(-1,length(handles.zt{1,new_index}.frames),1);
    handles.zt(ori_index) = [];
else 
    sortMatrix = [handles.zt{1,new_index}.frames, handles.zt{1,new_index}.KP, handles.zt{1,new_index}.BB];
    for i = 1:length(handles.zt{1,ori_index}.frames)
        fnum_loop = handles.zt{1,ori_index}.frames(i);
        boolcomf = ismember(fnum_loop,com_frame);
        if boolcomf == 0            
            sortMatrix = [sortMatrix; fnum_loop, handles.zt{1,ori_index}.KP(i,:),...
                handles.zt{1,ori_index}.BB(i,:)];
        else
            [boolnew new_findex] = ismember(fnum_loop, sortMatrix(:,1));
            %change KP
            for j = 3:3:54
                if sortMatrix(new_findex,j) == -1 && handles.zt{1,ori_index}.KP(i,j-1) ~= -1
                    %when conflicts on same KP happen, the code above can
                    %just keep the KP from new_ID
                    sortMatrix(new_findex,j) = handles.zt{1,ori_index}.KP(i,j-1);
                    sortMatrix(new_findex,j+1) = handles.zt{1,ori_index}.KP(i,j);
                end
            end
            %change BB
            BB_des = zeros(1,4);
            BB_des(1) = min(sortMatrix(new_findex,56), handles.zt{1,ori_index}.BB(i,1));
            BB_des(2) = min(sortMatrix(new_findex,57), handles.zt{1,ori_index}.BB(i,2));
            BB_des(3) = max(sortMatrix(new_findex,56) + sortMatrix(new_findex,58), ...
                handles.zt{1,ori_index}.BB(i,1) + handles.zt{1,ori_index}.BB(i,3));
            BB_des(4) = max(sortMatrix(new_findex,57) + sortMatrix(new_findex,59), ...
                handles.zt{1,ori_index}.BB(i,2) + handles.zt{1,ori_index}.BB(i,4));
            BB_des(3) = BB_des(3) - BB_des(1);
            BB_des(4) = BB_des(4) - BB_des(2);
            sortMatrix(new_findex,56:59) = BB_des;
        end
        sortMatrix = sortrows(sortMatrix);

    end
    handles.zt{1,new_index}.frames = sortMatrix(:,1);
    handles.zt{1,new_index}.KP = sortMatrix(:,2:55);
    handles.zt{1,new_index}.BB = sortMatrix(:,56:59);
    handles.zt{1,new_index}.bool = repmat(-1,length(handles.zt{1,new_index}.frames),1);
    handles.zt(ori_index) = [];
end

% best with functions
% id_all = [];
% for i = 2:length(handles.zt)
%     id_all = [id_all; handles.zt{1,i}.ID];
% end
all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.OriIDMenu,'Value',1);

handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
set(handles.ResIDMenu,'String',id_all);
handles.rollbacktag = true;
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end
guidata(hObject, handles);

% --- Executes on button press in delete_ID.
function delete_ID_Callback(hObject, eventdata, handles)
% hObject    handle to delete_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ue_index = get(handles.OriIDMenu,'Value');
try
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
catch ME
    % set(handles.info,'String','You should choose the person of interest first.');
    return
end

if handles.rollbacktag == true
    handles.objd = handles.zt;
end

ori_ID = str2double(oriID_cell{1,1});
all_list = [handles.zt{:}];
[bools ori_index] = ismember(ori_ID, [all_list(:).ID]);
ori_index = ori_index + 1;
handles.zt(ori_index) = [];

all_list = [handles.zt{:}];
id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.OriIDMenu,'Value',1);
handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
set(handles.ResIDMenu,'String',id_all);
handles.rollbacktag = true;
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end
guidata(hObject, handles);

% --- Executes on button press in split.
function split_Callback(hObject, eventdata, handles)
% hObject    handle to split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ue_index = get(handles.OriIDMenu,'Value');
try
    oriID_cell = regexp(handles.ue(ue_index).ID,'\d+','match');
catch ME
    % set(handles.info,'String','You should choose the person of interest first.');
    return
end

if handles.rollbacktag == true
    handles.objd = handles.zt;
end
%handles.splittime = handles.splittime + 1;
ori_ID = str2double(oriID_cell{1,1});

all_list = [handles.zt{:}];
new_ID = max([all_list(:).ID]) + 1;% 1000 - handles.splittime;
new_index = length(handles.zt(1,:)) + 1;
handles.zt{1,new_index}.ID = new_ID;
valid_array = handles.ue(ue_index).frames >= handles.fnum; % extract information only in valid frames
handles.zt{1,new_index}.frames = handles.ue(ue_index).frames(valid_array);
handles.zt{1,new_index}.KP = handles.ue(ue_index).KP(valid_array,:);
handles.zt{1,new_index}.BB = handles.ue(ue_index).BB(valid_array,:);
handles.zt{1,new_index}.KP_names = handles.ue(ue_index).KP_names;
handles.zt{1,new_index}.bool_names = handles.ue(ue_index).bool_names;
handles.zt{1,new_index}.bool = handles.ue(ue_index).bool(valid_array);

all_list = [handles.zt{1,:}];
[bools ori_index] = ismember(ori_ID, [all_list(:).ID]);
ori_index = ori_index + 1;
handles.zt{1,ori_index}.frames(valid_array) = [];
handles.zt{1,ori_index}.KP(valid_array,:) = [];
handles.zt{1,ori_index}.BB(valid_array,:) = [];
handles.zt{1,ori_index}.bool(valid_array,:) = [];
if isempty(handles.zt{1,ori_index}.frames)
    %set(handles.info,'String','You cannot split from the first keyframe.');
    return
end

id_all = [all_list(:).ID]';
set(handles.ResIDMenu,'Value',1);
set(handles.OriIDMenu,'Value',1);
handles.ue = BBshow(handles.zt,handles.fnum,handles.pname,handles.ppath,handles.axes1);
set(handles.OriIDMenu,'String',{handles.ue(:,1).ID});
set(handles.ResIDMenu,'String',id_all);
handles.rollbacktag = true;
if handles.posetag == true
    ue_index = get(handles.OriIDMenu,'Value');
    KPshow(handles.ue(ue_index),handles.fnum,handles.axes1);
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_text_Callback(hObject, eventdata, handles)
% hObject    handle to Help_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help_dlg = dialog('Position',[300 300 1200 800],'Name','Help','Resize','on');

txt_content = {'Welcome to use ID tracking tool ver. 2.1 developed by CR-AEC5.';...
                sprintf('\n');...
                'With this tool you can manually correct the IDs for each person, who appears in a sequence of pictures';...
                'Before you start to correct any ID, we strongly suggest you to read this guide first.';...
                sprintf('\n');...
                '---Menu---';...
                sprintf('\n');...
                'From the File-Menu you can import your picture file. We now support .png/.jpg/.jpeg files.';...
                sprintf('\n');...
                'There you can also import your data file with original IDs. We support .cvml/.json/.mat files.';...
                'To be specific, the imported .cvml file had better be output of one automatic annotator.';...
                'So the most of objects have already the correct IDs between consecutive frames.';...
                'At least your .cvml file should include informations of ID, keypoints and bounding box.';...
                'You should have 18 keypoints and their tags have a order in alphabet. The position of bounding box should be described by its center';...
                'Therefor we suggest you should execute the automatic annotating first rather than importing the converted cvml files from caffe-rtpose.bin directly. '
                sprintf('\n');...
                'You can also import the .json files, which are output of the Matlab-API of caffe model with pose estimation.';...
                'If you do so, you can correct the IDs directly. The .json files only include 17 keypoints and the keypoints of neck is obtained as the middle point of both shoulders.';...
                'But we suggest you export the data to .cvml file once you finish importing, so that you can execute automatic annotating first.';...
                sprintf('\n');...
                'You can import and export .mat file. This is a good choice as a intermediate result. You can always read and save .mat files very fast and make a pause.';...
                sprintf('\n');...
                'At last you migth only export .cvml file as your final result. The information of image resolution depends on the size of imported pictures';...
                'But the framerate could only be set in the source code for now. We will improve it in the next version.';...
                sprintf('\n');...
                'From Edit-Menu you can now only undo one step if you get some wrong results with 3 main edit buttons.';...
                'If you consecutively make 2 steps wrong, you can still only undo once.';...
                sprintf('\n');...
                ''
                };

txt = uicontrol('Parent',help_dlg,...
                'Style','text',...
                'Position',[20 80 1150 700],...
                'FontSize',10,...
                'String',txt_content);
            
