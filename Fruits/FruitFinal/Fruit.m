function varargout = Fruit(varargin)
% FRUIT MATLAB code for Fruit.fig
%      FRUIT, by itself, creates a new FRUIT or raises the existing
%      singleton*.
%
%      H = FRUIT returns the handle to a new FRUIT or the handle to
%      the existing singleton*.
%
%      FRUIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRUIT.M with the given input arguments.
%
%      FRUIT('Property','Value',...) creates a new FRUIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fruit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fruit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fruit

% Last Modified by GUIDE v2.5 15-Dec-2017 21:56:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fruit_OpeningFcn, ...
                   'gui_OutputFcn',  @Fruit_OutputFcn, ...
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


% --- Executes just before Fruit is made visible.
function Fruit_OpeningFcn(hObject, eventdata, handles, varargin)%载入界面
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fruit (see VARARGIN)

% Choose default command line output for Fruit
handles.output = hObject;
im=imread('timg.jpg');%界面背景
axes(handles.axes4)
imshow(im)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fruit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Fruit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I 
global BW
global area_BW
global centroid_BW
global perimeter_BW
global e_BW
global majorlength_BW
global minorlength_BW
global dotlength_BW
global eccentricity_BW
global orien_BW
global eulernum_BW
global diameter_BW
global Label
global num

[filename,pathname]=uigetfile({'*.jpg';' *.jpeg'; '*.bmp'},'选择图片');
if isequal(filename,0)
    disp('user seleted canceled');
else
    str=[pathname filename];
    I=imread(str);
    axes(handles.axes1);
    imshow(I)
end
%第一次处理
%I2=rgb2gray(I);
%BW=(I2==255);
%imshow(BW)
%se=strel('disk',5);
%BW=~imopen(~BW,se);
%第二次处理
I2=rgb2gray(I); 
I3=imbinarize(I2,0.9); 
SE=strel('rectangle',[40 30]);  % 结构定义 
BW=imopen(I3,SE);            % 开运算 
%将不同的图形进行分别标记，num表示连接的图形对象的个数
[Label,num] = bwlabel(~BW,8);

%计算目标物的形状数：面积，中心坐标，周长，偏心率，长轴，短轴，角度，欧拉数，离心率，平均色度
s=regionprops(~BW,'all');
area_BW=cat(1,s.Area);%面积   
centroid_BW=cat(1,s.Centroid);%中心坐标
perimeter_BW=cat(1,s.Perimeter);%周长
e_BW=4.*pi.*area_BW./(perimeter_BW.^2);%偏心率 圆度
majorlength_BW=cat(1,s.MajorAxisLength);%长轴
minorlength_BW=cat(1,s.MinorAxisLength);%短轴
dotlength_BW=majorlength_BW./minorlength_BW;
eccentricity_BW=cat(1,s.Eccentricity);%离心率
orien_BW=cat(1,s.Orientation);%角度
eulernum_BW=cat(1,s.EulerNumber);%欧拉数
diameter_BW=cat(1,s.EquivDiameter);%与区域具有相同面积的圆的直径

function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get(handles.popupmenu1,'value');
    %fruit_type=sprintf('%d',get(handles.popupmenu1,'value'));
global I 
global area_BW
global centroid_BW
global perimeter_BW
global e_BW
global majorlength_BW
global minorlength_BW
global dotlength_BW
global eccentricity_BW
global orien_BW
global eulernum_BW
global diameter_BW
global Label
global num
character_fruit=NaN;
%  根据偏心率，长轴/短轴，离心率可以分辨出不同水果(特征提取不够，希望能有更多的量化条件，能改进)
if num ==1
     if (dotlength_BW(1) < 1.1)&&(0.74<=e_BW(1))&&(e_BW(1)<=0.92)&&(eccentricity_BW(1)<0.4)
         character_fruit=1;
         set(handles.edit11,'string','图中水果为苹果');
     end
      if (2.18<dotlength_BW(1))&&(dotlength_BW(1) < 3.28)&&(0.36<=e_BW(1))&&(e_BW(1)<=0.55)&&(eccentricity_BW(1)>0.89)
         character_fruit=1;
         set(handles.edit11,'string','图中水果为香蕉');
     end
     if (dotlength_BW(1) > 2)&&(dotlength_BW(1)<2.7)&&(0.2<e_BW(1))&&(e_BW(1)<0.4)&&(eccentricity_BW(1)>0.87)
         character_fruit=1;
         set(handles.edit11,'string','图中水果为菠萝');
     end
     if (1.1<dotlength_BW(1))&&(dotlength_BW(1) < 1.39)&&(0.6<=e_BW(1))&&(e_BW(1)<=0.81)&&(0.58<eccentricity_BW(1))&&(eccentricity_BW(1)<0.71)
         character_fruit=1;
         set(handles.edit11,'string','图中水果为梨');
     end
     if (dotlength_BW(1) < 1.1)&&(0.92<e_BW(1))&&(eccentricity_BW(1)<=0.35)
         character_fruit=1;
         set(handles.edit11,'string','图中水果为桃子');
     end
