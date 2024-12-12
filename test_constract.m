% 加载图像
original_image = imread('D:\pics\woman.jpg'); % 替换为你的文件路径

% 灰度化
if size(original_image, 3) == 3
    gray_image = custom_grayscale(original_image);
else
    gray_image = original_image;
end

% 对比度增强 (线性变换)
a = 1.2; % 增强比例
b = 30;  % 偏移值
contrast_image = contrast_enhance(gray_image, a, b);

% 对数变换
c_log = 50; % 缩放因子
log_image = log_transform(gray_image, c_log);

% 指数变换
c_exp = 10; % 缩放因子
exp_image = exp_transform(gray_image, c_exp);

% 显示结果
figure;
subplot(2, 3, 1); imshow(original_image); title('Original Image');
subplot(2, 3, 2); imshow(gray_image); title('Grayscale Image');
subplot(2, 3, 3); imshow(contrast_image); title('Contrast Enhanced');
subplot(2, 3, 4); imshow(log_image); title('Log Transform');
subplot(2, 3, 5); imshow(exp_image); title('Exp Transform');
