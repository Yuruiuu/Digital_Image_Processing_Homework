% 读取原始图像与目标图像
original_image = imread("D:\pics\woman.jpg"); % 替换为实际文件路径
target_image = imread("D:\pics\woman_processed.jpg");   % 替换为目标图像路径

% 确保是灰度图
if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end
if size(target_image, 3) == 3
    target_image = rgb2gray(target_image);
end

% 调用主函数
[histogram, equalized_image, matched_image] = custom_histogram(original_image, target_image);

% 显示结果
figure;
subplot(2, 3, 1);
imshow(original_image);
title('Original Image');

subplot(2, 3, 2);
bar(0:255, histogram, 'k');
title('Original Histogram');

subplot(2, 3, 3);
imshow(equalized_image);
title('Equalized Image');

subplot(2, 3, 4);
imshow(target_image);
title('Target Image');

subplot(2, 3, 5);
imshow(matched_image);
title('Matched Image');
