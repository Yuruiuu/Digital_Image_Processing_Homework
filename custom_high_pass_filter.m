function filtered_image = custom_high_pass_filter(image, cutoff)
    % 输入:
    % image: 原始图像 (灰度图)
    % cutoff: 截止频率 (0~1)
    % 输出:
    % filtered_image: 滤波后的图像

    % 将图像转换为频域
    [rows, cols] = size(image);
    F = fft2(double(image)); % 离散傅里叶变换
    F = fftshift(F); % 将零频移到中心

    % 生成高通滤波器
    [X, Y] = meshgrid(1:cols, 1:rows);
    center_x = ceil(cols / 2);
    center_y = ceil(rows / 2);
    radius = cutoff * min(rows, cols);
    mask = sqrt((X - center_x).^2 + (Y - center_y).^2) > radius;

    % 应用滤波器
    F_filtered = F .* mask;

    % 逆傅里叶变换
    F_filtered = ifftshift(F_filtered); % 将零频移回原位置
    filtered_image = abs(ifft2(F_filtered)); % 逆傅里叶变换
    filtered_image = uint8(filtered_image); % 转换为图像格式
end
