classdef ImageProcessingGUI < handle
    properties (Access = private)
        % 图像数据
        OriginalImage      % 原始图像
        ProcessedImage     % 处理后的图像
        
        % 主窗口
        MainFigure
        
        % 主要面板
        ImagePanel          % 图像显示面板
        HistogramPanel      % 直方图面板
        ControlPanel       % 控制面板
        
        % 显示组件
        OriginalAxes       % 原图显示区
        ProcessedAxes      % 处理后图像显示区
        HistogramAxes      % 直方图显示区
        StatusLabel        % 状态信息标签
        ImageInfoLabel     % 图像信息标签
        TargetResultAxes   % 提取结果显示区   <<< 新增属性
        
        % 增强参数
        LogParam = 1        % 对数变换参数c
        ExpParam = 1.5      % 指数变换参数b
        StretchMin = 0      % 线性拉伸最小值
        StretchMax = 255    % 线性拉伸最大值
        GammaParam = 1      % 伽马校正参数
        
        KernelSizeDropDown    % 添加一个属性来存储核大小下拉列表的引用
        EdgeThresholdSlider    % 边缘检测阈值滑块
        
        LBPRadius           % LBP特征半径
        HOGCellSize        % HOG特征单元格大小
        LBPFeatureImage    % LBP特征图
        HOGFeatureImage    % HOG特征图
        LBPRadiusSpinner    % LBP半径输入框
        HOGCellSizeSpinner  % HOG单元格大小输入框
        
    end
    
    methods (Access = public)
        function app = ImageProcessingGUI()
            app.createGUI();
        end
    end
    
    methods (Access = private)
        function createGUI(app)
            % 创建主窗口
            app.MainFigure = uifigure('Name', '图像处理系统', ...
                'Position', [100 50 1400 800], ...
                'Color', [0.94 0.94 0.94]);
            
            % 创建网格布局
            mainGrid = uigridlayout(app.MainFigure, [3 3]);
            mainGrid.ColumnWidth = {'2x', '1x', '1x'};
            mainGrid.RowHeight = {30, '1x', '1x'};
            mainGrid.Padding = [10 10 10 10];
            mainGrid.ColumnSpacing = 10;
            mainGrid.RowSpacing = 10;
            
            % 创建顶部状态栏
            app.createStatusBar(mainGrid);
            
            % 创建图像显示区
            app.createImagePanel(mainGrid);
            
            % 创建右侧控制面板
            app.createControlPanels(mainGrid);
        end
        
        function createStatusBar(app, grid)
            % 创建状态栏面板
            statusPanel = uipanel(grid);
            statusPanel.Layout.Row = 1;
            statusPanel.Layout.Column = [1 3];
            statusPanel.BackgroundColor = [1 1 1];
            
            % 状态信息布局
            statusGrid = uigridlayout(statusPanel, [1 2]);
            statusGrid.ColumnWidth = {'1x', '1x'};
            statusGrid.Padding = [5 2 5 2];
            
            % 状态信息标签
            app.StatusLabel = uilabel(statusGrid);
            app.StatusLabel.Text = '状态：就绪';
            app.StatusLabel.FontColor = [0 0.5 0];
            
            % 图像信息标签
            app.ImageInfoLabel = uilabel(statusGrid);
            app.ImageInfoLabel.Text = '图像信息：等待加载图像...';
            app.ImageInfoLabel.HorizontalAlignment = 'right';
        end
        
        function createImagePanel(app, grid)
            % 创建图像显示面板
            app.ImagePanel = uipanel(grid);
            app.ImagePanel.Title = '图像显示';
            app.ImagePanel.Layout.Row = [2 3];
            app.ImagePanel.Layout.Column = 1;
            app.ImagePanel.BackgroundColor = [1 1 1];
            
            % 图像显示区布局
            imageGrid = uigridlayout(app.ImagePanel, [2 1]);
            imageGrid.RowHeight = {'1x', '1x'};
            imageGrid.Padding = [5 5 5 5];
            imageGrid.RowSpacing = 10;
            
            % 原始图像显示
            originalPanel = uipanel(imageGrid);
            originalPanel.Title = '原始图像';
            app.OriginalAxes = uiaxes(originalPanel);
            app.OriginalAxes.Position = [10 10 460 280];
            
            % 处理后图像显示
            processedPanel = uipanel(imageGrid);
            processedPanel.Title = '处理后图像';
            app.ProcessedAxes = uiaxes(processedPanel);
            app.ProcessedAxes.Position = [10 10 460 280];
            
            
            % 提取结果显示
            targetPanel = uipanel(imageGrid);
            targetPanel.Title = '提取结果';
            app.TargetResultAxes = uiaxes(targetPanel); % 增加提取结果的显示区
            app.TargetResultAxes.Position = [10 10 460 280];
        end
        
        function createControlPanels(app, grid)
            % 创建控制面板容器
            app.ControlPanel = uitabgroup(grid);
            app.ControlPanel.Layout.Row = [2 3];
            app.ControlPanel.Layout.Column = [2 3];
            
            % 创建各功能标签页
            app.createBasicProcessTab();
            app.createEnhanceTab();
            app.createFilterTab();
            app.createEdgeDetectionTab();
            app.createFeatureExtractionTab();
            app.createTargetExtractionTab();%目标提取
            app.createDeepLearningTab();
        end
        
        function createBasicProcessTab(app)
            tab = uitab(app.ControlPanel, 'Title', '基础处理');
            
            % 创建网格布局
            grid = uigridlayout(tab, [7 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', 'fit'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 10;
            
            % 基础操作按钮
            uibutton(grid, 'Text', '打开图像', ...
                'ButtonPushedFcn', @(btn,event) app.openImage());
            
            uibutton(grid, 'Text', '保存图像', ...
                'ButtonPushedFcn', @(btn,event) app.saveImage());
            
            uibutton(grid, 'Text', '图像归一化', ...
                'ButtonPushedFcn', @(btn,event) app.normalizeImage());
            
            uibutton(grid, 'Text', '直方图均衡化', ...
                'ButtonPushedFcn', @(btn,event) app.equalizeHistogram());
            
            % 直方图显示区
            app.createHistogramPanel(grid);
        end
        
        function createHistogramPanel(app, parent)
            histPanel = uipanel(parent);
            histPanel.Title = '灰度直方图';
            
            app.HistogramAxes = uiaxes(histPanel);
            app.HistogramAxes.Position = [10 10 360 200];
            app.HistogramAxes.Title.String = '灰度直方图';
            app.HistogramAxes.XLabel.String = '灰度值';
            app.HistogramAxes.YLabel.String = '像素数量';
        end
        
        function createEnhanceTab(app)
            tab = uitab(app.ControlPanel, 'Title', '图像增强');
            
            % 创建网格布局
            grid = uigridlayout(tab, [6 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', '1x'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 15;
            
            % 对比度增强组
            contrastGroup = uipanel(grid);
            contrastGroup.Title = '对比度调节';
            
            cgrid = uigridlayout(contrastGroup, [2 1]);
            cgrid.RowHeight = {'fit', 'fit'};
            cgrid.Padding = [5 5 5 5];
            
            % 对比度滑块
            uilabel(cgrid, 'Text', '对比度系数');
            slider = uislider(cgrid);
            slider.Limits = [0 2];
            slider.Value = 1;
            slider.ValueChangingFcn = @(sld,event) app.updateStatus(['调节对比度: ', num2str(sld.Value)]);
            
            % 图像变换组
            transformGroup = uipanel(grid);
            transformGroup.Title = '图像变换';
            
            tgrid = uigridlayout(transformGroup, [2 2]);
            tgrid.Padding = [5 5 5 5];
            
            % 对数变换按钮和参数
            logPanel = uipanel(tgrid);
            logLayout = uigridlayout(logPanel, [2 1]);
            logLayout.RowHeight = {'fit', 'fit'};
            logLayout.Padding = [2 2 2 2];
            
            uibutton(logLayout, 'Text', '对数变换', ...
                'ButtonPushedFcn', @(btn,event) app.logTransform());
            
            % 对数变换系数c
            spinnerLayout = uigridlayout(logLayout, [1 2]);
            spinnerLayout.ColumnWidth = {'fit', '1x'};
            uilabel(spinnerLayout, 'Text', '系数c:');
            uispinner(spinnerLayout, 'Value', 1, 'Limits', [0.1 10], 'Step', 0.1, ...
                'ValueChangedFcn', @(spin,event) app.updateLogParam(spin.Value));
            
            % 指数变换按钮和参数
            expPanel = uipanel(tgrid);
            expLayout = uigridlayout(expPanel, [2 1]);
            expLayout.RowHeight = {'fit', 'fit'};
            expLayout.Padding = [2 2 2 2];
            
            uibutton(expLayout, 'Text', '指数变换', ...
                'ButtonPushedFcn', @(btn,event) app.exponentialTransform());
            
            % 指数变换系数b
            expSpinnerLayout = uigridlayout(expLayout, [1 2]);
            expSpinnerLayout.ColumnWidth = {'fit', '1x'};
            uilabel(expSpinnerLayout, 'Text', '系数b:');
            uispinner(expSpinnerLayout, 'Value', 1.5, 'Limits', [0.1 5], 'Step', 0.1, ...
                'ValueChangedFcn', @(spin,event) app.updateExpParam(spin.Value));
            
            % 线性拉伸按钮和参数
            stretchPanel = uipanel(tgrid);
            stretchLayout = uigridlayout(stretchPanel, [3 1]);
            stretchLayout.RowHeight = {'fit', 'fit', 'fit'};
            stretchLayout.Padding = [2 2 2 2];
            
            uibutton(stretchLayout, 'Text', '线性拉伸', ...
                'ButtonPushedFcn', @(btn,event) app.linearStretch());
            
            % 拉伸范围设置
            rangeLayout = uigridlayout(stretchLayout, [2 2]);
            rangeLayout.ColumnWidth = {'fit', '1x'};
            
            uilabel(rangeLayout, 'Text', '最小值:');
            uispinner(rangeLayout, 'Value', 0, 'Limits', [0 255], ...
                'ValueChangedFcn', @(spin,event) app.updateStretchMin(spin.Value));
            
            uilabel(rangeLayout, 'Text', '最大值:');
            uispinner(rangeLayout, 'Value', 255, 'Limits', [0 255], ...
                'ValueChangedFcn', @(spin,event) app.updateStretchMax(spin.Value));
            
            % 伽马校正按钮和参数
            gammaPanel = uipanel(tgrid);
            gammaLayout = uigridlayout(gammaPanel, [2 1]);
            gammaLayout.RowHeight = {'fit', 'fit'};
            gammaLayout.Padding = [2 2 2 2];
            
            uibutton(gammaLayout, 'Text', '伽马校正', ...
                'ButtonPushedFcn', @(btn,event) app.gammaCorrection());
            
            % 伽马值设置
            gammaSpinnerLayout = uigridlayout(gammaLayout, [1 2]);
            gammaSpinnerLayout.ColumnWidth = {'fit', '1x'};
            uilabel(gammaSpinnerLayout, 'Text', 'γ值:');
            uispinner(gammaSpinnerLayout, 'Value', 1, 'Limits', [0.1 5], 'Step', 0.1, ...
                'ValueChangedFcn', @(spin,event) app.updateGammaParam(spin.Value));
        end
        
        function createFilterTab(app)
            tab = uitab(app.ControlPanel, 'Title', '滤波处理');
            
            % 创建网格布局
            grid = uigridlayout(tab, [7 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', '1x'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 10;
            
            % 滤波器选择组
            filterGroup = uipanel(grid);
            filterGroup.Title = '滤波器选择';
            
            fgrid = uigridlayout(filterGroup, [4 1]);
            fgrid.RowHeight = {'fit', 'fit', 'fit', 'fit'};
            fgrid.Padding = [5 5 5 5];
            
            uibutton(fgrid, 'Text', '高斯滤波', ...
                'ButtonPushedFcn', @(btn,event) app.gaussianFilter());
            
            uibutton(fgrid, 'Text', '中值滤波', ...
                'ButtonPushedFcn', @(btn,event) app.medianFilter());
            
            uibutton(fgrid, 'Text', '均值滤波', ...
                'ButtonPushedFcn', @(btn,event) app.meanFilter());
            
            % 核大小选择
            kernelGroup = uipanel(grid);
            kernelGroup.Title = '滤波核参数';
            
            kgrid = uigridlayout(kernelGroup, [2 1]);
            kgrid.RowHeight = {'fit', 'fit'};
            kgrid.Padding = [5 5 5 5];
            
            uilabel(kgrid, 'Text', '核大小选择');
            app.KernelSizeDropDown = uidropdown(kgrid, ...
                'Items', {'3x3', '5x5', '7x7', '9x9'}, ...
                'Value', '3x3', ...  % 设置默认值
                'ValueChangedFcn', @(dd,event) app.updateStatus(['选择核大小: ', dd.Value]));
        end
        
        function createEdgeDetectionTab(app)
            tab = uitab(app.ControlPanel, 'Title', '边缘检测');
            
            % 创建网格布局
            grid = uigridlayout(tab, [6 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', '1x'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 10;
            
            % 边缘检测算子
            operatorGroup = uipanel(grid);
            operatorGroup.Title = '边缘检测算子';
            
            ogrid = uigridlayout(operatorGroup, [4 1]);
            ogrid.RowHeight = {'fit', 'fit', 'fit', 'fit'};
            ogrid.Padding = [5 5 5 5];
            
            % 更新按钮回调函数
            uibutton(ogrid, 'Text', 'Roberts算子', ...
                'ButtonPushedFcn', @(btn,event) app.robertsEdgeDetection());
            
            uibutton(ogrid, 'Text', 'Prewitt算子', ...
                'ButtonPushedFcn', @(btn,event) app.prewittEdgeDetection());
            
            uibutton(ogrid, 'Text', 'Sobel算子', ...
                'ButtonPushedFcn', @(btn,event) app.sobelEdgeDetection());
            
            uibutton(ogrid, 'Text', '拉普拉斯算子', ...
                'ButtonPushedFcn', @(btn,event) app.laplaceEdgeDetection());
            
            % 参数设置组
            paramGroup = uipanel(grid);
            paramGroup.Title = '参数设置';
            
            pgrid = uigridlayout(paramGroup, [2 1]);
            pgrid.RowHeight = {'fit', 'fit'};
            pgrid.Padding = [5 5 5 5];
            
            uilabel(pgrid, 'Text', '阈值设置');
            app.EdgeThresholdSlider = uislider(pgrid);
            app.EdgeThresholdSlider.Limits = [0 1];
            app.EdgeThresholdSlider.Value = 0.1;  % 设置默认阈值
            app.EdgeThresholdSlider.ValueChangingFcn = @(sld,event) app.updateStatus(['边缘检测阈值: ', num2str(sld.Value)]);
        end
        
        
        %-----------修改------------
        
        function createTargetExtractionTab(app)
            % 创建目标提取标签页
            tab = uitab(app.ControlPanel, 'Title', '目标提取');

            % 创建网格布局
            grid = uigridlayout(tab, [4, 1]);
            grid.RowHeight = {'fit', 'fit', '1x', 'fit'};
            grid.Padding = [10, 10, 10, 10];
            grid.RowSpacing = 10;

            % 目标提取按钮
            uibutton(grid, 'Text', '加载目标图像', ...
                'ButtonPushedFcn', @(btn, event) app.loadTargetImage());

            uibutton(grid, 'Text', '分割目标', ...
                'ButtonPushedFcn', @(btn, event) app.segmentTarget());

            uibutton(grid, 'Text', '显示提取结果', ...
                'ButtonPushedFcn', @(btn, event) app.extractTarget());
        end

        function loadTargetImage(app)
            % 加载目标图像
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件(*.jpg, *.png, *.bmp)'});
            if isequal(file, 0)
                app.updateStatus('未选择图像文件');
                return;
            end
            imgPath = fullfile(path, file);
            app.OriginalImage = imread(imgPath);

            % 显示原始图像
            imshow(app.OriginalImage, 'Parent', app.OriginalAxes);
            app.updateStatus('加载图像成功');
        end

function segmentTarget(app)
    % 图像分割 - 基于手动选择ROI的分割
    if isempty(app.OriginalImage)
        app.updateStatus('请先加载图像');
        return;
    end
    
    % 在原始图像中选择感兴趣区域 (ROI)
    figure; imshow(app.OriginalImage); title('请在图中选择鸟的区域并双击确认');
    h = drawpolygon(); % 手动绘制多边形区域
    mask = createMask(h); % 创建掩码
    close; % 关闭绘制窗口

    % 使用活动轮廓法 (active contour) 细化分割结果
    grayImage = rgb2gray(app.OriginalImage); % 转为灰度图
    refinedMask = activecontour(grayImage, mask, 300); % 使用活动轮廓优化掩码

    % 更新分割结果
    app.ProcessedImage = refinedMask;

    % 显示分割结果
    imshow(refinedMask, 'Parent', app.ProcessedAxes, 'InitialMagnification', 'fit');
    app.updateStatus('目标分割完成');
end


function extractTarget(app)
    % 提取目标（结合原图与分割掩码）
    if isempty(app.ProcessedImage)
        app.updateStatus('请先进行图像分割');
        return;
    end
    
    % 提取分割目标
    mask = app.ProcessedImage;
    extractedTarget = bsxfun(@times, app.OriginalImage, cast(mask, 'like', app.OriginalImage));
    
    % 显示提取后的目标在提取结果显示区
    imshow(extractedTarget, 'Parent', app.TargetResultAxes); % 在TargetResultAxes中显示结果
    app.updateStatus('目标提取完成');
end



        
        
        %---------------------------
      
        function createFeatureExtractionTab(app)
            tab = uitab(app.ControlPanel, 'Title', '特征提取');
            
            % 创建网格布局
            grid = uigridlayout(tab, [5 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', '1x', 'fit'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 10;
            
            % LBP特征组
            lbpGroup = uipanel(grid);
            lbpGroup.Title = 'LBP特征提取';
            
            lgrid = uigridlayout(lbpGroup, [3 1]);
            lgrid.RowHeight = {'fit', 'fit', 'fit'};
            lgrid.Padding = [5 5 5 5];
            
            % LBP特征提取按钮
            uibutton(lgrid, 'Text', 'LBP特征提取', ...
                'ButtonPushedFcn', @(btn,event) app.extractLBPFeatures());
            
            % LBP参数设置面板
            paramPanel = uipanel(lgrid);
            paramGrid = uigridlayout(paramPanel, [1 2]);
            paramGrid.ColumnWidth = {'fit', '1x'};
            
            % 半径参数设置
            uilabel(paramGrid, 'Text', '半径：');
            app.LBPRadiusSpinner = uispinner(paramGrid, ...
                'Value', 1, ...
                'Limits', [1 3], ...
                'Step', 1);
            
            % HOG特征组
            hogGroup = uipanel(grid);
            hogGroup.Title = 'HOG特征提取';
            
            hgrid = uigridlayout(hogGroup, [3 1]);
            hgrid.RowHeight = {'fit', 'fit', 'fit'};
            hgrid.Padding = [5 5 5 5];
            
            % HOG特征提取按钮
            uibutton(hgrid, 'Text', 'HOG特征提取', ...
                'ButtonPushedFcn', @(btn,event) app.extractHOGFeatures());
            
            % HOG参数设置面板
            hogParamPanel = uipanel(hgrid);
            hogParamGrid = uigridlayout(hogParamPanel, [1 2]);
            hogParamGrid.ColumnWidth = {'fit', '1x'};
            
            % 单元格大小设置
            uilabel(hogParamGrid, 'Text', '单元格大小：');
            app.HOGCellSizeSpinner = uispinner(hogParamGrid, ...
                'Value', 8, ...
                'Limits', [4 16], ...
                'Step', 4);
            
            % 特征可视化组
            visualGroup = uipanel(grid);
            visualGroup.Title = '特征可视化';
            
            vgrid = uigridlayout(visualGroup, [2 1]);
            vgrid.RowHeight = {'fit', 'fit'};
            vgrid.Padding = [5 5 5 5];
            
            % 显示特征图按钮
            uibutton(vgrid, 'Text', '显示LBP特征图', ...
                'ButtonPushedFcn', @(btn,event) app.showLBPFeatureImage());
            
            uibutton(vgrid, 'Text', '显示HOG特征图', ...
                'ButtonPushedFcn', @(btn,event) app.showHOGFeatureImage());
        end
        
        function createDeepLearningTab(app)
            tab = uitab(app.ControlPanel, 'Title', '深度学习分类');
            
            % 创建网格布局
            grid = uigridlayout(tab, [6 1]);
            grid.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit'};
            grid.Padding = [10 10 10 10];
            grid.RowSpacing = 10;
            
            % 模型操作组
            modelGroup = uipanel(grid);
            modelGroup.Title = '模型操作';
            
            mgrid = uigridlayout(modelGroup, [2 1]);
            mgrid.RowHeight = {'fit', 'fit'};
            mgrid.Padding = [5 5 5 5];
            
            uibutton(mgrid, 'Text', '加载模型', ...
                'ButtonPushedFcn', @(btn,event) app.updateStatus('正在加载深度学习模型...'));
            
            uibutton(mgrid, 'Text', '开始分类', ...
                'ButtonPushedFcn', @(btn,event) app.updateStatus('正在进行图像分类...'));
            
            % 分类结果显示
            resultGroup = uipanel(grid);
            resultGroup.Title = '分类结果';
            
            rgrid = uigridlayout(resultGroup, [2 1]);
            rgrid.RowHeight = {'fit', 'fit'};
            rgrid.Padding = [5 5 5 5];
            
            uilabel(rgrid, 'Text', '分类类别：', 'FontWeight', 'bold');
            uilabel(rgrid, 'Text', '等待分类...');
            
            % 置信度显示
            confidenceGroup = uipanel(grid);
            confidenceGroup.Title = '置信度';
            
            cgrid = uigridlayout(confidenceGroup, [1 1]);
            cgrid.Padding = [5 5 5 5];
            
            gauge = uigauge(cgrid, 'Limits', [0 100]);
            gauge.Value = 0;
        end
        
        function updateStatus(app, message)
            % 更新状态栏信息
            app.StatusLabel.Text = ['状态：', message];
            drawnow;
        end
        
        function updateImageInfo(app, info)
            % 更新图像信息
            app.ImageInfoLabel.Text = ['图像信息：', info];
            drawnow;
        end
        
        % 图像处理方法
        function openImage(app)
            % 打开图像文件
            try
                app.updateStatus('正在打开图像...');
                [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', '图像文件 (*.jpg,*.jpeg,*.png,*.bmp)'});
                if filename ~= 0
                    fullpath = fullfile(pathname, filename);
                    app.OriginalImage = imread(fullpath);
                    
                    % 如果是彩色图像，转换为灰度图
                    if size(app.OriginalImage, 3) == 3
                        app.OriginalImage = rgb2gray(app.OriginalImage);
                    end
                    
                    % 显示原始图像
                    imshow(app.OriginalImage, [], 'Parent', app.OriginalAxes);
                    
                    % 更新图像信息
                    [h, w] = size(app.OriginalImage);
                    app.updateImageInfo(sprintf('尺寸: %dx%d  类型: %s', w, h, class(app.OriginalImage)));
                    app.updateStatus('图像加载完成');
                    
                    % 绘制直方图
                    app.plotHistogram(app.OriginalImage);
                end
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function saveImage(app)
            % 保存处理后的图像
            try
                if isempty(app.ProcessedImage)
                    app.ProcessedImage = app.OriginalImage;
                end
                
                app.updateStatus('正在保存图像...');
                [filename, pathname] = uiputfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg,*.png,*.bmp)'});
                
                if filename ~= 0
                    fullpath = fullfile(pathname, filename);
                    imwrite(app.ProcessedImage, fullpath);
                    app.updateStatus('图像保存完成');
                end
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function normalizeImage(app)
            % 手动实现图像归一化
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行图像归一化...');
                
                % 转换为double类型进行处理
                img = double(app.OriginalImage);
                
                % 手动找最大最小值
                minVal = min(img(:));
                maxVal = max(img(:));
                
                % 归一化处理
                if maxVal > minVal
                    normalizedImg = (img - minVal) / (maxVal - minVal);
                else
                    normalizedImg = zeros(size(img));
                end
                
                % 转回uint8类型（0-255范围）
                app.ProcessedImage = uint8(normalizedImg * 255);
                
                % 显示处理后的图像
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('图像归一化完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function equalizeHistogram(app)
            % 手动实现直方图均衡化
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行直方图均衡化...');
                
                % 计算直方图
                hist = zeros(1, 256);
                [h, w] = size(app.OriginalImage);
                totalPixels = h * w;
                
                % 统计每个灰度级的像素数
                for i = 1:h
                    for j = 1:w
                        intensity = app.OriginalImage(i,j) + 1; % MATLAB索引从1开始
                        hist(intensity) = hist(intensity) + 1;
                    end
                end
                
                % 计算累积分布函数
                cdf = zeros(1, 256);
                cdf(1) = hist(1);
                for i = 2:256
                    cdf(i) = cdf(i-1) + hist(i);
                end
                
                % 归一化CDF
                cdf = cdf / totalPixels;
                
                % 创建均衡化查找表
                lookupTable = uint8(cdf * 255);
                
                % 应用查找表进行均衡化
                app.ProcessedImage = zeros(size(app.OriginalImage), 'uint8');
                for i = 1:h
                    for j = 1:w
                        intensity = app.OriginalImage(i,j) + 1;
                        app.ProcessedImage(i,j) = lookupTable(intensity);
                    end
                end
                
                % 显示处理后的图像
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('直方图均衡化完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % 参数更新方法
        function updateLogParam(app, value)
            app.LogParam = value;
        end
        
        function updateExpParam(app, value)
            app.ExpParam = value;
        end
        
        function updateStretchMin(app, value)
            app.StretchMin = value;
        end
        
        function updateStretchMax(app, value)
            app.StretchMax = value;
        end
        
        function updateGammaParam(app, value)
            app.GammaParam = value;
        end
        
        % 图像增强方法
        function logTransform(app)
            % 对数变换 s = c * log(1 + r)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行对数变换...');
                
                % 归一化到[0,1]
                normalizedImg = double(app.OriginalImage) / 255;
                
                % 对数变换
                c = app.LogParam;
                transformedImg = c * log(1 + normalizedImg);
                
                % 归一化回[0,255]
                maxVal = max(transformedImg(:));
                if maxVal > 0
                    transformedImg = transformedImg / maxVal * 255;
                end
                
                app.ProcessedImage = uint8(transformedImg);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('对数变换完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function exponentialTransform(app)
            % 指数变换 s = r^b
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行指数变换...');
                
                % 归一化到[0,1]
                normalizedImg = double(app.OriginalImage) / 255;
                
                % 指数变换
                b = app.ExpParam;
                transformedImg = normalizedImg .^ b;
                
                % 转换回[0,255]
                transformedImg = transformedImg * 255;
                
                app.ProcessedImage = uint8(transformedImg);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('指数变换完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function linearStretch(app)
            % 线性拉伸
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行线性拉伸...');
                
                % 获取当前图像的最大最小值
                img = double(app.OriginalImage);
                
                % 按设定范围进行拉伸
                minVal = app.StretchMin;
                maxVal = app.StretchMax;
                
                if maxVal <= minVal
                    app.updateStatus('错误：最大值必须大于最小值');
                    return;
                end
                
                % 线性拉伸公式：(x - min) * (newMax - newMin) / (max - min) + newMin
                stretchedImg = (img - minVal) * (255 / (maxVal - minVal));
                
                % 限制在[0,255]范围内
                stretchedImg = min(max(stretchedImg, 0), 255);
                
                app.ProcessedImage = uint8(stretchedImg);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('线性拉伸完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function gammaCorrection(app)
            % 伽马校正 s = r^gamma
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行伽马校正...');
                
                % 归一化到[0,1]
                normalizedImg = double(app.OriginalImage) / 255;
                
                % 伽马变换
                gamma = app.GammaParam;
                correctedImg = normalizedImg .^ gamma;
                
                % 转换回[0,255]
                correctedImg = correctedImg * 255;
                
                app.ProcessedImage = uint8(correctedImg);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('伽马校正完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        function plotHistogram(app, img)
            % 绘制直方图
            histogram(app.HistogramAxes, double(img(:)), 'BinLimits', [0,255], 'NumBins', 256);
            title(app.HistogramAxes, '灰度直方图');
            xlabel(app.HistogramAxes, '灰度值');
            ylabel(app.HistogramAxes, '像素数量');
            grid(app.HistogramAxes, 'on');
        end
        
        % 高斯滤波实现
        function gaussianFilter(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行高斯滤波...');
                
                % 获取当前选择的核大小
                kernelSizeStr = app.KernelSizeDropDown.Value;
                kernelSize = str2double(kernelSizeStr(1));
                
                % 生成高斯滤波核
                sigma = 1.0; % 可调整的高斯函数标准差
                kernel = zeros(kernelSize, kernelSize);
                center = floor(kernelSize/2);
                
                for i = 1:kernelSize
                    for j = 1:kernelSize
                        x = i - (center + 1);
                        y = j - (center + 1);
                        kernel(i,j) = exp(-(x^2 + y^2)/(2*sigma^2));
                    end
                end
                
                % 归一化滤波核
                kernel = kernel / sum(kernel(:));
                
                % 应用滤波器
                [height, width] = size(app.OriginalImage);
                paddedImage = zeros(height + kernelSize - 1, width + kernelSize - 1);
                padding = floor(kernelSize/2);
                paddedImage(padding+1:padding+height, padding+1:padding+width) = double(app.OriginalImage);
                
                result = zeros(height, width);
                
                % 执行卷积
                for i = 1:height
                    for j = 1:width
                        window = paddedImage(i:i+kernelSize-1, j:j+kernelSize-1);
                        result(i,j) = sum(sum(window .* kernel));
                    end
                end
                
                % 转换回uint8类型
                app.ProcessedImage = uint8(result);
                
                % 显示处理后的图像
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('高斯滤波完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % 中值滤波实现
        function medianFilter(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行中值滤波...');
                
                % 获取当前选择的核大小
                kernelSizeStr = app.KernelSizeDropDown.Value;
                kernelSize = str2double(kernelSizeStr(1));
                
                [height, width] = size(app.OriginalImage);
                padding = floor(kernelSize/2);
                
                % 初始化结果图像
                result = zeros(height, width);
                
                % 对图像进行边界扩展
                paddedImage = zeros(height + kernelSize - 1, width + kernelSize - 1);
                paddedImage(padding+1:padding+height, padding+1:padding+width) = app.OriginalImage;
                
                % 执行中值滤波
                for i = 1:height
                    for j = 1:width
                        % 提取当前窗口
                        window = paddedImage(i:i+kernelSize-1, j:j+kernelSize-1);
                        % 计算中值
                        windowValues = window(:);
                        sortedValues = sort(windowValues);
                        result(i,j) = sortedValues(ceil(length(sortedValues)/2));
                    end
                end
                
                % 转换回uint8类型
                app.ProcessedImage = uint8(result);
                
                % 显示处理后的图像
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('中值滤波完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % 均值滤波实现
        function meanFilter(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行均值滤波...');
                
                % 获取当前选择的核大小
                kernelSizeStr = app.KernelSizeDropDown.Value;
                kernelSize = str2double(kernelSizeStr(1));
                
                % 创建均值滤波核（所有元素权重相同）
                kernel = ones(kernelSize, kernelSize) / (kernelSize * kernelSize);
                
                [height, width] = size(app.OriginalImage);
                padding = floor(kernelSize/2);
                
                % 初始化结果图像
                result = zeros(height, width);
                
                % 对图像进行边界扩展
                paddedImage = zeros(height + kernelSize - 1, width + kernelSize - 1);
                paddedImage(padding+1:padding+height, padding+1:padding+width) = double(app.OriginalImage);
                
                % 执行均值滤波（卷积）
                for i = 1:height
                    for j = 1:width
                        window = paddedImage(i:i+kernelSize-1, j:j+kernelSize-1);
                        result(i,j) = sum(sum(window .* kernel));
                    end
                end
                
                % 转换回uint8类型
                app.ProcessedImage = uint8(result);
                
                % 显示处理后的图像
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('均值滤波完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % Roberts算子实现
        function robertsEdgeDetection(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行Roberts边缘检测...');
                
                % 获取阈值
                threshold = app.EdgeThresholdSlider.Value;
                
                % Roberts算子定义
                robertsX = [1 0; 0 -1];  % x方向
                robertsY = [0 1; -1 0];  % y方向
                
                % 获取图像尺寸
                [height, width] = size(app.OriginalImage);
                
                % 初始化结果图像
                gradientX = zeros(height, width);
                gradientY = zeros(height, width);
                
                % 图像填充
                paddedImage = double([app.OriginalImage zeros(height,1); zeros(1,width+1)]);
                
                % 应用Roberts算子
                for i = 1:height
                    for j = 1:width
                        % 提取2x2窗口
                        window = paddedImage(i:i+1, j:j+1);
                        
                        % 计算x和y方向的梯度
                        gradientX(i,j) = sum(sum(window .* robertsX));
                        gradientY(i,j) = sum(sum(window .* robertsY));
                    end
                end
                
                % 计算梯度幅值
                gradient = sqrt(gradientX.^2 + gradientY.^2);
                
                % 归一化到[0,1]
                gradient = gradient / max(gradient(:));
                
                % 应用阈值
                app.ProcessedImage = uint8(gradient > threshold) * 255;
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.updateStatus('Roberts边缘检测完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % Prewitt算子实现
        function prewittEdgeDetection(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行Prewitt边缘检测...');
                
                % 获取阈值
                threshold = app.EdgeThresholdSlider.Value;
                
                % Prewitt算子定义
                prewittX = [-1 0 1; -1 0 1; -1 0 1];  % x方向
                prewittY = [-1 -1 -1; 0 0 0; 1 1 1];  % y方向
                
                % 获取图像尺寸
                [height, width] = size(app.OriginalImage);
                
                % 初始化结果图像
                gradientX = zeros(height-2, width-2);
                gradientY = zeros(height-2, width-2);
                
                % 转换为double类型进行计算
                img = double(app.OriginalImage);
                
                % 应用Prewitt算子
                for i = 2:height-1
                    for j = 2:width-1
                        % 提取3x3窗口
                        window = img(i-1:i+1, j-1:j+1);
                        
                        % 计算x和y方向的梯度
                        gradientX(i-1,j-1) = sum(sum(window .* prewittX));
                        gradientY(i-1,j-1) = sum(sum(window .* prewittY));
                    end
                end
                
                % 计算梯度幅值
                gradient = sqrt(gradientX.^2 + gradientY.^2);
                
                % 归一化到[0,1]
                gradient = gradient / max(gradient(:));
                
                % 创建输出图像并应用阈值
                output = zeros(height, width);
                output(2:height-1, 2:width-1) = gradient;
                app.ProcessedImage = uint8(output > threshold) * 255;
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.updateStatus('Prewitt边缘检测完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % Sobel算子实现
        function sobelEdgeDetection(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行Sobel边缘检测...');
                
                % 获取阈值
                threshold = app.EdgeThresholdSlider.Value;
                
                % Sobel算子定义
                sobelX = [-1 0 1; -2 0 2; -1 0 1];  % x方向
                sobelY = [-1 -2 -1; 0 0 0; 1 2 1];  % y方向
                
                % 获取图像尺寸
                [height, width] = size(app.OriginalImage);
                
                % 初始化结果图像
                gradientX = zeros(height-2, width-2);
                gradientY = zeros(height-2, width-2);
                
                % 转换为double类型进行计算
                img = double(app.OriginalImage);
                
                % 应用Sobel算子
                for i = 2:height-1
                    for j = 2:width-1
                        % 提取3x3窗口
                        window = img(i-1:i+1, j-1:j+1);
                        
                        % 计算x和y方向的梯度
                        gradientX(i-1,j-1) = sum(sum(window .* sobelX));
                        gradientY(i-1,j-1) = sum(sum(window .* sobelY));
                    end
                end
                
                % 计算梯度幅值
                gradient = sqrt(gradientX.^2 + gradientY.^2);
                
                % 归一化到[0,1]
                gradient = gradient / max(gradient(:));
                
                % 创建输出图像并应用阈值
                output = zeros(height, width);
                output(2:height-1, 2:width-1) = gradient;
                app.ProcessedImage = uint8(output > threshold) * 255;
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.updateStatus('Sobel边缘检测完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % Laplace算子实现
        function laplaceEdgeDetection(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行Laplace边缘检测...');
                
                % 获取阈值
                threshold = app.EdgeThresholdSlider.Value;
                
                % Laplace算子定义（8邻域）
                laplace = [0 1 0; 1 -4 1; 0 1 0];
                
                % 获取图像尺寸
                [height, width] = size(app.OriginalImage);
                
                % 初始化结果图像
                result = zeros(height-2, width-2);
                
                % 转换为double类型进行计算
                img = double(app.OriginalImage);
                
                % 应用Laplace算子
                for i = 2:height-1
                    for j = 2:width-1
                        % 提取3x3窗口
                        window = img(i-1:i+1, j-1:j+1);
                        
                        % 计算拉普拉斯算子响应
                        result(i-1,j-1) = abs(sum(sum(window .* laplace)));
                    end
                end
                
                % 归一化到[0,1]
                result = result / max(result(:));
                
                % 创建输出图像并应用阈值
                output = zeros(height, width);
                output(2:height-1, 2:width-1) = result;
                app.ProcessedImage = uint8(output > threshold) * 255;
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.updateStatus('Laplace边缘检测完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % LBP特征提取实现
        function extractLBPFeatures(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行LBP特征提取...');
                
                % 获取LBP参数
                radius = app.LBPRadiusSpinner.Value;  % 从Spinner控件获取值
                neighbors = 8;  % 固定使用8个邻域点
                
                % 获取图像尺寸
                img = double(app.OriginalImage);
                [height, width] = size(img);
                
                % 初始化结果图像
                result = zeros(height, width);
                
                % 计算邻域点的坐标偏移
                angles = (0:neighbors-1) * 2 * pi / neighbors;
                x_offsets = radius * cos(angles);
                y_offsets = radius * sin(angles);
                
                % 图像边界填充
                padded_img = padarray(img, [radius radius], 'replicate');
                
                % 对每个像素计算LBP值
                for i = 1+radius:height+radius
                    for j = 1+radius:width+radius
                        % 中心像素值
                        center = padded_img(i, j);
                        lbp_code = 0;
                        
                        % 计算8个邻域点的LBP值
                        for k = 1:neighbors
                            % 计算邻域点坐标
                            y = i + round(y_offsets(k));
                            x = j + round(x_offsets(k));
                            
                            % 与中心像素比较
                            if padded_img(y, x) >= center
                                lbp_code = lbp_code + 2^(k-1);
                            end
                        end
                        
                        % 存储LBP值
                        result(i-radius, j-radius) = lbp_code;
                    end
                end
                
                % 归一化到0-255范围
                result = result / max(result(:)) * 255;
                app.ProcessedImage = uint8(result);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('LBP特征提取完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % HOG特征提取实现
        function extractHOGFeatures(app)
            try
                if isempty(app.OriginalImage)
                    app.updateStatus('请先加载图像');
                    return;
                end
                
                app.updateStatus('正在进行HOG特征提取...');
                
                % 获取参数 - 修正属性名称
                cellSize = app.HOGCellSizeSpinner.Value;  % 使用正确的Spinner属性名
                
                % 将图像转换为double类型
                img = double(app.OriginalImage);
                [height, width] = size(img);
                
                % 计算梯度
                [gx, gy] = app.computeGradient(img);
                
                % 计算梯度幅值和方向
                magnitude = sqrt(gx.^2 + gy.^2);
                theta = atan2d(gy, gx);  % 计算角度（度数）
                % 将角度转换到0-180度范围
                theta(theta < 0) = theta(theta < 0) + 180;
                
                % 计算每个cell的尺寸
                numCellsY = floor(height/cellSize);
                numCellsX = floor(width/cellSize);
                
                % 方向直方图的bin数（0-180度分成9个bin）
                numBins = 9;
                binSize = 180/numBins;
                
                % 初始化HOG特征图
                hogFeatures = zeros(numCellsY, numCellsX);
                
                % 对每个cell计算HOG特征
                for i = 1:numCellsY
                    for j = 1:numCellsX
                        % 当前cell的范围
                        rowStart = (i-1)*cellSize + 1;
                        rowEnd = min(i*cellSize, height);
                        colStart = (j-1)*cellSize + 1;
                        colEnd = min(j*cellSize, width);
                        
                        % 提取当前cell的梯度和方向
                        cellMagnitude = magnitude(rowStart:rowEnd, colStart:colEnd);
                        cellTheta = theta(rowStart:rowEnd, colStart:colEnd);
                        
                        % 计算方向直方图
                        hist = zeros(1, numBins);
                        for bin = 1:numBins
                            binStart = (bin-1)*binSize;
                            binEnd = bin*binSize;
                            binMask = (cellTheta >= binStart) & (cellTheta < binEnd);
                            hist(bin) = sum(cellMagnitude(binMask));
                        end
                        
                        % 保存主方向
                        [~, maxBin] = max(hist);
                        hogFeatures(i,j) = maxBin;
                    end
                end
                
                % 将HOG特征可视化
                hogFeatures = hogFeatures / numBins;  % 归一化到0-1
                
                % 将特征图调整到原始图像大小
                resizedHOG = imresize(hogFeatures, [height, width], 'nearest');
                
                % 转换为uint8类型显示
                app.ProcessedImage = uint8(resizedHOG * 255);
                
                % 显示结果
                imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
                app.plotHistogram(app.ProcessedImage);
                
                app.updateStatus('HOG特征提取完成');
            catch ex
                app.updateStatus(['错误：', ex.message]);
            end
        end
        
        % 计算图像梯度的辅助函数
        function [gx, gy] = computeGradient(~, image)
            % 使用[-1 0 1]和[-1 0 1]'计算水平和垂直梯度
            gx = zeros(size(image));
            gy = zeros(size(image));
            
            % 计算x方向梯度
            gx(:,2:end-1) = image(:,3:end) - image(:,1:end-2);
            
            % 计算y方向梯度
            gy(2:end-1,:) = image(3:end,:) - image(1:end-2,:);
        end
        
        % 显示LBP特征图
        function showLBPFeatureImage(app)
            if isempty(app.LBPFeatureImage)
                app.updateStatus('请先提取LBP特征');
                return;
            end
            app.ProcessedImage = app.LBPFeatureImage;
            imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
            app.updateStatus('显示LBP特征图');
        end
        
        % 显示HOG特征图
        function showHOGFeatureImage(app)
            if isempty(app.HOGFeatureImage)
                app.updateStatus('请先提取HOG特征');
                return;
            end
            app.ProcessedImage = uint8(imresize(app.HOGFeatureImage, size(app.OriginalImage)) * 255);
            imshow(app.ProcessedImage, [], 'Parent', app.ProcessedAxes);
            app.updateStatus('显示HOG特征图');
        end
    end
end