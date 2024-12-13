function filtered_image = custom_median_filter(image, kernel_size)
    % 输入:
    % image: 原始图像
    % kernel_size: 滤波器的大小 (如 3 表示 3x3 滤波器)
    % 输出:
    % filtered_image: 滤波后的图像

    [rows, cols] = size(image);
    pad_size = floor(kernel_size / 2);

    % 使用边界扩展进行填充
    padded_image = zeros(rows + 2 * pad_size, cols + 2 * pad_size);
    padded_image(pad_size+1:end-pad_size, pad_size+1:end-pad_size) = image;

    % 初始化输出图像
    filtered_image = zeros(rows, cols);

    % 应用中值滤波
    for i = 1:rows
        for j = 1:cols
            region = padded_image(i:i+kernel_size-1, j:j+kernel_size-1);
            filtered_image(i, j) = median(region(:));
        end
    end

    % 转换为 uint8 类型
    filtered_image = uint8(filtered_image);
end
