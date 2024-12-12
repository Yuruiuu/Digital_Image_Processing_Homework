function gray_image = custom_grayscale(image)
    % 输入: image (彩色图像)
    % 输出: gray_image (灰度图像)

    % 获取 RGB 通道
    R = double(image(:, :, 1));
    G = double(image(:, :, 2));
    B = double(image(:, :, 3));

    % 按照标准公式进行灰度化 (0.2989 * R + 0.5870 * G + 0.1140 * B)
    gray_image = uint8(0.2989 * R + 0.5870 * G + 0.1140 * B);
end

function enhanced_image = contrast_enhance(image, a, b)
    % 输入: image (灰度图像)
    %        a: 增强比例
    %        b: 偏移值
    % 输出: enhanced_image (增强后的图像)

    % 确保输入是 double 类型以进行运算
    image = double(image);

    % 线性变换
    enhanced_image = a * image + b;

    % 限制灰度值范围到 [0, 255]
    enhanced_image(enhanced_image > 255) = 255;
    enhanced_image(enhanced_image < 0) = 0;

    % 转换为 uint8 类型
    enhanced_image = uint8(enhanced_image);
end

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

function exp_image = exp_transform(image, c)
    % 输入: image (灰度图像)
    %        c: 指数变换的缩放因子
    % 输出: exp_image (指数变换后的图像)

    % 确保输入是 double 类型
    image = double(image);

    % 应用指数变换
    exp_image = c * (exp(image / 255) - 1);

    % 归一化到 [0, 255]
    exp_image = exp_image / max(exp_image(:)) * 255;

    % 转换为 uint8 类型
    exp_image = uint8(exp_image);
end
