function varargout = NaturalImage_RandomNumberGenerator(varargin)
% Last Modified by GUIDE v2.5 15-Nov-2021 16:10:54
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NaturalImage_RandomNumberGenerator_OpeningFcn, ...
                   'gui_OutputFcn',  @NaturalImage_RandomNumberGenerator_OutputFcn, ...
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

function NaturalImage_RandomNumberGenerator_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
global pic_flag;
pic_flag=0;

function varargout = NaturalImage_RandomNumberGenerator_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton_createRandom_Callback(hObject, eventdata, handles)
global pic_flag;
global imgfile;
global leftboundary;
global rightboundary;
img_matrix = imread(imgfile);  
y=img_matrix();
if pic_flag == 0
    set(handles.text_showResult,'String','error');
    warndlg('请添加生成随机数的图像源','Warning','modal');
else
    for i=1 : length(y)
        randomnum =unifrnd (1,length(y));  % 利用系统随机数创建随机索引值 
        temp = y(uint16(randomnum));
        if temp >= leftboundary && temp <= rightboundary
            result=num2str(temp);
            set(handles.text_showResult,'String',result);
        end
        if temp > rightboundary
            result = rem(temp,(rightboundary-leftboundary+1))+leftboundary;
            set(handles.text_showResult,'String',result);
        end
    end
end

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_selectPic_Callback(hObject, eventdata, handles)
global imgfile;
global pic_flag;
[filename,pathname] =uigetfile({'*.jpg';'*.bmp';'*.jpeg';'*.*'},'载入图片');
if isequal(filename,0) || isequal(pathname,0)
    errordlg('没有选中文件','Warning');
else
    imgfile=[pathname,filename];
    progress_bar = waitbar(0,'图片加载中，请稍后...');
    imgdata = dir(imgfile);
    end_time = imgdata.bytes/1000;    % 根据图像文件的字节大小进行进度条显示时长设置
    for i=1 : end_time
        waitbar(i/end_time);
    end
    close(progress_bar);
    set(handles.text_tip,'Visible','off');
    pic_flag = 1;
    img=imread(imgfile); 
    axes(handles.axes1);  
    axis off
    imshow(img);  
end

function edit_selectRightBoundary_Callback(hObject, eventdata, handles)
global rightboundary;
input=str2num(get(hObject,'String'));
rightboundary=input;

function edit_selectRightBoundary_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_selectLeftBoundary_Callback(hObject, eventdata, handles)
global leftboundary;
input=str2num(get(hObject,'String'));
leftboundary=input;

function edit_selectLeftBoundary_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_confirmRange_Callback(hObject, eventdata, handles)
global leftboundary;
global rightboundary;

if (isempty(leftboundary)) || (isempty(rightboundary)) || (isempty(leftboundary)) && (isempty(rightboundary))
    set(handles.pushbutton_createRandom,'enable','off');
    warndlg('请给出随机数范围的左、右边界值','Warning','modal'); 
else
    if leftboundary < 0 || rightboundary > 255 || leftboundary >= rightboundary
        set(handles.text_showResult,'String','error');
        set(handles.pushbutton_createRandom,'enable','off');
        warndlg('请输入正确的范围值（随机数最大生成范围为0-255）','Warning','modal'); 
    else
        set(handles.pushbutton_createRandom,'enable','on');
    end
end