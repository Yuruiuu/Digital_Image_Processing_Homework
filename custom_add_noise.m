function noisy_image = custom_add_noise(image, noise_type, param1, param2)
    % 输入:
    % image: 原始图像 (灰度或彩色图像)
    % noise_type: 噪声类型 ('gaussian', 'salt & pepper')
    % param1: 噪声参数1
    %         对于高斯噪声：param1 = 均值 (mean)
    %         对于椒盐噪声：param1 = 椒盐噪声密度 (0~1之间)
    % param2: 噪声参数2
    %         对于高斯噪声：param2 = 标准差 (std)
    %         对于椒盐噪声：忽略此参数
    % 输出:
    % noisy_image: 添加噪声后的图像

    % 获取图像尺寸
    [rows, cols, channels] = size(image);

    % 初始化噪声图像
    noisy_image = image;

    switch lower(noise_type)
        case 'gaussian'  % 高斯噪声
            % 生成高斯噪声
            mean = param1;
            std = param2;
            noise = mean + std * randn(rows, cols, channels); % 高斯分布

            % 添加噪声
            noisy_image = double(image) + noise;

            % 限制灰度值范围 [0, 255]
            noisy_image(noisy_image > 255) = 255;
            noisy_image(noisy_image < 0) = 0;

            % 转换为 uint8 类型
            noisy_image = uint8(noisy_image);

        case 'salt & pepper'  % 椒盐噪声
            % 获取噪声密度
            density = param1;

            % 生成随机矩阵
            rand_matrix = rand(rows, cols, channels);

            % 添加椒盐噪声
            for c = 1:channels
                % 椒噪声 (设置为0)
                noisy_image(rand_matrix(:, :, c) < density / 2, c) = 0;

                % 盐噪声 (设置为255)
                noisy_image(rand_matrix(:, :, c) >= 1 - density / 2, c) = 255;
            end

        otherwise
            error('Unsupported noise type. Use "gaussian" or "salt & pepper".');
    end
end
