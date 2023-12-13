% clear all
% clc
% 
% % Estableciendo conexiones
% r = raspi('192.168.0.101'); %Raspberry
% joy = vrjoystick(1); %Joystick
Humedad = readfis('Humedad.fis'); %Archivo Fuzzy

%Bandera ciclo
band=true;
nMuestreo=3; %Numero de muestras tomadas para el sensado

while band==true

    %LEYENDO CONTROL (BOTONES)
    for cont = 1:10   
    but(cont)= button(joy, cont); 
    end
    
    if but(8)==1 %CONDICIÓN SI BOTÓN 8 (MENÚ) ES ACTIVADO
        if band==true
            band=false;
         else
            band=true;
        end
    end
    
    %SENSANDO HUMEDAD
    %******************************************************************************
%      myserialdevice = serialdev(r,'/dev/serial0',9600); %Inicia Comunicación serial
%         write(myserialdevice,'4','uint16'); % Envio de valor '4' para activar lectura de censor
%         for j = 1:4 %Lectura de 4 caracteres como maximo (min=0 || max = 1024)
%             caracter=read(myserialdevice,1,'char');    
%             leer(j)= caracter;
%         end
%         u=str2double(leer); % Valor sensado, convierte cadena de caracteres a número

    sum = 0;
    for i = 1:nMuestreo %Lectura de 10 datos para promediar censado
        myserialdevice = serialdev(r,'/dev/serial0',9600); %Inicia Comunicación serial
        write(myserialdevice,'4','uint16'); % Envio de valor '4' para activar lectura de censor
        for j = 1:4 %Lectura de 3 caracteres como maximo (min=0 || max = 1024)
            caracter=read(myserialdevice,1,'char');    
            leer(j)= caracter;
        end
        datoN=str2double(leer); % Convierte cadena de caracteres a número
        sum = datoN+sum; %suma de datos
        clear myserialdevice
    end
    u=sum/nMuestreo; %Promedio de datos
    
    
    %******************************************************************************
    
    %                           CONTROL FUZZY
    %******************************************************************************
    % Corriendo Fuzzy
    
    Ctrlfzzy=sim('FUZZYCONTROL.slx');
    val=Ctrlfzzy.VALOUT_BOMBA(1,1)
    %******************************************************************************
    
    %Activación de motores según la humedad registrada
    myserialdevice = serialdev(r,'/dev/serial0',9600);
    
    %[390 - 450]--->Poco Humedo
    if val >=8.56 && val <=  25        
        write(myserialdevice,'D','uint16'); 
        
    %[450 - 538]--->Poco Seco     
    elseif val >25 && val <=45      
        write(myserialdevice,'C','uint16');
        
    %[538 - 815]--->Seco    
    elseif val >45 && val <=65    
        write(myserialdevice,'B','uint16');
    
    %[>815]-------->Muy seco
    elseif val > 65                   
        write(myserialdevice,'A','uint16'); 
    
    %[<390]-------->Humedo
    elseif val < 8.56                   
        write(myserialdevice,'E','uint16'); 
    end
    clear myserialdevice     
end

%CERRANDO Y APAGANDO MOTOR
myserialdevice = serialdev(r,'/dev/serial0',9600);
write(myserialdevice,'E','uint16'); 

fprintf('Exit\n')
clear Humedad Ctrlfzzy;