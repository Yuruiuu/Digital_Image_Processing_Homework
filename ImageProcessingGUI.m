function ImageProcessingGUI
    % 创建主界面
    fig = figure('Name', '图像处理工具', ...
                 'NumberTitle', 'off', ...
                 'Position', [200, 200, 800, 600]); % 界面大小
             
    % 添加菜单
    uimenu(fig, 'Text', '文件', 'MenuSelectedFcn', @(~,~)disp('文件选项'));
    uimenu(fig, 'Text', '关于', 'MenuSelectedFcn', @(~,~)disp('关于选项'));

    % 设置按钮和显示区域布局
    % 图像显示区域
    uicontrol(fig, 'Style', 'text', ...
                   'Position', [30, 550, 150, 30], ...
                   'String', '原始图像');
    axes1 = axes('Parent', fig, ...
                 'Position', [0.05, 0.3, 0.4, 0.5]); % 左侧原始图像区
             
    uicontrol(fig, 'Style', 'text', ...
                   'Position', [430, 550, 150, 30], ...
                   'String', '处理后图像');
    axes2 = axes('Parent', fig, ...
                 'Position', [0.55, 0.3, 0.4, 0.5]); % 右侧处理后图像区
             
    % 按钮功能区域
    uicontrol(fig, 'Style', 'pushbutton', ...
                   'Position', [30, 180, 150, 40], ...
                   'String', '打开图像', ...
                   'Callback', @(~,~)loadImage(axes1));
               
    uicontrol(fig, 'Style', 'pushbutton', ...
                   'Position', [200, 180, 150, 40], ...
                   'String', '直方图均衡化', ...
                   'Callback', @(~,~)histogramEqualization(axes1, axes2));
               
    uicontrol(fig, 'Style', 'pushbutton', ...
                   'Position', [370, 180, 150, 40], ...
                   'String', '添加噪声', ...
                   'Callback', @(~,~)addNoise(axes1, axes2));
               
    uicontrol(fig, 'Style', 'pushbutton', ...
                   'Position', [540, 180, 150, 40], ...
                   'String', '边缘检测', ...
                   'Callback', @(~,~)edgeDetection(axes1, axes2));
               
    uicontrol(fig, 'Style', 'pushbutton', ...
                   'Position', [700, 180, 70, 40], ...
                   'String', '退出', ...
                   'Callback', @(~,~)close(fig));

    % 参数输入区
    uicontrol(fig, 'Style', 'text', ...
                   'Position', [30, 130, 150, 30], ...
                   'String', '参数输入：');
    paramBox = uicontrol(fig, 'Style', 'edit', ...
                              'Position', [200, 130, 150, 30], ...
                              'String', '0.5'); % 示例默认值
end

% ========== 功能实现部分 ==========
function loadImage(axesHandle)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'});
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    axes(axesHandle);
    imshow(img);
    title('原始图像');
    assignin('base', 'loadedImage', img); % 保存到工作区以便后续使用
end

function histogramEqualization(srcAxes, destAxes)
    img = evalin('base', 'loadedImage'); % 从工作区读取图像
    if size(img, 3) == 3
        img = rgb2gray(img); % 转灰度图
    end
    equalizedImg = histeq(img); % 直方图均衡化
    axes(destAxes);
    imshow(equalizedImg);
    title('直方图均衡化后');
end

function addNoise(srcAxes, destAxes)
    img = evalin('base', 'loadedImage'); % 从工作区读取图像
    noiseType = 'salt & pepper'; % 示例噪声类型
    noisyImg = imnoise(img, noiseType, 0.02); % 添加噪声
    axes(destAxes);
    imshow(noisyImg);
    title('添加噪声后');
end

function edgeDetection(srcAxes, destAxes)
    img = evalin('base', 'loadedImage'); % 从工作区读取图像
    if size(img, 3) == 3
        img = rgb2gray(img); % 转灰度图
    end
    edges = edge(img, 'sobel'); % 使用 Sobel 算子检测边缘
    axes(destAxes);
    imshow(edges);
    title('边缘检测');
end
