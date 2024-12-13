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