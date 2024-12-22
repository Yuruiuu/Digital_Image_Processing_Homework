% 读取图像并转换为灰度图像
img = imread('your_image.jpg');
img_gray = rgb2gray(img);  % 转为灰度图像
img_gray = double(img_gray);  % 转为double类型进行处理

% 获取图像大小
[m, n] = size(img_gray);

% 定义高斯核（3x3窗口和sigma = 1）
sigma = 1;  % 高斯核的标准差
kernel_size = 3;  % 高斯核大小
[x, y] = meshgrid(-floor(kernel_size/2):floor(kernel_size/2), -floor(kernel_size/2):floor(kernel_size/2));

% 高斯核计算
gaussian_kernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
gaussian_kernel = gaussian_kernel / sum(gaussian_kernel(:));  % 归一化

% 应用高斯平滑
img_smooth = zeros(m, n);  % 初始化平滑后的图像
pad_size = floor(kernel_size / 2);  % 填充大小

% 对图像进行卷积（手动实现）
for i = 1+pad_size:m-pad_size
    for j = 1+pad_size:n-pad_size
        % 提取当前3x3区域
        region = img_gray(i-pad_size:i+pad_size, j-pad_size:j+pad_size);
        % 卷积运算
        img_smooth(i, j) = sum(sum(region .* gaussian_kernel));
    end
end

% 计算灰度差分统计
% 计算平滑前后的差异（绝对差）
diff_image = abs(img_gray - img_smooth);

% 统计灰度差分的最大值、最小值、均值和标准差
max_diff = max(diff_image(:));
min_diff = min(diff_image(:));
mean_diff = mean(diff_image(:));
std_diff = std(diff_image(:));

% 显示图像和差分统计
figure;

subplot(1, 3, 1);
imshow(uint8(img_gray));
title('Original Grayscale Image');

subplot(1, 3, 2);
imshow(uint8(img_smooth));
title('Smoothed Image');

subplot(1, 3, 3);
imshow(uint8(diff_image));
title('Difference Image');

% 显示灰度差分统计结果
disp(['Max difference: ', num2str(max_diff)]);
disp(['Min difference: ', num2str(min_diff)]);
disp(['Mean difference: ', num2str(mean_diff)]);
disp(['Std deviation of difference: ', num2str(std_diff)]);
