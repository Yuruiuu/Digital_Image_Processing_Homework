addpath('D:\matlab\homework\Digital_Image_Processing_Homework');
% 读取灰度图像
original_image = imread('D:\pics\woman.jpg'); % 替换为实际路径
if size(original_image, 3) == 3
    gray_image = rgb2gray(original_image);
else
    gray_image = original_image;
end

% 添加高斯噪声
noisy_image = custom_add_noise(gray_image, 'gaussian', 0, 20);

% 空域滤波
mean_filtered = custom_mean_filter(noisy_image, 3); % 均值滤波
median_filtered = custom_median_filter(noisy_image, 3); % 中值滤波

% 频域滤波
low_pass_filtered = custom_low_pass_filter(noisy_image, 0.1); % 低通滤波
high_pass_filtered = custom_high_pass_filter(noisy_image, 0.1); % 高通滤波

% 显示结果
figure;
subplot(2, 3, 1); imshow(gray_image); title('Original Image');
subplot(2, 3, 2); imshow(noisy_image); title('Noisy Image');
subplot(2, 3, 3); imshow(mean_filtered); title('Mean Filtered');
subplot(2, 3, 4); imshow(median_filtered); title('Median Filtered');
subplot(2, 3, 5); imshow(low_pass_filtered); title('Low Pass Filtered');
subplot(2, 3, 6); imshow(high_pass_filtered); title('High Pass Filtered');
