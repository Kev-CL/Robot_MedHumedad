%*************************************************************************
%                   CONTROLADOR (MANDO XBOX)
%*************************************************************************

% VARIABLES
%************
% Joystick(1) - Dirección
%ax(1) --> adelante / atrás 
%ax(2) --> izquierda /derecha

% Joystick(2) - Dirección
%ax(4) --> adelante / atrás 
%ax(5) --> izquierda /derecha

%LT / RT
%ax(3) --> LT / RT

% button()
%************
% Botones
%butt(1) --> A
%butt(2) --> B
%butt(3) --> X
%butt(4) --> Y

%butt(5) --> LB
%butt(6) --> RB

%butt(7) --> Vista
%butt(8) --> Menú

%butt(9) -->  Stick Izquierdo
%butt(10) --> Stick Derecho

% pov()
%************ 
%cruz(1) --> Cruceta
%*****************************************

global joy band mod humedadv3 varhs Humedad bandBomba bandFy; %var. global de joystick

sens = 0.3; %sensibilidad direccion

for cont = 1:5   
   ax(cont)= axis(joy, cont);  % Direccion
end
for cont = 1:10   
   but(cont)= button(joy, cont);  % Direccion
end 
cruz = pov(joy,1);

if ax(2) >= sens 
    writeDigitalPin(r,del,0)
    writeDigitalPin(r,del2,0)
    writeDigitalPin(r,atr,1)
    writeDigitalPin(r,atr2,1)
elseif ax(2) <=-sens
    writeDigitalPin(r,del,1)
    writeDigitalPin(r,del2,1)
    writeDigitalPin(r,atr,0)
    writeDigitalPin(r,atr2,0)
elseif ax(1) >=sens
    writeDigitalPin(r,del,0)
    writeDigitalPin(r,del2,1)
    writeDigitalPin(r,atr,1)
    writeDigitalPin(r,atr2,0)
elseif ax(1) <=-sens
    writeDigitalPin(r,del,1)
    writeDigitalPin(r,del2,0)
    writeDigitalPin(r,atr,0)
    writeDigitalPin(r,atr2,1)
else  
    writeDigitalPin(r,del,0)
    writeDigitalPin(r,del2,0)
    writeDigitalPin(r,atr,0)
    writeDigitalPin(r,atr2,0)
end

if ax(3) <= sens*-1
    if bandBomba==1
        activacionBomba('C',r)
        bandBomba=2;
    elseif bandBomba==2
        activacionBomba('B',r)
        bandBomba=3;
    elseif bandBomba==3
        activacionBomba('A',r)
        bandBomba=4;
    elseif bandBomba==4
        activacionBomba('E',r)
        bandBomba=5;
    else
        activacionBomba('D',r)
        bandBomba=1;
    end
    pause(0.1)
% elseif ax(3) >= sens
%      if bandVel==1
%         app.VelocidadSlider.Value = 100;
%         bandVel=2;
%     elseif bandVel==2
%         app.VelocidadSlider.Value = 0;
%         bandVel=3;
%     else
%         app.VelocidadSlider.Value = 50;
%         bandVel=1;
%     end
%     pause(1)
end

if but(5) == 1
    numplant=str2double(app.NumdeplantaacensarDropDown.Value);
    if numplant > 1
        app.NumdeplantaacensarDropDown.Value=num2str(numplant-1);
        pause(0.1)
    end
end

if but(6) == 1
   T=readtable('C:\Users\kevin\Documents\MEGAsync\UTM\ProyectoHumedad\Proyecto Integrador de Ingenieria en Mecatrónica\DatosHumedad.txt'); %Leyendo Tabla
    % Copiando datos existentes 
    sz = size(T);%Tamaño de Matriz
    cantEle=sz(1,1);%Num. de elemento
    numplant=str2double(app.NumdeplantaacensarDropDown.Value);
    if numplant<=T.No(cantEle)
        app.NumdeplantaacensarDropDown.Value=num2str(numplant+1);
        pause(0.1)

    end  
end

