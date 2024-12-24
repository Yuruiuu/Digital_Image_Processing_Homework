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