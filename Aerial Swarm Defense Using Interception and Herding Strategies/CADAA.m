function [solutionMatrix, fval] = CADAA(costMatCol, costMatTime, weight)
    %CADAA 将defender分配到unclustered attacker
    %input:
    %   costMatCol: 碰撞代价矩阵 m * m
    %   costMatTime: 拦截时间代价矩阵 n * m
    %   weight: 拦截时间代价的权重
    %output:
    %   solutionMatrix: 分配矩阵
    %   fval: 最小总代价

    [n, m] = size(costMatTime); % n任务(unclustered attackers), m执行者(defenders)

    % 目标函数
    f1 = (1 - weight) * costMatTime(:);
    f2 = weight * costMatCol(:);    


    % 变量界
    lb = zeros(n * m, 1);
    ub = ones(n * m, 1);

    %% 分配约束
    % 每个任务只能分配给1个执行者
    Aeq_task = kron(eye(n), ones(1, m));
    beq_task = ones(n, 1);
    % 每个执行者只能执行一个任务
    Aeq_defender = kron(ones(1, n), eye(m));
    beq_defender = ones(m, 1);
    % 合并约束
    Aeq = [Aeq_task; Aeq_defender];
    beq = [beq_task; beq_defender];

    % 整数约束
    intcon = 1:(n * m);

    % 求解整数线性规划
    opts = optimoptions('intlinprog', 'Display', 'off');
    [x, fval, exitflag, output] = intlinprog(f1, intcon, [], [], Aeq, beq, lb, ub, opts);

    % 检查解的状态
    if exitflag ~= 1
        warning('The optimization did not converge to a solution. Exit flag is %d.', exitflag);
    end

    solutionMatrix = reshape(x, m, n);

end
