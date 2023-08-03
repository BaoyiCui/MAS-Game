function [A] = getVoronoiAdjacency(p)
% [v,p] = mpt_voronoi(points)
% 使用第二个返回值p
% 计算各个voronoi cell的邻接关系
% 返回邻接矩阵A
    A = zeros(length(p));
    tol = 1e-6;
    for i = 1:length(p)
        for j = 1:length(p)
            if i==j
                continue;
            end

            if areAdjacent(p(i), p(j), tol)
                A(i,j) = 1;
            end
        end
    end

end

function adjacent = areAdjacent(P1,P2, tol)
    % tol为判断两点是否相等的误差容许范围
    % 使用intersect或者直接判断相等可能会由于浮点数精度问题导致判断错误
    % 获取多面体的顶点
    vertices1 = P1.V;
    vertices2 = P2.V;
    
    % 找到共享的顶点
    dimension = size(vertices1, 2);
    sharedCount = 0;
    for i = 1:size(vertices1, 1)
        for j = 1:size(vertices2, 1)
            if all(abs(vertices1(i, :) - vertices2(j, :)) < tol)
                sharedCount = sharedCount + 1;
                break;
            end
        end
    end

    if sharedCount >= dimension
        adjacent = true;
    else
        adjacent = false;
    end

end

