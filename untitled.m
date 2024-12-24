function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 24-Dec-2024 10:42:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
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
% 打开文件选择对话框，允许选择 .jpg 和 .jpeg 格式的图像
[file, path] = uigetfile({'*.jpg;*.jpeg', 'JPEG Files (*.jpg, *.jpeg)'});
if isequal(file, 0)
    return; % 如果用户取消选择，直接返回
end
    
    % 组合文件路径
    image = fullfile(path,file);
    
    % 读取图像并调整大小
    I = imresize(imread(image), [224,224]);
    
    % 显示图像在axes1中
    axes(handles.axes1);
    imshow(I);
    
    % 将图像数据存储在handles结构体中
    handles.imageData = I;
    handles.imageData1 = I;
    handles.imageData2 = I;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'imageData')
 % 加载训练好的模型参数
    load('trainedNet.mat');
    tic;
    % 使用模型分类
    [label, scores] = classify(net, handles.imageData);
    accuracy = string(round(max(scores) * 100)) + "%";
    toc;

    % 显示分类结果
    name = readcell('biaoqian.xlsx');
    % 从 Excel 文件中获取中药材的相关信息
    species = name{label, 1};               % 种类
%     intro = name{label, 2};                 % 简介
%     medicinal_value = name{label, 3};       % 药用价值和功效
%     preservation_method = name{label, 4};   % 保存方式方法
%     interactions = name{label, 5};          % 药物相互作用
    
        % 在GUI中显示识别结果
        set(handles.edit19, 'String', species);
%         set(handles.edit18, 'String', accuracy);

%         set(handles.text31, 'String', preservation_method);
%         set(handles.text11, 'String', intro);
%         set(handles.text29, 'String', medicinal_value);
%         set(handles.text33, 'String', interactions);
%     
        
    else
        errordlg('请先选择一张图像。', '错误');
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否已经是灰度图
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
        
        % 将灰度图像显示在axes2中
        axes(handles.axes2);
        imshow(grayImage);
        
        % 将灰度图保存到handles结构中
        handles.grayImage = grayImage;
        guidata(hObject, handles);
    else
        % 如果已经是灰度图像，直接显示
        axes(handles.axes2);
        imshow(img);
        handles.grayImage = img;
        guidata(hObject, handles);
    end
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果图像已经是灰度图，直接使用
        grayImage = img;
    end

    % 执行二值化操作，使用自适应阈值
    binaryImage = imbinarize(grayImage);
    
    % 将二值化后的图像显示在axes2中
    axes(handles.axes2);
    imshow(binaryImage);
    
    % 将二值化图像保存到handles结构中
    handles.binaryImage = binaryImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查是否存在图像数据
