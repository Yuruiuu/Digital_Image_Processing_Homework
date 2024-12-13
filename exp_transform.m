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