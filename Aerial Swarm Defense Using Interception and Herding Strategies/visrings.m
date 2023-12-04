function visrings(centers, innerRadii, outerRadii, colors, alphas)
%VISRINGS plot ring using patch()
%   centers: 圆环的圆心
%   innerRadii: 圆环内半径,内半径为0时就是填充圆
%   outerRadii: 圆环外半径
%   colors: 颜色数组, ['r', 'g', 'b']
%   alphas: 透明度数组, 范围(0,1)闭区间
% Example:
%   centers = [0, 0; 3, 3; -3, -3];
%   innerRadii = [1, 2, 1.5];
%   outerRadii = [2, 3, 2.5];
%   colors = ['r', 'g', 'b']; % 设定颜色为红色，绿色和蓝色
%   % 调用函数
%   visrings(centers, innerRadii, outerRadii, colors);
    figure;
    hold on;
    theta = linspace(0, 2*pi, 100);
    for i=1:size(centers)
        xInneri = centers(i, 1) + innerRadii(i) * cos(theta);
        yInneri = centers(i, 2) + innerRadii(i) * sin(theta);
        xOuteri = centers(i, 1) + outerRadii(i) * cos(theta);
        yOuteri = centers(i, 2) + outerRadii(i) * sin(theta);
        h = patch([xInneri,fliplr(xOuteri)], [yInneri,fliplr(yOuteri)], colors(i));
        h.FaceAlpha = alphas(i);
        h.EdgeColor = "none";
    end
    hold off
end