if isfield(handles, 'imageData1')
    % 获取加载的图像
    img = handles.imageData1;

    % 检查是否是彩色图像
    if size(img, 3) == 3
        % 分离RGB三通道
        R = img(:,:,1);  % Red通道
        G = img(:,:,2);  % Green通道
        B = img(:,:,3);  % Blue通道
        
        % 对每个通道进行直方图均衡化
        R_eq = histeq(R);
        G_eq = histeq(G);
        B_eq = histeq(B);
        
        % 合并处理后的RGB通道
        enhancedImage = cat(3, R_eq, G_eq, B_eq);
    else
        % 如果是灰度图像，直接使用直方图均衡化
        enhancedImage = histeq(img);
    end

    % 显示增强后的彩色图像在 axes2 中
    axes(handles.axes2);
    imshow(enhancedImage);
    
    % 将增强后的图像保存到 handles 结构中
    handles.enhancedImage = enhancedImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误提示
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查是否存在图像数据
if isfield(handles, 'imageData1')
    % 获取加载的图像
    img = handles.imageData1;

    % 检查是否为彩色图像
    if size(img, 3) == 3
        % 分离RGB三通道
        R = img(:,:,1);  % Red通道
        G = img(:,:,2);  % Green通道
        B = img(:,:,3);  % Blue通道
        
        % 对每个通道进行中值滤波
        R_filt = medfilt2(R, [3 3]);
        G_filt = medfilt2(G, [3 3]);
        B_filt = medfilt2(B, [3 3]);
        
        % 合并处理后的RGB通道
        filteredImage = cat(3, R_filt, G_filt, B_filt);
    else
        % 如果是灰度图像，直接进行中值滤波
        filteredImage = medfilt2(img, [3 3]);
    end

    % 显示滤波后的图像在 axes2 中
    axes(handles.axes2);
    imshow(filteredImage);
    
    % 将滤波后的图像保存到 handles 结构中
    handles.filteredImage = filteredImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误提示
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，执行左右翻转
        flippedImage = flip(img, 2);
    else
        % 如果是灰度图像，直接执行左右翻转
        flippedImage = flip(img, 2);
    end

    % 更新handles结构中的图像数据
    handles.imageData1 = flippedImage;

    % 将翻转后的图像显示在axes2中
    axes(handles.axes2);
    imshow(flippedImage);
    
    % 更新handles结构
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，执行上下翻转
        flippedImage = flip(img, 1);
    else
        % 如果是灰度图像，直接执行上下翻转
        flippedImage = flip(img, 1);
    end

    % 更新handles结构中的图像数据
    handles.imageData1 = flippedImage;

    % 将翻转后的图像显示在axes2中
    axes(handles.axes2);
    imshow(flippedImage);
    
    % 更新handles结构
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，转换为灰度图像以进行直方图均衡化
        grayImage = rgb2gray(img);
        % 执行直方图均衡化
        enhancedImage = histeq(grayImage);
    else
        % 如果是灰度图像，直接进行直方图均衡化
        enhancedImage = histeq(img);
    end

    % 将增强后的图像显示在axes2中
    axes(handles.axes2);
    imshow(enhancedImage);

     axes(handles.axes3);
    [equalizedCounts, binLocations] = imhist(enhancedImage);
    bar(binLocations, equalizedCounts, 'k');  % 使用黑色条形显示均衡化后的直方图
    title('均衡化后的灰度直方图');
    xlabel('灰度级');
    ylabel('像素数量');

    % 更新handles结构中的增强图像
    handles.enhancedImage = enhancedImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1') && isfield(handles, 'imageData2')
    % 获取加载的图像数据
    img = handles.imageData1;
    refImg = handles.imageData1; % 参考图像

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，转换为灰度图像以进行直方图匹配
        grayImage = rgb2gray(img);
        refGrayImage = rgb2gray(refImg);
        % 执行直方图匹配
        matchedImage = imhistmatch(grayImage, refGrayImage);
    else
        % 如果是灰度图像，直接进行直方图匹配
        matchedImage = imhistmatch(img, refImg);
    end

    % 将匹配后的图像显示在axes2中
    axes(handles.axes2);
    imshow(matchedImage);
    
    axes(handles.axes3);
    [equalizedCounts, binLocations] = imhist(matchedImage);
    bar(binLocations, equalizedCounts, 'k');  % 使用黑色条形显示均衡化后的直方图
    
    title('匹配后灰度图像直方图');
    xlabel('灰度级');
    ylabel('像素数量');

    % 更新handles结构中的匹配图像
    handles.matchedImage = matchedImage;
    guidata(hObject, handles);
