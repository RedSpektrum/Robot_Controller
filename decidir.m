function casilla_obj = decidir(mapa, actual, anterior)
%Toma una decisión de casilla a la que viajar desde la actual
    casilla = mapa(actual.X, actual.Y);
    paredes = casilla.paredes;
    % Direccion
    % 0->derecha     1->arriba
    % 2->abajo       3->izquierda
    
    x=actual.X;
    y=actual.Y;
    
    todo_visitado=0;
    
    %% Si no estamos en ningún borde
    if((1<x && x<7) && (1<y && y<3))
        % Priorizamos las casillas sin visitar
        if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
           direccion=3; %Abajo
        elseif(paredes.arriba==0 && mapa(x,y+1).visitada==0)
            direccion=2; %Arriba
        elseif(paredes.derecha==0 && mapa(x+1,y).visitada==0)
            direccion=1; %Derecha
        elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
            direccion=4; %Izquierda
        else
            todo_visitado=1;
        end
    %% Si estamos en el borde derecho    
    elseif(x==7)
        %Si estamos en la esquina superior
        if(y==3)
            % Priorizamos casillas sin visitar
            if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
                direccion=3; % Abajo
            elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
                direccion=4; % Izquierda
            else
                todo_visitado=1;
            end
        %Si estamos en la esquina inferior
        elseif(y==1)
            % Priorizamos casillas sin visitar
            if(paredes.arriba==0 && mapa(x,y+1).visitada==0)
                direccion=2; % Arriba
            elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
                direccion=4; % Izquierda
            else
                todo_visitado=1;
            end
        %Si no
        else
            % Priorizamos casillas sin visitar
            if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
                direccion=3; % Abajo
            elseif(paredes.arriba==0 && mapa(x,y+1).visitada==0)
                direccion=2; % Arriba
            elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
                direccion=4; % Izquierda
            else
                todo_visitado=1;
            end
        end
    %% Si estamos en el borde izquierdo    
    elseif(x==1)
        %Si estamos en la esquina superior
        if(y==3)
            % Priorizamos casillas sin visitar
            if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
                direccion=3; % Abajo
            elseif(paredes.derecha==0 && mapa(x+1,y).visitada==0)
                direccion=1; % Derecha
            else
                todo_visitado=1;
            end
        %Si estamos en la esquina inferior
        elseif(y==1)
            % Priorizamos casillas sin visitar
            if(paredes.arriba==0 && mapa(x,y+1).visitada==0)
                direccion=2; % Arriba
            elseif(paredes.derecha==0 && mapa(x+1,y).visitada==0)
                direccion=1; % Derecha
            else
                todo_visitado=1;
            end
        %Si no
        else
            % Priorizamos casillas sin visitar
            if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
                direccion=3; % Abajo
            elseif(paredes.arriba==0 && mapa(x,y+1).visitada==0)
                direccion=2; % Arriba
            elseif(paredes.derecha==0 && mapa(x+1,y).visitada==0)
                direccion=1; % Derecha
            else
                todo_visitado=1;
            end
        end
    %% Si estamos en el borde superior
    elseif(y==3)
        % Priorizamos casillas sin visitar
        if(paredes.abajo==0 && mapa(x,y-1).visitada==0)
                direccion=3; % Abajo
        elseif(paredes.derecha==0 && mapa(x+1,y).visitada==0)
            direccion=1; %Derecha
        elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
                direccion=4; % Izquierda
        else
            todo_visitado=1;
        end
    %% Si no, estamos en el borde inferior
    else
        % Priorizamos casillas sin visitar
        if(paredes.derecha==0 && mapa(x+1,y).visitada==0)
            direccion=1; %Derecha
        elseif(paredes.izquierda==0 && mapa(x-1,y).visitada==0)
                direccion=4; % Izquierda
        elseif(paredes.arriba==0 && mapa(x,y+1).visitada==0)
                direccion=2; % Arriba
        else
            todo_visitado=1;
        end     
    end
    
    %% Si no hay casillas sin visitar alrededor
    % Seguimos la pared izquierda
    if(todo_visitado==1)
        if(paredes.abajo==0 && anterior.Y>=y)
            direccion=3; % Abajo
            todo_visitado=0;
        elseif(paredes.derecha==0 && anterior.X<=x)
            direccion=1; % Derecha
            todo_visitado=0;
        elseif(paredes.arriba==0 && anterior.Y<=y)
            direccion=2; % Arriba
            todo_visitado=0;
        elseif(paredes.izquierda==0 && anterior.X>=x)
            direccion=4; % Izquierda
            todo_visitado=0;
        else
            casilla_obj.X = anterior.X;
            casilla_obj.Y = anterior.Y;
        end
    end
    
    if(todo_visitado==0)
        if(direccion==1)
            casilla_obj.X = x+1;
            casilla_obj.Y = y;
        elseif(direccion==2)
            casilla_obj.X = x;
            casilla_obj.Y = y+1;
        elseif(direccion==3)
            casilla_obj.X = x;
            casilla_obj.Y = y-1;
        else
            casilla_obj.X = x-1;
            casilla_obj.Y = y;
        end
    end
    
    
end