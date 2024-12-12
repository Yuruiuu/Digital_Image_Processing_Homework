function [histogram, equalized_image, matched_image] = custom_histogram(image, target_image)
    % 输入:
    % image: 原始图像 (灰度图)
    % target_image: 目标图像 (用于直方图匹配)
    % 输出:
    % histogram: 原始图像的直方图
    % equalized_image: 直方图均衡化后的图像
    % matched_image: 直方图匹配后的图像

    % 1. 计算原始图像灰度直方图
    histogram = compute_histogram(image);

    % 2. 实现直方图均衡化
    equalized_image = histogram_equalization(image, histogram);

    % 3. 实现直方图匹配
    if nargin == 2 % 如果提供了目标图像
        target_histogram = compute_histogram(target_image);
        matched_image = histogram_matching(image, histogram, target_histogram);
    else
        matched_image = [];
    end
end

%% 子函数1: 计算灰度直方图
function hist = compute_histogram(image)
    % 初始化灰度值频率
    hist = zeros(1, 256);
    [rows, cols] = size(image);

    % 遍历每个像素并统计灰度频率
    for i = 1:rows
        for j = 1:cols
            gray_value = image(i, j);
            hist(gray_value + 1) = hist(gray_value + 1) + 1;
        end
    end

    % 归一化为概率分布
    hist = hist / (rows * cols);
end

%% 子函数2: 直方图均衡化
function equalized_image = histogram_equalization(image, hist)
    % 累积分布函数 (CDF)
    cdf = cumsum(hist);

    % 构造均衡化后的灰度映射表
    mapping = uint8(255 * cdf);

    % 映射像素值
    [rows, cols] = size(image);
    equalized_image = zeros(rows, cols, 'uint8');
    for i = 1:rows
        for j = 1:cols
            gray_value = image(i, j);
            equalized_image(i, j) = mapping(gray_value + 1);
        end
    end
end

%% 子函数3: 直方图匹配
function matched_image = histogram_matching(image, source_hist, target_hist)
    % 累积分布函数 (CDF)
    source_cdf = cumsum(source_hist);
    target_cdf = cumsum(target_hist);

    % 计算匹配映射表
    mapping = zeros(256, 1, 'uint8');
    for src_gray = 1:256
        [~, tgt_gray] = min(abs(target_cdf - source_cdf(src_gray)));
        mapping(src_gray) = tgt_gray - 1;
    end

    % 应用映射
    [rows, cols] = size(image);
    matched_image = zeros(rows, cols, 'uint8');
    for i = 1:rows
        for j = 1:cols
            gray_value = image(i, j);
            matched_image(i, j) = mapping(gray_value + 1);
        end
    end
end
