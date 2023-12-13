function valsens=SensadoHumedadFuzzy(r)

    myserialdevice = serialdev(r,'/dev/serial0',9600); %Inicia Comunicación serial
    write(myserialdevice,'4','uint16'); % Envio de valor '0' para activar lectura de censor
    for j = 1:4 %Lectura de 3 caracteres como maximo (min=0 || max = 800)
        caracter=read(myserialdevice,1,'char');    
        leer(j)= caracter;
    end
    valsens=str2double(leer); % Convierte cadena de caracteres a número
    clear myserialdevice
end