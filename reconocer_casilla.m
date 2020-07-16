function mapa = reconocer_casilla(mapa)
%Reconoce la casilla en la que esta y crea una estructura con los datos
%adjuntos de la casilla
    global odom;
    global laser;
    
    %% Nuestra estructura es la siguiente
    paredes.arriba=0;
    paredes.abajo=0;
    paredes.derecha=0;
    paredes.izquierda=0;
    casilla.paredes = paredes;
    casilla.visitada = 1;
    
    %% Primero reconoceremos las coordenadas
    pos = odom.LatestMessage.Pose.Pose.Position;
    % Tomamos el cociente y resto de la división entera por dos
    cociente.X = floor(pos.X/2);
    cociente.Y = floor(pos.Y/2);
    resto.X = mod(pos.X,2);
    resto.Y = mod(pos.Y,2);
    
    %Ahora transformamos las medidas
    coordenada.X=cociente.X;
    %Si no es par o está desplazada es una más p.e.j
    % 0.5 = 0+1 = 1   % 2 = 1+0= 1
    % 1.2 = 0+1 = 1   % 2.1 = 1+1= 2
    if(resto.X>0)
        coordenada.X=coordenada.X+1;
    end
    
    % Igual para la coordenada Y
    coordenada.Y=cociente.Y;
    if(resto.Y>0)
        coordenada.Y=coordenada.Y+1;
    end
    
    
    %% Cálculo de rayos coincidentes con las direcciones de las paredes
    ori = odom.LatestMessage.Pose.Pose.Orientation; 
    yaw = quat2eul([ori.W ori.X ori.Y ori.Z]); % Transformación de cuaternion a euler
    yaw = yaw(1); % Solo nos interesa esa orientación
    
    msg_laser = receive(laser);
    
    % Primero calcularemos el ángulo complementario
    % Primer cuadrante
    if(0<=yaw<=pi/2)
        complementario = pi/2-yaw;
    % Segundo cuadrante
    elseif(pi/2<yaw<=pi)
        complementario = pi-yaw;
    % Cuarto cuadrante
    elseif(-pi/2<=yaw<0)
        complementario = pi/2+yaw;
    % Tercer cuadrante
    else
        complementario = pi + yaw;
    end
    % Sacamos los rayos que ocupa el complementario
    rayos_compl = floor(100*complementario/(pi/2));
    valor = 200 + rayos_compl;

    %% Indicación de rayos según el cuadrante de la orientación
    % Primer cuadrante
    if(0<=yaw<=pi/2)
        arriba = mod(valor,401);
        izq = mod(arriba+100,401);
        der = mod(arriba-100,401);
        abajo = mod(arriba-200,401);
        
    % Segundo cuadrante
    elseif(pi/2<yaw<=pi)
        izq = mod(valor,401);
        arriba = mod(izq-100,401);
        der = mod(izq-200,401);
        abajo = mod(izq-300,401);
    % Tercer cuadrante
    elseif(-pi/2>yaw>=-pi)
        abajo = mod(valor,401);
        izq = mod(abajo-100,401);
        der = mod(abajo+100,401);
        arriba = mod(abajo+200,401);
    % Cuarto cuadrante
    else
        der = mod(valor,401);
        arriba = mod(der+100,401);
        izq = mod(der+200,401);
        abajo = mod(der-100,401);
    end
    
    % Como no hay rayo numero 0, en ese caso elegimos el 1
    if(arriba==0)
        arriba=1;
    end
    if(abajo==0)
        abajo=1;
    end
    if(izq==0)
        izq=1;
    end
    if (der==0)
        der=1;
    end
    
    %% Comprobación de si hay pared
    msg_laser.Ranges(arriba);
    msg_laser.Ranges(abajo);
    msg_laser.Ranges(der);
    msg_laser.Ranges(izq);
    
    % Arriba
    if(msg_laser.Ranges(arriba)<=1.3)
        paredes.arriba=1;
    else
        paredes.arriba=0;
    end
    % Abajo
    if(msg_laser.Ranges(abajo)<=1.3)
        paredes.abajo=1;
    else
        paredes.abajo=0;
    end
    % Derecha
    if(msg_laser.Ranges(der)<=1.3)
        paredes.derecha=1;
    else
        paredes.derecha=0;
    end
    % Izquierda
    if(msg_laser.Ranges(izq)<=1.3)
        paredes.izquierda=1;
    else
        paredes.izquierda=0;
    end
    
    %% Rellenamos el mapa
    casilla.paredes = paredes;
    mapa(coordenada.X, coordenada.Y) = casilla;
end