else
    % 如果未加载图像或参考图像，显示错误对话框
    errordlg('请先选择一张图像和参考图像。', '错误');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，应用高斯滤波
        filteredImage = imgaussfilt(img, 2); % 2为标准差，可以根据需要调整
    else
        % 如果是灰度图像，直接应用高斯滤波
        filteredImage = imgaussfilt(img, 2); % 2为标准差，可以根据需要调整
    end

    % 将滤波后的图像显示在axes2中
    axes(handles.axes2);
    imshow(filteredImage);
    
    % 更新handles结构中的滤波图像
    handles.filteredImage = filteredImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将每个通道分别添加泊松噪声
        noisyImage = zeros(size(img)); % 初始化噪声图像
        for i = 1:3
            noisyImage(:, :, i) = imnoise(img(:, :, i), 'poisson');
        end
        noisyImage = uint8(noisyImage); % 转换为uint8类型
    else
        % 如果是灰度图像，直接添加泊松噪声
        noisyImage = imnoise(img, 'poisson');
    end

    % 将添加噪声后的图像显示在axes2中
    axes(handles.axes2);
    imshow(noisyImage);
    
    % 更新handles结构中的噪声图像
    handles.noisyImage = noisyImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，添加椒盐噪声
        noisyImage = imnoise(img, 'salt & pepper', 0.02); % 0.02为噪声密度，可根据需要调整
    else
        % 如果是灰度图像，直接添加椒盐噪声
        noisyImage = imnoise(img, 'salt & pepper', 0.02); % 0.02为噪声密度
    end

    % 将添加噪声后的图像显示在axes2中
    axes(handles.axes2);
    imshow(noisyImage);
    
    % 更新handles结构中的噪声图像
    handles.noisyImage = noisyImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 获取图像的尺寸
    [rows, cols, channels] = size(img);

    % 创建正弦波噪声
    [X, Y] = meshgrid(1:cols, 1:rows);
    frequency = 10; % 正弦波频率，可根据需要调整
    amplitude = 30; % 正弦波幅度，可根据需要调整
    sineWave = amplitude * sin(2 * pi * frequency * X / cols);

    % 将正弦波噪声添加到图像上
    noisyImage = zeros(size(img)); % 初始化噪声图像
    for c = 1:channels
        noisyImage(:, :, c) = double(img(:, :, c)) + sineWave; % 添加正弦噪声
    end
    noisyImage = uint8(min(max(noisyImage, 0), 255)); % 保证图像像素值在0-255之间

    % 将添加噪声后的图像显示在axes2中
    axes(handles.axes2);
    imshow(noisyImage);
    
    % 更新handles结构中的噪声图像
    handles.noisyImage = noisyImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，应用均值滤波
        filteredImage = imfilter(img, fspecial('average', [3 3])); % 3x3均值滤波器
    else
        % 如果是灰度图像，直接应用均值滤波
        filteredImage = imfilter(img, fspecial('average', [3 3])); % 3x3均值滤波器
    end

    % 将滤波后的图像显示在axes2中
    axes(handles.axes2);
    imshow(filteredImage);
    
    % 更新handles结构中的滤波图像
    handles.filteredImage = filteredImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，应用高斯滤波
        filteredImage = imgaussfilt(img, 2); % 2为标准差，可以根据需要调整
    else
        % 如果是灰度图像，直接应用高斯滤波
        filteredImage = imgaussfilt(img, 2); % 2为标准差，可以根据需要调整
    end

    % 将滤波后的图像显示在axes2中
    axes(handles.axes2);
    imshow(filteredImage);
    
    % 更新handles结构中的滤波图像
    handles.filteredImage = filteredImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 进行二值化处理
    binaryImage = imbinarize(grayImage);

    % 应用骨架提取
    skeletonImage = bwskel(binaryImage);

    % 将骨架提取后的图像显示在axes2中
    axes(handles.axes2);
    imshow(skeletonImage);
    
    % 更新handles结构中的骨架提取图像
    handles.skeletonImage = skeletonImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 转换为灰度图像
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % 转换为双精度类型
    img = double(img) + 1; % 防止对数变为负数

    % 进行傅里叶变换
    fftImage = fft2(img);
    fftImageShifted = fftshift(fftImage);

    % 计算幅度谱和相位谱
    magnitude = abs(fftImageShifted);
    phase = angle(fftImageShifted);

    % 定义高通滤波器
    [rows, cols] = size(img);
    [X, Y] = meshgrid(1:cols, 1:rows);
    D0 = 30; % 截止频率
    D = sqrt((X - cols/2).^2 + (Y - rows/2).^2);
    H = 1 - exp(-(D.^2) / (2 * (D0^2))); % 高通滤波器

    % 应用同态滤波
    filteredMagnitude = magnitude .* H;
    filteredImage = ifft2(ifftshift(filteredMagnitude .* exp(1i * phase)));
    filteredImage = real(filteredImage);

    % 归一化处理
    filteredImage = mat2gray(filteredImage);

    % 将处理后的图像显示在axes2中
    axes(handles.axes2);
    imshow(filteredImage);
    
    % 更新handles结构中的滤波图像
    handles.filteredImage = filteredImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 应用Sobel算子进行边缘检测
    sobelEdgeImage = edge(grayImage, 'sobel');

    % 将边缘检测后的图像显示在axes2中
    axes(handles.axes2);
    imshow(sobelEdgeImage);
    
    % 更新handles结构中的边缘检测图像
    handles.sobelEdgeImage = sobelEdgeImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 应用Roberts算子进行边缘检测
    robertsEdgeImage = edge(grayImage, 'roberts');

    % 将边缘检测后的图像显示在axes2中
    axes(handles.axes2);
    imshow(robertsEdgeImage);
    
    % 更新handles结构中的边缘检测图像
    handles.robertsEdgeImage = robertsEdgeImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
    if isfield(handles, 'imageData1')
        % 获取加载的图像
        img = handles.imageData1;

        % 转换为灰度图像（如果是彩色图像）
        if size(img, 3) == 3
            img = rgb2gray(img);
        end

        % 应用 Prewitt 边缘检测
        hPrewittX = [-1 0 1; -1 0 1; -1 0 1]; % Prewitt X 算子
        hPrewittY = [-1 -1 -1; 0 0 0; 1 1 1]; % Prewitt Y 算子

        % 对图像进行卷积
        edgeX = conv2(double(img), hPrewittX, 'same'); % 水平边缘
        edgeY = conv2(double(img), hPrewittY, 'same'); % 垂直边缘

        % 计算边缘强度
        edges = sqrt(edgeX.^2 + edgeY.^2);
        edges = uint8(min(max(edges, 0), 255)); % 限制在 0 到 255 之间

        % 在指定的 axes 中显示边缘检测结果
        axes(handles.axes2);
        cla; % 清除当前坐标轴
        imshow(edges);

        % 更新 handles 结构中的边缘检测结果
        handles.edges = edges;
        guidata(hObject, handles);
    else
        % 如果未加载图像，显示错误对话框
        errordlg('请先选择一张图像。', '错误');
    end

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 应用高斯滤波
    sigma = 1; % 高斯滤波的标准差，可以根据需要调整
    gaussianFiltered = imgaussfilt(grayImage, sigma);

    % 应用拉普拉斯算子进行边缘检测
    logEdgeImage = edge(gaussianFiltered, 'log');

    % 将边缘检测后的图像显示在axes2中
    axes(handles.axes2);
    imshow(logEdgeImage);
    
    % 更新handles结构中的边缘检测图像
    handles.logEdgeImage = logEdgeImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 应用Canny算子进行边缘检测
    cannyEdgeImage = edge(grayImage, 'canny');

    % 将边缘检测后的图像显示在axes2中
    axes(handles.axes2);
    imshow(cannyEdgeImage);
    
    % 更新handles结构中的边缘检测图像
    handles.cannyEdgeImage = cannyEdgeImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 应用拉普拉斯算子进行边缘检测
    laplacianFilter = fspecial('laplacian', 0.2); % 创建拉普拉斯滤波器
    laplacianEdgeImage = imfilter(grayImage, laplacianFilter, 'replicate');

    % 对结果进行阈值处理
    laplacianEdgeImage = imbinarize(laplacianEdgeImage);

    % 将边缘检测后的图像显示在axes2中
    axes(handles.axes2);
    imshow(laplacianEdgeImage);
    
    % 更新handles结构中的边缘检测图像
    handles.laplacianEdgeImage = laplacianEdgeImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 转换为双精度类型
    grayImage = double(grayImage);

    % 进行傅里叶变换
    fftImage = fft2(grayImage);
    fftImageShifted = fftshift(fftImage); % 将零频率成分移到频谱中心

    % 计算幅度谱
    magnitude = abs(fftImageShifted);
    magnitude = log(1 + magnitude); % 使用对数尺度增强可视化

    % 归一化幅度谱以便显示
    magnitude = mat2gray(magnitude);

    % 将频域图像显示在axes2中
    axes(handles.axes2);
    imshow(magnitude);
    
    % 更新handles结构中的傅里叶变换图像
    handles.fourierImage = magnitude;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
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



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否已经是灰度图
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
        % 将灰度图像显示在axes2中
        axes(handles.axes2);
        imshow(grayImage);

        % 将灰度图像显示在axes2中
        axes(handles.axes3);

        % 计算灰度直方图
        [counts, binLocations] = imhist(grayImage);
        % 显示灰度直方图
        bar(binLocations, counts, 'k');  % 使用黑色条形显示直方图
        title('灰度直方图');
        xlabel('灰度级');
        ylabel('像素数量');
        % 将灰度图保存到handles结构中
        handles.grayImage = grayImage;
        guidata(hObject, handles);
    else
        % 如果已经是灰度图像，直接显示
        axes(handles.axes2);
        imshow(img);
        handles.grayImage = img;
        guidata(hObject, handles);
    end
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查图像是否存在
    if isfield(handles, 'imageData1')
        % 获取加载的图像数据
        img = handles.imageData1;
 
        % 定义缩放因子
        scaleFactor = 0.6;
 
        % 获取图像的尺寸
        [rows, cols, channels] = size(img);
 
        % 计算新图像的尺寸（注意：这里使用最近邻插值来简化，但建议使用 imresize）
        % 由于 imresize 已经非常优化，我们直接使用它
        resizedImage = imresize(img, scaleFactor, 'bilinear');
 
        % 更新handles结构中的图像数据
        handles.imageData1 = resizedImage;
 
        % 将缩放后的图像显示在axes2中
        axes(handles.axes2);
        imshow(resizedImage);
 
        % 更新handles结构
        guidata(hObject, handles);
    else
        % 如果未加载图像，显示错误对话框
        errordlg('请先选择一张图像。', '错误');
    end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查是否存在图像数据
