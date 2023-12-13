% opc = 0 -> ELEVADO
% opc = 1 -> RECOSTADO
% opc = 2 -> SENSOR ABAJO
% opc = 3 -> SENSOR ARRIBA
function activacionBomba(val,r)  
    val1=val;
    myserialdevice = serialdev(r,'/dev/serial0',9600); %Inicia Comunicación serial
    write(myserialdevice,val1,'uint16'); % Envio de valor '0' para activar lectura de sensor
    clear myserialdevice;
end