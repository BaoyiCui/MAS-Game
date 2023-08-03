function sharedVertices = getSharedBound(P1, P2)
    tol = 1e-6;
    vertices1 = P1.V;
    vertices2 = P2.V;
    sharedVertices = [];
    for i = 1:size(vertices1, 1)
        for j = 1:size(vertices2, 1)
            if all(abs(vertices1(i, :) - vertices2(j, :)) < tol)
                sharedVertices = [sharedVertices; vertices1(i, :)];
                break;
            end
        end
    end
end
