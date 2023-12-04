classdef Defender < Agent
    %DEFENDER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        isIntercepting;
        isHerding;
    end
    
    methods
        function obj = Defender(pos_init, d_coef, control_bound)
            %DEFENDER 
            %   d_coef: positive, known, constant drag coefficient
            %   control_bound: positive, acceleration bound
            %   pos: initial position, (2*1)
            obj = obj@Agent(pos_init, d_coef, control_bound);
            obj.isIntercepting = false;
            obj.isHerding = True;
        end
        
        

    end
end

