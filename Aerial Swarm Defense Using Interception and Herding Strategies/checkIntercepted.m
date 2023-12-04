function interceptedFlag = checkIntercepted(attackers, defenders, rho_int)
    %CHECKINTERCEPTED 判断哪些attacker被拦截
    %inputs:
    %   attackers: 所有攻击者
    %   defenders: 所有防御者
    %   rho_int: 拦截半径
    %outputs:
    %   interceptedFlag: 返回每个attacker的拦截Flag, true为被拦截
    pos_a = zeros(2, length(attackers));
    pos_d = zeros(2, length(defenders));

    for i = 1:length(attackers)
        pos_a(:, i) = attackers{i}.position;
    end

    for i = 1:length(defenders)
        pos_d(:, i) = defenders{i}.position;
    end

    dist = pdist2(pos_a', pos_d');

    distLeqInt = (dist < rho_int);

    interceptedFlag = sum(distLeqInt, 2); % 进入一个defender的rho_int就判断为被拦截
    interceptedFlag = (interceptedFlag ~= 0);
end
