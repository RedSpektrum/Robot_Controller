function conectar()
% Preparamos el entorno
setenv('ROS_MASTER_URI','http://192.168.1.50:11311');
setenv('ROS_IP','192.168.1.38');
% Iniciamos la conexión
rosinit;
end

