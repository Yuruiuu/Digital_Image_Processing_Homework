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