if isfield(handles, 'imageData1')
    % 获取加载的图像
    img = handles.imageData1;

    % 检查是否是彩色图像
    if size(img, 3) == 3
        % 分离RGB三通道
        R = double(img(:,:,1)) / 255;  % Red通道，转换为double并归一化
        G = double(img(:,:,2)) / 255;  % Green通道，转换为double并归一化
        B = double(img(:,:,3)) / 255;  % Blue通道，转换为double并归一化
        
        % 定义伽马值（非线性对比度增强的关键参数）
        gamma = 0.5; 
        
        % 对每个通道进行伽马变换
        R_corrected = R .^ gamma;
        G_corrected = G .^ gamma;
        B_corrected = B .^ gamma;
        
        % 将结果重新缩放到0-255范围并转换为uint8
        R_corrected = uint8(R_corrected * 255);
        G_corrected = uint8(G_corrected * 255);
        B_corrected = uint8(B_corrected * 255);
        
        % 合并处理后的RGB通道
        enhancedImage = cat(3, R_corrected, G_corrected, B_corrected);
    else
        % 如果是灰度图像，直接使用伽马变换
        img_double = double(img) / 255; % 转换为double并归一化
        img_corrected = img_double .^ gamma; % 伽马变换
        enhancedImage = uint8(img_corrected * 255); % 重新缩放到0-255范围并转换为uint8
    end

    % 显示增强后的彩色图像在 axes2 中
    axes(handles.axes2);
    imshow(enhancedImage);
    
    % 将增强后的图像保存到 handles 结构中
    handles.enhancedImage = enhancedImage;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误提示
    errordlg('请先选择一张图像。', '错误');
