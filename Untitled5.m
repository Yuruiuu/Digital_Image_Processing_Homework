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