else
    switch get(handles.popupmenu1,'value')
        case 1
            for j=1:num
                if dotlength_BW(j)==max(dotlength_BW)
                    character_fruit=j;
                    set(handles.edit11,'string','如图');
                end
            end
        case 2
            for j=1:num
                if dotlength_BW(j)==min(dotlength_BW)
                    character_fruit=j;
                    set(handles.edit11,'string','如图');
                end
            end
        case 3
            for j=1:num
                if dotlength_BW(j)<max(dotlength_BW)&&dotlength_BW(j)>median(dotlength_BW)
                    character_fruit=j;
                    set(handles.edit11,'string','如图');
                end
            end
        case 4
            for j=1:num
                if e_BW(j)==max(e_BW)
                    character_fruit=j;
                    set(handles.edit11,'string','如图');
                end
            end
        case 5
            for j=1:num
                if dotlength_BW(j)<median(dotlength_BW)&&dotlength_BW(j)>min(dotlength_BW)
                    character_fruit=j;
                    set(handles.edit11,'string','如图');
                end
            end  
    end
end

if((~isnan(character_fruit)))
    set(handles.edit1,'string',area_BW(character_fruit));
    set(handles.edit2,'string',perimeter_BW(character_fruit));
    set(handles.edit3,'string',orien_BW(character_fruit));
    set(handles.edit4,'string',eulernum_BW(character_fruit));
    set(handles.edit5,'string',diameter_BW(character_fruit));
    set(handles.edit6,'string',majorlength_BW(character_fruit));
    set(handles.edit7,'string',minorlength_BW(character_fruit));
    set(handles.edit8,'string',e_BW(character_fruit));
    set(handles.edit9,'string',centroid_BW(character_fruit,1));
    set(handles.edit10,'string',centroid_BW(character_fruit,2));
    set(handles.edit12,'string',dotlength_BW(character_fruit));
    set(handles.edit13,'string',eccentricity_BW(character_fruit));
else
    set(handles.edit1,'string','');
    set(handles.edit2,'string','');
    set(handles.edit3,'string','');
    set(handles.edit4,'string','');
    set(handles.edit5,'string','');
    set(handles.edit6,'string','');
    set(handles.edit7,'string','');
    set(handles.edit8,'string','');
    set(handles.edit9,'string','');
    set(handles.edit10,'string','');
    set(handles.edit11,'string','无法识别');
    set(handles.edit12,'string','');
    set(handles.edit13,'string','');
end


FilledLabel = imfill(Label,'holes');  %填充打过标记的边界线中间围成的图形区域
HSV = rgb2hsv(I);   %转换为HSV，为后面的颜色元素的提取做准备
[row,col] = size(FilledLabel);
fruit_HSV=HSV;
if(~isnan(character_fruit))
for j = 1 : row
	for k = 1 : col
        if(FilledLabel(j,k) ~=character_fruit(:))
             fruit_HSV(j,k,3)=0;
        end
	end
            
end


%变换生成最终的结果图像，图像中显示的结果即对应分类器中指定的类别
fruit_matrix = hsv2rgb(fruit_HSV);   %转换为RGB彩图，彩图中已经滤去了其余物体，只剩下当前目标物
axes(handles.axes2);
imshow(fruit_matrix);
end

function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global area_BW
global centroid_BW
global perimeter_BW
global e_BW
global majorlength_BW
global minorlength_BW
global dotlength_BW
global eccentricity_BW
global orien_BW
global eulernum_BW
global diameter_BW
character_fruit=1;

set(handles.edit1,'string',area_BW(character_fruit));
    set(handles.edit2,'string',perimeter_BW(character_fruit));
    set(handles.edit3,'string',orien_BW(character_fruit));
    set(handles.edit4,'string',eulernum_BW(character_fruit));
    set(handles.edit5,'string',diameter_BW(character_fruit));
    set(handles.edit6,'string',majorlength_BW(character_fruit));
    set(handles.edit7,'string',minorlength_BW(character_fruit));
    set(handles.edit8,'string',e_BW(character_fruit));
    set(handles.edit9,'string',centroid_BW(character_fruit,1));
    set(handles.edit10,'string',centroid_BW(character_fruit,2));
    set(handles.edit11,'string','此时仅为计算数据');
    set(handles.edit12,'string',dotlength_BW(character_fruit));
    set(handles.edit13,'string',eccentricity_BW(character_fruit));


function popupmenu1_Callback(hObject, eventdata, handles)%回传下拉列表选中项的值
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
% --- Executes on selection change in popupmenu1.
function popupmenu1_CreateFcn(hObject, eventdata, handles)%下拉控件
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
