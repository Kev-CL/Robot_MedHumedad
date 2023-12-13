%--CAMARA--

function im=camara(cam)
    im = snapshot(cam);
    image(im);
    im = imresize(im,[176 144]);
    title("Camara RaspBerry")
    drawnow
end