if but(7) == 1
    T=readtable('C:\Users\kevin\Documents\MEGAsync\UTM\ProyectoHumedad\Proyecto Integrador de Ingenieria en Mecatrónica\DatosHumedad.txt'); %Leyendo Tabla
    opc=str2double(app.NumdeplantaacensarDropDown.Value);
    sz = size(T);%Tamaño de Matriz
    cantEle=sz(1,1);%Num. de elemento

    %prom=4535;
    pause(0.0001)
    movimientoServos(0,r)
    pause(1)
    movimientoServos(3,r)
    pause(1)
    movimientoServos(2,r)
    pause(1)
    movimientoServos(1,r)
    pause(1)
    prom=SensadoHumedad(r);
    pause(1)
    movimientoServos(0,r)
    pause(2)
    movimientoServos(3,r)
    pause(1)
    pause(0.0001)     
    Etiqueta=estatusHumedad(prom);

    if strcmp(app.NumdeplantaacensarDropDown.Value,' ')               
    elseif opc > cantEle
        archivosGuardados(1,prom,Etiqueta,datetime('now','Format','d-MM-y'),datestr(timeofday(datetime()),'hh:MM:ss'),opc);                                  
    elseif opc ==0
        archivosGuardados(1,prom,Etiqueta,datetime('now','Format','d-MM-y'),datestr(timeofday(datetime()),'hh:MM:ss'),opc);                                  
    else
        Etiqueta=estatusHumedad(prom);
        archivosGuardados(2,prom,Etiqueta,datetime('now','Format','d-MM-y'),datestr(timeofday(datetime()),'hh:MM:ss'),opc); 
    end
    clear T
    %*************************************
    %Actualizando

    T=readtable('C:\Users\kevin\Documents\MEGAsync\UTM\ProyectoHumedad\Proyecto Integrador de Ingenieria en Mecatrónica\DatosHumedad.txt'); %Leyendo Tabla
    % Copiando datos existentes 

    app.UITableDatos.Data=T;

    sz = size(T);%Tamaño de Matriz
    cantEle=sz(1,1);%Num. de elemento

    for pos = 1: cantEle
        app.NumdeplantaacensarDropDown.Items(pos)={num2str(T.No(pos))};
    end
    app.NumdeplantaacensarDropDown.Items(cantEle+1)={num2str(T.No(cantEle)+1)};
    app.NumdeplantaacensarDropDown.Value={num2str(T.No(cantEle)+1)};

    b=bar(app.UIAxes,T.No,T.Humedad,'FaceColor','g');
    b.FaceColor = 'flat';


    for pos = 1:cantEle
         if T.Humedad(pos) >= 0 & T.Humedad(pos) <= 50
             b.CData(pos,:) = [0.26,0.91,0.17];
        end
        if T.Humedad(pos) > 50 & T.Humedad(pos) <= 350
             b.CData(pos,:) = [0.23,0.92,0.86];
        end
        if T.Humedad(pos) > 350 & T.Humedad(pos) <= 600
             b.CData(pos,:) = [0.17,0.48,0.91];
        end
        if T.Humedad(pos) > 600 & T.Humedad(pos) <= 800
             b.CData(pos,:) = [0.91,0.75,0.17];
        end
        if T.Humedad(pos) > 800
             b.CData(pos,:) = [0.91,0.17,0.17];
        end
    end
end

 %*********************************************
if but(10) == 1 
    if band==1
        mod=0;
        band=0;
    else
        mod=1;
        band=1;
    end
    pause(0.0001) 
end

if mod==1
    if ax(5) >= sens 
    movimientoServos(7,r)
    elseif ax(5) <=-sens
        movimientoServos(8,r)
    elseif ax(4) >=sens
        movimientoServos(5,r)
    elseif ax(4) <=-sens
        movimientoServos(6,r)
    else  
        movimientoServos(0,r)
    end
else
    if cruz == 0 %Alzado
        movimientoServos(0,r)
    elseif cruz ==180 %Acostado
        movimientoServos(1,r)
    elseif cruz ==90%Sensor Arriba
        movimientoServos(3,r)
    elseif cruz ==270%Sensor Abajo
        movimientoServos(2,r)
    end

    if but(1) == 1
        movimientoServos(8,r)
    elseif but(2) == 1
        movimientoServos(6,r)
    elseif but(3) == 1
        movimientoServos(5,r)
    elseif but(4) == 1
        movimientoServos(7,r)
    end
end
clear T

