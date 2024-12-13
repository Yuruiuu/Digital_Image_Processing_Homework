function scaled_image = custom_resize(image, scale_x, scale_y)
    % 输入:
    % image: 原始图像 (灰度图或彩色图像)
    % scale_x: 水平方向的缩放比例 (放大 > 1, 缩小 < 1)
    % scale_y: 垂直方向的缩放比例 (放大 > 1, 缩小 < 1)
    % 输出:
    % scaled_image: 缩放后的图像

    % 获取原始图像尺寸
    [rows, cols, channels] = size(image);

    % 计算缩放后的图像尺寸
    new_rows = round(rows * scale_y);
    new_cols = round(cols * scale_x);

    % 初始化缩放后的图像
    scaled_image = zeros(new_rows, new_cols, channels, 'uint8');

    % 遍历缩放后图像的每个像素
    for c = 1:channels
        for new_i = 1:new_rows
            for new_j = 1:new_cols
                % 计算在原始图像中的位置 (逆映射)
                original_x = (new_j - 0.5) / scale_x + 0.5;
                original_y = (new_i - 0.5) / scale_y + 0.5;

                % 找到最近的像素
                x_nearest = round(original_x);
                y_nearest = round(original_y);

                % 边界检查
                if x_nearest >= 1 && x_nearest <= cols && y_nearest >= 1 && y_nearest <= rows
                    scaled_image(new_i, new_j, c) = image(y_nearest, x_nearest, c);
                end
            end
        end
    end
end
