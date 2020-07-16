function [resultado] = hacer_ruta_salida(ruta, puntos, actual)
%Funci�n que traza una ruta de salida en base a los puntos recorridos
    if(puntos>0)
        coincidencia = 0; %Para saber si ha funcionado el proceso
        % Bucle desde puntos que decrementa de 1 en 1 hasta 0
        for index = puntos:-1:1 
            % Si la casilla en la que estamos ya esta dentro de la ruta de
            % escape ignoramos todas las dem�s para ahorrar vueltas
            if(ruta(index,1)== actual.X && ruta(index,2)==actual.Y)
                puntos=index;
                coincidencia=1;
                break;
            end
        end
        % Si no coincide con la ruta de salida se a�ade
        if(coincidencia==0)
            puntos = puntos+1;
            ruta(puntos,1)=actual.X;
            ruta(puntos,2)=actual.Y; 
        end
        
    else
        puntos = puntos+1;
        ruta(puntos,1)=actual.X;
        ruta(puntos,2)=actual.Y;
    end
    
    resultado.puntos = puntos;
    resultado.ruta = ruta;
end

