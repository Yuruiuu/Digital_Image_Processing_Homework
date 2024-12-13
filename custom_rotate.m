function rotated_image = custom_rotate(image, angle)
    % 输入:
    % image: 原始图像
    % angle: 旋转角度 (单位: 度)
    % 输出:
    % rotated_image: 旋转后的图像

    % 将角度转换为弧度
    theta = deg2rad(angle);

    % 获取原始图像尺寸
    [rows, cols, channels] = size(image);

    % 计算图像中心
    center_x = (cols + 1) / 2;
    center_y = (rows + 1) / 2;

    % 计算旋转后图像的尺寸（保持原图大小）
    rotated_image = zeros(rows, cols, channels, 'uint8');

    % 遍历目标图像的每个像素
    for c = 1:channels
        for i = 1:rows
            for j = 1:cols
                % 目标像素到中心的偏移量
                x_shift = j - center_x;
                y_shift = i - center_y;

                % 计算原图中的位置 (逆映射)
                original_x = center_x + (x_shift * cos(theta) + y_shift * sin(theta));
                original_y = center_y + (-x_shift * sin(theta) + y_shift * cos(theta));

                % 最近邻插值
                x_nearest = round(original_x);
                y_nearest = round(original_y);

                % 边界检查
                if x_nearest >= 1 && x_nearest <= cols && y_nearest >= 1 && y_nearest <= rows
                    rotated_image(i, j, c) = image(y_nearest, x_nearest, c);
                end
            end
        end
    end
end
