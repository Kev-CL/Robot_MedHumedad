function humedad=estatusHumedad(Humedadf)
    if Humedadf >= 0 & Humedadf <= 50
        humedad='EXTREMEDAMENTE HUMEDO';
    end
    if Humedadf > 50 & Humedadf <= 350
        humedad='HUMEDO';
    end
    if Humedadf > 350 & Humedadf <= 600
        humedad='POCO HUMEDO';
    end
    if Humedadf > 600 & Humedadf <= 800
        humedad='SECO';
    end
    if Humedadf > 800
        humedad='MUY SECO';
    end
end
