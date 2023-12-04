function CoM = getCoM(agents)
    % GETCOM 计算agents集群的质心(Center of Mass)
    % input:
    %   agents: Agent对象构成的cell数组
    pos = zeros(2, length(agents));

    for i = 1:length(agents)
        pos(:, i) = agents{i}.position;
    end

    CoM = sum(pos, 2) / length(agents);
end