end


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% 检查图像是否存在
if isfield(handles, 'imageData1')
    % 获取加载的图像数据
    img = handles.imageData1;

    % 判断图像是否为彩色图像（RGB）
    if size(img, 3) == 3
        % 如果是RGB图像，将其转换为灰度图像
        grayImage = rgb2gray(img);
    else
        % 如果是灰度图像，直接使用
        grayImage = img;
    end

    % 获取图像的尺寸
    [rows, cols] = size(grayImage);

    % 应用LBP特征提取
    % 这里采用滑动窗口方法对图像进行局部LBP特征提取
    cellSize = [16 16];  
    lbpFeatures = extractLBPFeatures(grayImage, 'CellSize', cellSize);  % 提取LBP特征

    % 计算图像每块的LBP特征
    numRows = floor(rows / cellSize(1));  % 行数
    numCols = floor(cols / cellSize(2));  % 列数
    lbpImage = zeros(numRows, numCols);   % 初始化LBP热图

    % 用滑动窗口计算每块的LBP值
    for r = 1:numRows
        for c = 1:numCols
            % 计算每块的LBP特征
            block = grayImage((r-1)*cellSize(1)+1:r*cellSize(1), ...
                               (c-1)*cellSize(2)+1:c*cellSize(2));
            lbpBlock = extractLBPFeatures(block, 'CellSize', [8 8]);  % 小块LBP特征
            lbpImage(r, c) = mean(lbpBlock);  % 将小块的LBP特征取平均值
        end
    end

    % 归一化到[0, 1]范围
    lbpImage = mat2gray(lbpImage);

    % 应用HOG特征提取，并生成可视化
    [hogFeatures, visualization] = extractHOGFeatures(grayImage, 'CellSize', [8 8]); 

    % 显示HOG特征可视化图
    axes(handles.axes2);
    plot(visualization);  
    title('HOG 特征可视化');
    
    % 显示LBP特征图
    axes(handles.axes3);
    imshow(lbpImage, []); % 显示 LBP 热图
    title('LBP 特征可视化');
    
    % 更新handles结构中的特征数据
    handles.lbpFeatures = lbpFeatures;
    handles.hogFeatures = hogFeatures;
    guidata(hObject, handles);
else
    % 如果未加载图像，显示错误对话框
    errordlg('请先选择一张图像。', '错误');
end
