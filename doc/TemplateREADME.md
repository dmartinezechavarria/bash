<a name="contenido"></a>
# Contenido

Este repositorio contiene una colección de utilidades para Bash.

<a name="como-instalar"></a>
# Como instalar

* Clonar o descargar el repositorio a una carpeta de tu equipo (preferentemente **z:/bash**).
* Copiar el fichero **config.example.properties** en su misma ubicación y renombrar la copia a **config.properties**.
* Ajustar las configuraciones del fichero **config.properties**.
* Abrir o crear el fichero **.bashrc** (normalmente **z:** en nuestros equipos) y añadir lo siguiente:

```bash
#!/bin/bash

#Pedir contraseña para la clave RSA al iniciar shell
if [ -z ${SSH_AGENT_PID} ]
then
    eval `ssh-agent -s`
    ssh-add /z/.ssh/id_rsa
else
    echo "SSH Agent already running in PID ${SSH_AGENT_PID}"
fi

#Incluimos las funciones de bash
SCRIPTPATH="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"  #La variable SCRIPTPATH debería ser la ruta hasta donde hayas clonado/copiado el repositorio
source $SCRIPTPATH/bash/include.sh
```
* Abrir Git Bash para que cargue el fichero **.bashrc**.



