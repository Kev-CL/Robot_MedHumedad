% archivosGuardados(opc,Humedadf,Etiquetaf,Diaf,Horaf,DatoCambio)
% opc = 0 -> Resetear lista
% opc = 1 -> Agregar datos
% opc = 2 -> Cambiar datos

function archivosGuardados(opc,Humedadf,Etiquetaf,Diaf,Horaf,DatoCambio)

    direccion='C:\Users\kevin\Documents\MEGAsync\UTM\ProyectoHumedad\Proyecto Integrador de Ingenieria en Mecatrónica\DatosHumedad.txt';
    
    if opc==0 % Resetear lista

        elemSig=1; % Posicion 0

        No(elemSig,1)=0;
        Humedad(elemSig,1)=0;
        Etiqueta(elemSig,1)={'NA'};
        Dia(elemSig,1)={'NA'};
        Hora(elemSig,1)={'NA'};

        T = table(No,Humedad,Etiqueta,Dia,Hora);

    end

    if opc==1 % Agregar dato
        T=readtable(direccion); %Leyendo Tabla
        sz = size(T);%Tamaño de Matriz
        cantEle=sz(1,1);%Num. de elementos
        T.No(cantEle);
        if T.No(cantEle) == 0
            elemSig=T.No(cantEle)+1; % Posicion 1

            No(elemSig,1)= elemSig;
            Humedad(elemSig,1)=Humedadf;
            Etiqueta(elemSig,1)={Etiquetaf};
            Dia(elemSig,1)={Diaf};
            Hora(elemSig,1)={Horaf};

            T = table(No,Humedad,Etiqueta,Dia,Hora);
        else
            elemSig=T.No(cantEle)+1; % Posición SIGUIENTE
            
            % Copiando datos existentes
            No=T.No; 
            Humedad=T.Humedad;
            Etiqueta=T.Etiqueta;
            Dia=T.Dia;
            Hora=T.Hora;
            
            %Agregando Dato
            No(elemSig,1)=elemSig;
            Humedad(elemSig,1)=Humedadf;
            Etiqueta(elemSig,1)={Etiquetaf};
            Dia(elemSig,1)={Diaf};
            Hora(elemSig,1)={Horaf};

            T = table(No,Humedad,Etiqueta,Dia,Hora);
        end
    end
    if opc==2
        T=readtable(direccion); %Leyendo Tabla
        elemSig=DatoCambio; % Posición a cambiar
            
        % Copiando datos existentes
        No=T.No; 
        Humedad=T.Humedad;
        Etiqueta=T.Etiqueta;
        Dia=T.Dia;
        Hora=T.Hora;

        %Agregando Dato
        No(elemSig,1)=elemSig;
        Humedad(elemSig,1)=Humedadf;
        Etiqueta(elemSig,1)={Etiquetaf};
        Dia(elemSig,1)={Diaf};
        Hora(elemSig,1)={Horaf};

        T = table(No,Humedad,Etiqueta,Dia,Hora);
    end
    writetable(T,direccion);
end

