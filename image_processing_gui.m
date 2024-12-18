function image_processing_gui
    % 图像处理与分类系统 GUI 主界面
    % 创建主窗口
    fig = figure('Name', '图像处理与分类系统', 'NumberTitle', 'off', ...
        'Position', [100, 100, 1200, 700], 'Color', [1, 1, 1]);

    % 1. 读入与显示图像
    uicontrol('Style', 'pushbutton', 'String', '上传图像', ...
        'Position', [450, 100, 100, 30], 'Callback', @upload_image);
    axes_read = axes('Units', 'pixels', 'Position', [100, 300, 300, 300]);
    title('读取图像');

    axes_processed = axes('Units', 'pixels', 'Position', [450, 300, 300, 300]);
    title('处理后图像');

    % 2. 处理操作按钮 (边缘提取、噪声、滤波等)
    uicontrol('Style', 'text', 'String', '边缘提取:', ...
        'Position', [50, 180, 80, 20], 'BackgroundColor', [1, 1, 1]);
    uicontrol('Style', 'pushbutton', 'String', 'robert算子', ...
        'Position', [50, 150, 80, 30], 'Callback', @(src, event) edge_process('robert'));
    uicontrol('Style', 'pushbutton', 'String', 'prewitt算子', ...
        'Position', [150, 150, 80, 30], 'Callback', @(src, event) edge_process('prewitt'));
    uicontrol('Style', 'pushbutton', 'String', 'sobel算子', ...
        'Position', [250, 150, 80, 30], 'Callback', @(src, event) edge_process('sobel'));

    % 3. 特征提取
    uicontrol('Style', 'pushbutton', 'String', 'LBP', ...
        'Position', [50, 100, 80, 30], 'Callback', @(src, event) extract_features('LBP'));
    uicontrol('Style', 'pushbutton', 'String', 'HOG', ...
        'Position', [150, 100, 80, 30], 'Callback', @(src, event) extract_features('HOG'));

    % 4. 输出结果区域
    axes_result = axes('Units', 'pixels', 'Position', [800, 300, 300, 300]);
    title('处理结果');

    % 5. 显示消息框
    uicontrol('Style', 'text', 'String', '结果输出:', ...
        'Position', [800, 180, 80, 20], 'BackgroundColor', [1, 1, 1]);
    output_box = uicontrol('Style', 'edit', 'Position', [800, 150, 300, 30], ...
        'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);

    % 初始化图像变量
    img = [];

    % ----------------------------------------
    % 子函数：上传图像
    function upload_image(~, ~)
        [file, path] = uigetfile({'*.*', 'All Files'});
        if file
            img = imread(fullfile(path, file));
            if size(img, 3) == 3
                img = rgb2gray(img); % 转为灰度图
            end
            axes(axes_read);
            imshow(img);
            title('读取的图像');
        end
    end

    % 子函数：边缘提取
    function edge_process(method)
        if isempty(img)
            msgbox('请先上传图像！', '错误', 'error');
            return;
        end
        switch method
            case 'robert'
                kernel_x = [1 0; 0 -1];
                kernel_y = [0 1; -1 0];
            case 'prewitt'
                kernel_x = [-1 0 1; -1 0 1; -1 0 1];
                kernel_y = [1 1 1; 0 0 0; -1 -1 -1];
            case 'sobel'
                kernel_x = [-1 0 1; -2 0 2; -1 0 1];
                kernel_y = [1 2 1; 0 0 0; -1 -2 -1];
        end
        grad_x = conv2(double(img), kernel_x, 'same');
        grad_y = conv2(double(img), kernel_y, 'same');
        edge_result = uint8(sqrt(grad_x.^2 + grad_y.^2));

        axes(axes_processed);
        imshow(edge_result, []);
        title([method ' 边缘检测']);
    end

    % 子函数：特征提取
    function extract_features(method)
        if isempty(img)
            msgbox('请先上传图像！', '错误', 'error');
            return;
        end
        switch method
            case 'LBP'
                features = extractLBPFeatures(img);
                feature_text = sprintf('LBP特征长度: %d', length(features));
            case 'HOG'
                features = extractHOGFeatures(img);
                feature_text = sprintf('HOG特征长度: %d', length(features));
        end
        set(output_box, 'String', feature_text);
    end
end
