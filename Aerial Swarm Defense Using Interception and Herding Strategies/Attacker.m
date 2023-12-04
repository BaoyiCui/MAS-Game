classdef Attacker < Agent
    %ATTACKER 此处显示有关此类的摘要
    %   此处显示详细说明

    properties
        isIntercepted;
        isClustered;
    end

    methods

        function obj = Attacker(pos_init, d_coef, control_bound)
            %ATTACKER
            %   d_coef: positive, known, constant drag coefficient
            %   control_bound: positive, acceleration bound
            %   pos: initial position, (2*1)
            obj = obj@Agent(pos_init, d_coef, control_bound);
            obj.isIntercepted = false;
            obj.isClustered = false;
        end

    end

end
