function sharedVertices = getSharedBound(P1, P2)
    tol = 1e-6; % 容许误差
    % 获取两个cell的顶点
    vertices1 = P1.V;   
    vertices2 = P2.V;
    sharedVertices = [];    % 记录共享的顶点
    for i = 1:size(vertices1, 1)
        for j = 1:size(vertices2, 1)
            if all(abs(vertices1(i, :) - vertices2(j, :)) < tol)
                sharedVertices = [sharedVertices; vertices1(i, :)];
                break;
            end
        end
    end
    % 由Voronoi图的性质可知，boundary一定是凸多边形/多面体，因此求sharedVertices的凸包即为共享的boundary
end
