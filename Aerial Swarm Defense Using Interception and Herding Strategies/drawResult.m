function drawResult(f, pos_a, pos_d, rho_d_game, rho_d, rho_p, idx)
    figure(f);
    clf;
    visrings([0; 0], rho_d_game, rho_d, 'g', 0.2);
    visrings([0; 0], 0, rho_p, 'b', 0.2);
    hold on
    s1 = scatter(pos_a(1, :), pos_a(2, :), 'filled');
    s1.MarkerFaceColor = "r";
    s2 = scatter(pos_d(1, :), pos_d(2, :), "filled");
    s2.MarkerFaceColor = 'b';
    s2.Marker = "diamond";
    
    gscatter(pos_a(1, :)', pos_a(2, :)', idx);
    hold off
    axis equal;
    drawnow
end