% 读取灰度图像
original_image = imread('D:\pics\woman.jpg'); % 替换为你的图像路径
if size(original_image, 3) == 3
    gray_image = rgb2gray(original_image);
else
    gray_image = original_image;
end

% 使用不同算子进行边缘检测
robert_edge = robert_operator(gray_image);
prewitt_edge = prewitt_operator(gray_image);
sobel_edge = sobel_operator(gray_image);
laplacian_edge = laplacian_operator(gray_image);

% 显示结果
figure;
subplot(2, 3, 1); imshow(gray_image); title('Original Image');
subplot(2, 3, 2); imshow(robert_edge); title('Robert Operator');
subplot(2, 3, 3); imshow(prewitt_edge); title('Prewitt Operator');
subplot(2, 3, 4); imshow(sobel_edge); title('Sobel Operator');
subplot(2, 3, 5); imshow(laplacian_edge); title('Laplacian Operator');
