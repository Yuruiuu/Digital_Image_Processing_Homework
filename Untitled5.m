% 读取图像并转换为灰度图像
img = imread("D:\pics\chedao.jpg");
img_gray = rgb2gray(img);  % 转为灰度图像

% 将图像转换为双精度格式，方便计算
img_gray = double(img_gray);

% 获取图像大小
[m, n] = size(img_gray);

% 定义Prewitt算子
Gx = [-1 0 1; -1 0 1; -1 0 1];
Gy = [-1 -1 -1; 0 0 0; 1 1 1];

% 初始化梯度矩阵
grad_x = zeros(m, n);
grad_y = zeros(m, n);

% 计算梯度
for i = 2:m-1
    for j = 2:n-1
        % 提取3x3邻域
        region = img_gray(i-1:i+1, j-1:j+1);
        
        % 计算Gx和Gy
        grad_x(i, j) = sum(sum(region .* Gx));
        grad_y(i, j) = sum(sum(region .* Gy));
    end
end

% 计算梯度幅值
grad_magnitude = sqrt(grad_x.^2 + grad_y.^2);

% 边缘检测：二值化处理，去除弱边缘
threshold = 50;  % 设置阈值
edge_detected = grad_magnitude > threshold;

% 后处理：形态学膨胀操作，以增强车道线
se = strel('line', 5, 0);  % 创建结构元素（5像素长度，水平线）
edge_enhanced = imdilate(edge_detected, se);

% 显示结果
figure;

subplot(1, 3, 1);
imshow(uint8(img));
title('原始图像');

subplot(1, 3, 2);
imshow(uint8(grad_magnitude));
title('边缘幅值图');

subplot(1, 3, 3);
imshow(edge_enhanced);
title('增强后的车道线图');
