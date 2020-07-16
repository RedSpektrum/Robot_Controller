function [error] = avanzar(destino)
    % Funcion que mueve nuestro robot de una casilla a otra en linea recta
    % recibe destino compuesto por X e Y contado en casillas, no metros
    %% SUBSCRIBERS Y PUBLISHERS
    global odom;
    global pub;
    global msg_vel;

    %%Nos aseguramos recibir un mensaje relacionado con el robot
    while (strcmp(odom.LatestMessage.ChildFrameId, 'robot0') ~= 1)
        odom.LatestMessage;
    end
    %% VARIABLES
    % Transformamos de casillas a medidas espaciales
    destino.X = (destino.X-1)*2 +1;
    destino.Y = (destino.Y-1)*2 +1;
    
    %% Datos sobre posicion
    pos = odom.LatestMessage.Pose.Pose.Position;
    
    % Tomamos el sentido de movimiento y la distancia
    if(abs(destino.X-pos.X)>0.1)
        dist = destino.X-pos.X;
        sentido = dist/abs(dist);
        eje = 0;
    elseif(abs(destino.Y-pos.Y)>0.1)
        dist = destino.Y-pos.Y;
        sentido = dist/abs(dist);
        eje=1;
    else
        eje=-1;
        sentido=0;
    end
    
    % Periodo del bucle (10hz)
    r=robotics.Rate(10);
    waitfor(r);
    
    %% MENSAJE
    msg_vel.Linear.X = 0;
    msg_vel.Linear.Y = 0;
    msg_vel.Linear.Z = 0;
    msg_vel.Angular.X = 0;
    msg_vel.Angular.Y = 0;
    msg_vel.Angular.Z = 0; 
    %% CORRECCIÓN DE ORIENTACIÓN
    ori = odom.LatestMessage.Pose.Pose.Orientation; 
    
    % Si nos movemos en eje X
    if(eje==0)
        obj=0;
        
        if(sentido==-1)
            obj= pi;
        end
    % Si nos movemos en eje Y
    elseif (eje==1)
        obj = pi*sentido/2;
    else
        obj = 0;
    end
        
    yaw = quat2eul([ori.W ori.X ori.Y ori.Z]); % Transformación de cuaternion a euler
    yaw = yaw(1); % Solo nos interesa esa orientación
    error = obj - yaw;
    
    % Regulamos si el error es menor que -pi
    if (error<-pi)
        error=abs(error)-pi;
    elseif (error>pi)
        error = -error + pi;
    end    
    while( abs(error) >= 0.05 )
        
        ori = odom.LatestMessage.Pose.Pose.Orientation; 
        yaw = quat2eul([ori.W ori.X ori.Y ori.Z]); % Transformación de cuaternion a euler
        yaw = yaw(1); % Solo nos interesa esa orientación
        error = obj - yaw;   
            
        % Definición de cuadrante
        if(error>pi)
            error = error - 2*pi;
        elseif(error<-pi)
            error = error + 2*pi;
        end           
        % Para limitar la velocidad de giro a 1 rad/s
        if(abs(error)>2)
            error=error/abs(error);
        end       
        msg_vel.Angular.Z = error*0.65;
        send(pub,msg_vel);    
        waitfor(r);
    end
    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);
    
    Pe = sqrt((pos.X-destino.X)^2+(pos.Y-destino.Y)^2);
    
    %% CONTROLADOR
    while((eje>-1) && (abs(Pe)>=0.11))
        % Variables actuales
        pos = odom.LatestMessage.Pose.Pose.Position;    
        %% Cálculo de error
        % Error de posición y orientación
        Pe = sqrt((pos.X-destino.X)^2+(pos.Y-destino.Y)^2);
        Oe = atan2(destino.Y-pos.Y,destino.X-pos.X)-yaw;
        
        % Contolamos los cambios de cuadrante del error de orientacion
        if(Oe>pi)
            Oe = Oe - 2*pi;
        elseif(Oe<-pi)
            Oe = Oe + 2*pi;
        end        
        %% Consignas de velocidades
        consigna_vel_ang = 0.45*Oe;
        consigna_vel_lin = 0.60*Pe;
        
        if(consigna_vel_ang>1)
            consigna_vel_ang=1;
        end
        if(consigna_vel_lin>1)
            consigna_vel_lin=1;
        end
        
        % Controlamos que no de vueltas en círculos atascado
        if(consigna_vel_ang>consigna_vel_lin)
            consigna_vel_ang=consigna_vel_lin-0.1;
        elseif(consigna_vel_ang<-consigna_vel_lin)
            consigna_vel_ang=-consigna_vel_lin+0.1;
        end
        %% Aplicamos consignas de control
        msg_vel.Linear.X= consigna_vel_lin;
        msg_vel.Angular.Z= consigna_vel_ang;
        send(pub,msg_vel);
              
        waitfor(r);
    end
    %% Aplicamos consignas de control
    msg_vel.Linear.X = 0;
    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);   
    error = sqrt((pos.X-destino.X)^2+(pos.Y-destino.Y)^2);
end