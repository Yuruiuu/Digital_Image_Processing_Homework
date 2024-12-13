function edge_image = robert_operator(image)
    % 输入:
    % image: 原始图像 (灰度图像)
    % 输出:
    % edge_image: 边缘检测后的图像

    % 定义 Robert 算子
    Gx = [1 0; 0 -1]; % 水平方向
    Gy = [0 1; -1 0]; % 垂直方向

    [rows, cols] = size(image);
    edge_image = zeros(rows - 1, cols - 1);

    % 进行卷积
    for i = 1:rows-1
        for j = 1:cols-1
            region = double(image(i:i+1, j:j+1));
            gx = sum(sum(region .* Gx));
            gy = sum(sum(region .* Gy));
            edge_image(i, j) = sqrt(gx^2 + gy^2); % 合成梯度
        end
    end

    % 归一化到 0~255 范围
    edge_image = uint8(255 * mat2gray(edge_image));
end
