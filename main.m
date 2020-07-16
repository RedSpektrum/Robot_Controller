% Primero nos conectamos al robot
conectar()
% Usaremos una estructura mapa que contiene: casillas y en estas paredes de cada
% casilla, si ha sido visitada
paredes.arriba=0;
paredes.abajo=0;
paredes.derecha=0;
paredes.izquierda=0;
casilla.paredes = paredes;
casilla.visitada = 0;
mapa=[casilla casilla casilla; casilla casilla casilla; casilla casilla casilla; casilla casilla casilla; casilla casilla casilla; casilla casilla casilla; casilla casilla casilla];
%% SUBSCRIBERS Y PUBLISHERS
% Usaremos los topics como variables globales
global odom
odom = rossubscriber('robot0/odom');
global laser
laser = rossubscriber('robot0/laser_1');
global pub
pub = rospublisher('/robot0/cmd_vel','geometry_msgs/Twist');
global msg_vel
msg_vel = rosmessage(pub);
%% Variables clave
% Variables para el fin del bucle de mapeo
salida = 0;
casilla_salida=casilla;

% Información para la salida
ruta_salida = zeros(21,2);
puntos = 0;
fuera = 0;
actual = situarse();
casilla_anterior = actual;

%% Bucle de mapeo
while(1)
    % Primero busquemos las coordenadas de la casilla actual
    actual=situarse();
    
    
    %% Reconocimiento de casilla si no se ha mapeado
    if(mapa(actual.X, actual.Y).visitada==0)
        mapa = reconocer_casilla(mapa);
    
        casillas_mapeadas = 0;
   
        % Recontamos las casillas mapeadas
        for ejeX = 1:1:7
            for ejeY = 1:1:3
                if(mapa(ejeX,ejeY).visitada==1)
                    casillas_mapeadas=casillas_mapeadas+1;
                end
            end
        end
        %% Si hemos mapeado las 21 casillas entonces hemos acabado el mapeo
        if(casillas_mapeadas==21)
            break;
        end
    end
    
    % Comprobación de salida %
    info_actual = mapa(actual.X,actual.Y);
    aux = es_salida(actual,info_actual);
    
    %% Si es la salida activamos la variable para crear ruta de escape
    if(aux.es_salida==1)
        salida=1;
        casilla_salida = aux.casilla;
    end
      
    %% Toma de decisiones
    siguiente = decidir(mapa, actual, casilla_anterior);
    
    % Si se ha encontrado la salida se crea la ruta de escape
    if(salida==1)
        % Rellenamos la ruta de escape durante el proceso de mapeo
        aux = hacer_ruta_salida(ruta_salida,puntos,actual);
        ruta_salida = aux.ruta;
        puntos = aux.puntos;
    end
     
    %% Movimiento a la siguiente casilla %
    avanzar(siguiente);    
    casilla_anterior = actual;
    
    
end
%% Bucle de salida
while(fuera==0) 
    % Cargamos la casilla objetivo
    obj.X = ruta_salida(puntos,1);
    obj.Y = ruta_salida(puntos,2);
    % Nos movemos
    avanzar(obj);
    % Decrementamos el indicador de casilla
    puntos=puntos-1;
    
    % Si ya hemos recorrido todos los puntos para salir
    if(puntos==0)
        avanzar(casilla_salida);
        fuera=1;
    end
end
desconectar();