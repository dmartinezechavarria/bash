# Índice

  - [Contenido](#contenido)
  - [Como instalar](#como-instalar)
  - [Alias (alias.sh)](#alias-(alias.sh))
  - [Git/Feature (git/feature.sh)](#git/feature-(git/feature.sh))
    - [gitfeaturestart()](#gitfeaturestart())
    - [gitfeaturefinish()](#gitfeaturefinish())
    - [gitfeatureupdate()](#gitfeatureupdate())
    - [gitfeatureremote()](#gitfeatureremote())
  - [Git/Helpers (git/helpers.sh)](#git/helpers-(git/helpers.sh))
    - [cdgit()](#cdgit())
    - [gitcheckoutall()](#gitcheckoutall())
    - [gitcheckoutremoteall()](#gitcheckoutremoteall())
    - [gitversion()](#gitversion())
    - [gitbranch()](#gitbranch())
    - [gitbranchall()](#gitbranchall())
    - [gitpullall()](#gitpullall())
    - [gitstatusall()](#gitstatusall())
    - [gitlogall()](#gitlogall())
    - [gitfetchall()](#gitfetchall())
  - [Git/Hotfix (git/hotfix.sh)](#git/hotfix-(git/hotfix.sh))
    - [githotfixstart()](#githotfixstart())
    - [githotfixmerge()](#githotfixmerge())
    - [githotfixfinish()](#githotfixfinish())
  - [Git/Release (git/release.sh)](#git/release-(git/release.sh))
    - [gitreleasestart()](#gitreleasestart())
    - [gitreleasemerge()](#gitreleasemerge())
    - [gitreleasefinish()](#gitreleasefinish())
  - [Helpers (helpers.sh)](#helpers-(helpers.sh))
    - [printseparator()](#printseparator())
    - [printlinebreak()](#printlinebreak())
    - [printtext()](#printtext())
    - [printsuccess()](#printsuccess())
    - [printerror()](#printerror())
    - [printwarning()](#printwarning())
    - [printarray()](#printarray())
    - [debugarray()](#debugarray())
    - [joinby()](#joinby())
    - [printtitle()](#printtitle())
    - [killsshagent()](#killsshagent())
  - [Rocketchat (rocketchat.sh)](#rocketchat-(rocketchat.sh))
    - [rocketchatsendmessage()](#rocketchatsendmessage())
  - [Servers/Development (servers/development.sh)](#servers/development-(servers/development.sh))
    - [devremakeconfig()](#devremakeconfig())
    - [devcleancache()](#devcleancache())
    - [devlogphp()](#devlogphp())
  - [Servers/Sync (servers/sync.sh)](#servers/sync-(servers/sync.sh))
    - [syncservers()](#syncservers())
  - [Styles (styles.sh)](#styles-(styles.sh))



# Contenido

Este repositorio contiene una colección de utilidades para Bash.

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



# Alias (alias.sh)

Contiene alias utiles para el resto de scripts y el uso normal de bash



# Git/Feature (git/feature.sh)

Contiene funciones para realizar la parte GIT de las features

* [gitfeaturestart()](#gitfeaturestart)
* [gitfeaturefinish()](#gitfeaturefinish)
* [gitfeatureupdate()](#gitfeatureupdate)
* [gitfeatureremote()](#gitfeatureremote)


## gitfeaturestart()

Crea una nueva feature a partir de una rama

### Example

```bash
gitfeaturestart GPHADPR-2104 dev
```

### Arguments

* **$1** (string): Nombre para la feature, se generara la rama feature/nombre.
* **$2** (string): Rama local de origen para la feature.

## gitfeaturefinish()

Finaliza una feature mezclandola con la rama recibida
Una vez terminada elimina la rama release/xxx

### Example

```bash
gitfeaturefinish GPHADPR-2104 dev
```

### Arguments

* **$1** (string): Nombre de la feature.
* **$2** (string): Rama sobre la que finalizar la feature.

## gitfeatureupdate()

Se trae los cambios de la rama recibida a la feature

### Example

```bash
gitfeatureupdate GPHADPR-2104 dev
```

### Arguments

* **$1** (string): Nombre de la feature.
* **$2** (string): Rama desde la que actualizar la feature.

## gitfeatureremote()

Convierte la rama de la release en una rama remota para trabajar con otras personas

### Example

```bash
gitfeatureremote GPHADPR-2104
```

### Arguments

* **$1** (string): Nombre de la feature.

# Git/Helpers (git/helpers.sh)

Contiene funciones generales de GIT

* [cdgit()](#cdgit)
* [gitcheckoutall()](#gitcheckoutall)
* [gitcheckoutremoteall()](#gitcheckoutremoteall)
* [gitversion()](#gitversion)
* [gitbranch()](#gitbranch)
* [gitbranchall()](#gitbranchall)
* [gitpullall()](#gitpullall)
* [gitstatusall()](#gitstatusall)
* [gitlogall()](#gitlogall)
* [gitfetchall()](#gitfetchall)


## cdgit()

Permite acceder rapidamente al directorio que contiene los repositorios GIT

### Example

```bash
cdgit
```

_Function has no arguments._

## gitcheckoutall()

Realiza un checkout a una rama local sobre todos los repositorio

### Example

```bash
gitcheckoutall feature/PES
```

### Arguments

* **$1** (string): Nombre de la rama local.

## gitcheckoutremoteall()

Realiza un checkout a una rama remota sobre todos los repositorios

### Example

```bash
gitcheckoutremoteall feature/PES
```

### Arguments

* **$1** (string): Nombre de la rama remota.

## gitversion()

Devuelve la version del CHANGELOG para el repositorio actual

### Example

```bash
gitversion
1.2.6
```

_Function has no arguments._

## gitbranch()

Devuelve la rama del repositorio actual

### Example

```bash
gitbranch
feature/PES
```

_Function has no arguments._

## gitbranchall()

Devuelve la rama de todos los repositorios

### Example

```bash
gitbranchall
```

_Function has no arguments._

## gitpullall()

Realiza un pull en todos los repositorios

### Example

```bash
gitpullall
```

_Function has no arguments._

## gitstatusall()

Muestra el estado de todos los repositorios

### Example

```bash
gitstatusall
```

_Function has no arguments._

## gitlogall()

Muestra el log de todos los repositorios

### Example

```bash
gitlogall 15
```

### Arguments

* **$1** (int): Numero de lineas del log a mostrar.

## gitfetchall()

Realiza un fetch en todos los repositorios

### Example

```bash
gitfetchall
```

_Function has no arguments._

# Git/Hotfix (git/hotfix.sh)

Contiene funciones para realizar la parte GIT de los hotfix

* [githotfixstart()](#githotfixstart)
* [githotfixmerge()](#githotfixmerge)
* [githotfixfinish()](#githotfixfinish)


## githotfixstart()

Crea un nuevo hotfix a partir de una rama y envia un aviso a Rocket.Chat

### Example

```bash
githotfixstart
```

### Arguments

* **$1** (string): Rama de origen para el hotfix, si no se pasa usa master.

## githotfixmerge()

Mezcla los cambios del hotfix sobre la rama pasada como parametro

### Example

```bash
githotfixmerge dev
```

### Arguments

* **$1** (string): Rama sobre la que mezclar el hotfix.

## githotfixfinish()

Finaliza el hotfix, creando una tag y eliminando la rama del hotfix

### Example

```bash
githotfixfinish
```

### Arguments

* **$1** (string): Rama sobre la que finalizar el hotfix, si no se pasa usa master.

# Git/Release (git/release.sh)

Contiene funciones para realizar la parte GIT de las releases

* [gitreleasestart()](#gitreleasestart)
* [gitreleasemerge()](#gitreleasemerge)
* [gitreleasefinish()](#gitreleasefinish)


## gitreleasestart()

Crea una nueva release a partir de una rama y envia un aviso a Rocket.Chat

### Example

```bash
gitreleasestart
```

### Arguments

* **$1** (string): Rama de origen para la release, si no se pasa se usa dev.

## gitreleasemerge()

Mezcla los cambios de la release sobre la rama pasada como parametro

### Example

```bash
gitreleasemerge dev
```

### Arguments

* **$1** (string): Rama sobre la que mezclar la release.

## gitreleasefinish()

Finaliza la release, creando una tag y eliminando la rama de la release

### Example

```bash
gitreleasefinish
```

### Arguments

* **$1** (string): Rama sobre la que finalizar la release, si no se pasa usa master.

# Helpers (helpers.sh)

Contiene funciones generales para bash que utilizan el resto de scripts

* [printseparator()](#printseparator)
* [printlinebreak()](#printlinebreak)
* [printtext()](#printtext)
* [printsuccess()](#printsuccess)
* [printerror()](#printerror)
* [printwarning()](#printwarning)
* [printarray()](#printarray)
* [debugarray()](#debugarray)
* [joinby()](#joinby)
* [printtitle()](#printtitle)
* [killsshagent()](#killsshagent)


## printseparator()

Dibuja un separador del ancho del terminal

### Example

```bash
printseparator
```

_Function has no arguments._

## printlinebreak()

Realiza un salto de linea

### Example

```bash
printlinebreak
```

_Function has no arguments._

## printtext()

Escribe un mensaje

### Example

```bash
printtext "Mensaje normalucho"
```

### Arguments

* **$1** (string): Mensaje.

## printsuccess()

Escribe un mensaje de exito

### Example

```bash
printsuccess "Mensaje de exito"
```

### Arguments

* **$1** (string): Mensaje.

## printerror()

Escribe un mensaje de error

### Example

```bash
printerror "Mensaje de error"
```

### Arguments

* **$1** (string): Mensaje.

## printwarning()

Escribe un mensaje de alerta

### Example

```bash
printwarning "Mensaje de alerta"
```

### Arguments

* **$1** (string): Mensaje.

## printarray()

Muestra un array

### Example

```bash
printarray 1 2 3
```

### Arguments

* **...** (any): Elementos del array.

## debugarray()

Muestra una representacion de debug de un array

### Example

```bash
debugarray 1 2 3
```

### Arguments

* **...** (any): Elementos del array.

## joinby()

Concatena elementos pasados como parametros o elemento de un array separados por un caracter

### Example

```bash
joinby . 1 2 3
1.2.3
```

### Arguments

* **$1** (string): Separador.
* **...** (any): Elementos a unir.

## printtitle()

Escribe un titulo

### Example

```bash
printtitle "Texto del titulo"
```

### Arguments

* **$1** (string): Texto del titulo.

## killsshagent()

Mata los procesos de SSH agent que haya corriendo

### Example

```bash
killsshagent
```

_Function has no arguments._

# Rocketchat (rocketchat.sh)

Contiene funciones para realizar acciones sobre la plataforma Rocket.Chat

* [rocketchatsendmessage()](#rocketchatsendmessage)


## rocketchatsendmessage()

Envia un mensaje a un canal de Rocketchat

### Example

```bash
rocketchatsendmessage "@dmartinezechavarria" "Mensaje de prueba"
```

### Arguments

* **$1** (string): Canal, puede ser un canal (ap2_arsys) o un usuario (@dmartinezechavarria).
* **$2** (string): Mensaje a enviar.

# Servers/Development (servers/development.sh)

Contiene funciones para interactuar con el servidor de desarrollo

* [devremakeconfig()](#devremakeconfig)
* [devcleancache()](#devcleancache)
* [devlogphp()](#devlogphp)


## devremakeconfig()

Ejecuta el remake de config

### Example

```bash
devremakeconfig
```

_Function has no arguments._

## devcleancache()

Elimina la cache de smarty

### Example

```bash
devcleancache
```

_Function has no arguments._

## devlogphp()

Muestra el log de PHP FPM del servidor de desarrollo

### Example

```bash
devlogphp
```

_Function has no arguments._

# Servers/Sync (servers/sync.sh)

Contiene funciones para la sincronizacion de los servidores

* [syncservers()](#syncservers)


## syncservers()

Ejecuta la sincronizacion de servidores para un proyecto y entorno

### Example

```bash
syncservers pdc pre
```

### Arguments

* **$1** (string): Proyecto, puede ser pdc o webadmin.
* **$2** (string): Entorno, puede ser pre o pro.

# Styles (styles.sh)

Variables con estilos para las salidas de los comandos



