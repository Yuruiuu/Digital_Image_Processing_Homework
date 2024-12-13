function edge_image = laplacian_operator(image)
    % 输入:
    % image: 原始图像 (灰度图像)
    % 输出:
    % edge_image: 边缘检测后的图像

    % 定义拉普拉斯算子
    Laplacian = [0 -1 0; -1 4 -1; 0 -1 0];

    [rows, cols] = size(image);
    edge_image = zeros(rows - 2, cols - 2);

    % 进行卷积
    for i = 1:rows-2
        for j = 1:cols-2
            region = double(image(i:i+2, j:j+2));
            edge_image(i, j) = sum(sum(region .* Laplacian));
        end
    end

    % 归一化到 0~255 范围
    edge_image = uint8(255 * mat2gray(edge_image));
end
