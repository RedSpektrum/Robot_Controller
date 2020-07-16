function [casilla] = situarse()
%Función que situa la casilla en la que nos encontramos
    global odom;
    pos = odom.LatestMessage.Pose.Pose.Position;
%% Determinamos la casilla actual
    casilla.X = floor(pos.X/2);
    casilla.Y = floor(pos.Y/2);
    resto.X = mod(pos.X,2);
    resto.Y = mod(pos.Y,2);   
    %Ahora transformamos las medidas
    if(resto.X>0)
        casilla.X=casilla.X+1;
    end  
    % Igual para la coordenada Y
    if(resto.Y>0)
        casilla.Y=casilla.Y+1;
    end
end

