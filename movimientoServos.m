% opc = 0 -> ELEVADO
% opc = 1 -> RECOSTADO
% opc = 2 -> SENSOR ABAJO
% opc = 3 -> SENSOR ARRIBA
function movimientoServos(val,r)
   
    opc=num2str(val);
    myserialdevice = serialdev(r,'/dev/serial0',9600); %Inicia Comunicación serial
    write(myserialdevice,opc,'uint16'); % Envio de valor '0' para activar lectura de censor
    clear myserialdevice
end