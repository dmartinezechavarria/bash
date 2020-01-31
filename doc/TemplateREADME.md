# Contenido

Este repositorio contiene una colecci�n de utilidades para Bash.

# Como instalar

* Clonar o descargar el repositorio a una carpeta de tu equipo (preferentemente **z:/bash**).
* Copiar el fichero **config.example.properties** en su misma ubicaci�n y renombrar la copia a **config.properties**.
* Ajustar las configuraciones del fichero **config.properties**.
* Abrir o crear el fichero **.bashrc** (normalmente **z:** en nuestros equipos) y a�adir lo siguiente:

```bash
#!/bin/bash

#Pedir contrase�a para la clave RSA al iniciar shell
eval `ssh-agent -s`
ssh-add /z/.ssh/id_rsa

#Incluimos las funciones de bash
SCRIPTPATH="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"  #La variable SCRIPTPATH deber�a ser la ruta hasta donde hayas clonado/copiado el repositorio
source $SCRIPTPATH/bash/include.sh
```
* Abrir Git Bash para que cargue el fichero **.bashrc**.



