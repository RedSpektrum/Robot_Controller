function salida = es_salida(numero, casilla)
    %Comprueba si una casilla es o no salida
    paredes = casilla.paredes;
    salida.es_salida = 0;
    % Si estamos en la esquina derecha inferior
    if(numero.Y==1 && numero.X==7)
        if(paredes.derecha==0 || paredes.abajo==0)
            salida.es_salida=1;
            if(paredes.derecha==0)
                salida.casilla.X = numero.X+1;
                salida.casilla.Y = numero.Y;
            elseif(paredes.abajo==0)
                salida.casilla.X = numero.X;
                salida.casilla.Y = numero.Y-1;
            end
        end
    % Si estamos en la esquina izquierda inferior
    elseif(numero.Y==1 && numero.X==1)
        if(paredes.izquierda==0 || paredes.abajo==0)
            salida.es_salida=1;
            if(paredes.izquierda==0)
                salida.casilla.X = numero.X;
                salida.casilla.Y = numero.Y-1;
            elseif(paredes.abajo==0)
                salida.casilla.X = numero.X-1;
                salida.casilla.Y = numero.Y;
            end
        end
    % Si estamos en la esquina derecha superior
    elseif(numero.Y==3 && numero.X==7)
        if(paredes.derecha==0 || paredes.arriba==0)
            salida.es_salida=1;
            if(paredes.derecha==0)
                salida.casilla.X = numero.X+1;
                salida.casilla.Y = numero.Y;
            elseif(paredes.arriba==0)
                salida.casilla.X = numero.X;
                salida.casilla.Y = numero.Y+1;
            end
        end
    % Si estamos en la esquina izquierda superior
    elseif(numero.Y==3 && numero.X==1)
        if(paredes.izquierda==0 || paredes.arriba==0)
            salida.es_salida=1;
            if(paredes.izquierda==0)
                salida.casilla.X = numero.X-1;
                salida.casilla.Y = numero.Y;
            elseif(paredes.arriba==0)
                salida.casilla.X = numero.X;
                salida.casilla.Y = numero.Y+1;
            end
        end
    % Si estamos en el borde derecho
    elseif (numero.X==7)
        if(paredes.derecha == 0)
            salida.es_salida=1;
            salida.casilla.X = numero.X+1;
            salida.casilla.Y = numero.Y;
        end
    % Si estamos en el borde inferior
    elseif(numero.Y==1)
        if(paredes.abajo==0)
            salida.es_salida=1;
            salida.casilla.X = numero.X;
            salida.casilla.Y = numero.Y-1;
        end
    % Si estamos en el borde izquierdo
    elseif(numero.X==1)
        if(paredes.izquierda==0)
            salida.es_salida=1;
            salida.casilla.X = numero.X-1;
            salida.casilla.Y = numero.Y;
        end
    % Si estamos en el borde superior
    elseif(numero.Y==3)
        if(paredes.arriba==0)
            salida.es_salida=1;
            salida.casilla.X = numero.X;
            salida.casilla.Y = numero.Y+1;
        end
    end
end

