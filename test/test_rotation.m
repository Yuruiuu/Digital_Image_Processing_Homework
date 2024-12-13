% 读取原始图像
original_image = imread('D:\pics\woman.jpg'); % 替换为你的图像路径

% 图像缩放
scale_x = 0.2; % 水平方向缩放比例
scale_y = 0.2; % 垂直方向缩放比例
scaled_image = custom_resize(original_image, scale_x, scale_y);

% 图像旋转
rotation_angle = 45; % 旋转角度 (度)
rotated_image = custom_rotate(original_image, rotation_angle);

% 显示结果
figure;
subplot(1, 3, 1); imshow(original_image); title('Original Image');
subplot(1, 3, 2); imshow(scaled_image); title('Scaled Image');
subplot(1, 3, 3); imshow(rotated_image); title('Rotated Image');
