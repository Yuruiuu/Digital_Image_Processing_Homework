% 读取原始图像
original_image = imread('D:\pics\woman.jpg'); % 替换为你的图像路径
if size(original_image, 3) == 3
    gray_image = rgb2gray(original_image); % 转为灰度图
else
    gray_image = original_image;
end

% 添加高斯噪声
mean = 0; % 高斯噪声均值
std = 20; % 高斯噪声标准差
gaussian_noisy_image = custom_add_noise(gray_image, 'gaussian', mean, std);

% 添加椒盐噪声
density = 0.05; % 椒盐噪声密度
salt_pepper_noisy_image = custom_add_noise(gray_image, 'salt & pepper', density);

% 显示结果
figure;
subplot(1, 3, 1); imshow(gray_image); title('Original Image');
subplot(1, 3, 2); imshow(gaussian_noisy_image); title('Gaussian Noise');
subplot(1, 3, 3); imshow(salt_pepper_noisy_image); title('Salt & Pepper Noise');
