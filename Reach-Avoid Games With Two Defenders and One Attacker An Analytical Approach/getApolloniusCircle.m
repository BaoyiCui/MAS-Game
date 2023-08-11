function [c,r] = getApolloniusCircle(x_1, x_2, alpha)
    % c是ApolloniusCircle的中心
    % r是ApolloniusCircle的半径
    % x_1，x_2为平面上的定点，1*2
    % alpha为比值
    % alpha = dist(p,x_1)/dist(p,x_2)
    distance = norm(x2-x1);
    r = alpha * distance / (alpha^2+1);
    c = (x_1 + alpha * x_2) / (1+alpha);
end
