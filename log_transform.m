function log_image = log_transform(image, c)
    % 输入: image (灰度图像)
    %        c: 对数变换的缩放因子
    % 输出: log_image (对数变换后的图像)

    % 确保输入是 double 类型
    image = double(image);

    % 应用对数变换
    log_image = c * log(1 + image);

    % 归一化到 [0, 255]
    log_image = log_image / max(log_image(:)) * 255;

    % 转换为 uint8 类型
    log_image = uint8(log_image);
end