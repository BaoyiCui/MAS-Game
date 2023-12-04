function idx = DBSCAN(attackers, R_sb, N_a, N_d, MinPts)
    %DBSCAN
    %   moniter the spatial distribution of the attackers
    %   attackers: array of all attackers
    %   idx: group idx of each attacker
    rho_ac = R_sb / 2 * cot(pi / N_d);
    eps = rho_ac * (MinPts - 1) / (N_a - 1);
    pos_a = zeros(2, N_a);

    for i = 1:length(attackers)
        pos_a(:, i) = attackers{i}.position;
    end

    idx = dbscan(pos_a', eps, MinPts);
end
