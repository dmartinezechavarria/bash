# Índice

  - [Contenido](#contenido)
  - [Como instalar](#como-instalar)
  - [Alias (alias.sh)](#alias-(alias.sh))
  - [Git/Alias (git/alias.sh)](#git/alias-(git/alias.sh))
  - [Git/Feature (git/feature.sh)](#git/feature-(git/feature.sh))
    - [gitfeaturestart()](#gitfeaturestart())
    - [gitfeaturefinish()](#gitfeaturefinish())
    - [gitfeatureupdate()](#gitfeatureupdate())
    - [gitfeatureremote()](#gitfeatureremote())
  - [Git/Helpers (git/helpers.sh)](#git/helpers-(git/helpers.sh))
    - [cdgit()](#cdgit())
    - [gitcheckout()](#gitcheckout())
    - [gitcheckoutremote()](#gitcheckoutremote())
    - [gitversion()](#gitversion())
    - [gitbranch()](#gitbranch())
    - [gitbranchall()](#gitbranchall())
    - [gitpull()](#gitpull())
    - [gitstatus()](#gitstatus())
    - [gitlog()](#gitlog())
    - [gitfetch()](#gitfetch())
    - [gitbranchages()](#gitbranchages())
    - [gitbranchremove()](#gitbranchremove())
  - [Git/Hotfix (git/hotfix.sh)](#git/hotfix-(git/hotfix.sh))
    - [githotfixstartalert()](#githotfixstartalert())
    - [githotfixstart()](#githotfixstart())
    - [githotfixfinish()](#githotfixfinish())
    - [githotfixfinishalert()](#githotfixfinishalert())
  - [Git/Release (git/release.sh)](#git/release-(git/release.sh))
    - [gitreleasestartalert()](#gitreleasestartalert())
    - [gitreleasestart()](#gitreleasestart())
    - [gitreleasefinish()](#gitreleasefinish())
    - [gitreleasefinishalert()](#gitreleasefinishalert())
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
    - [printwalle()](#printwalle())
    - [killsshagent()](#killsshagent())
    - [promptformultiselect()](#promptformultiselect())
  - [Rocketchat (rocketchat.sh)](#rocketchat-(rocketchat.sh))
    - [rocketchatsendmessage()](#rocketchatsendmessage())
  - [Servers/Development (servers/development.sh)](#servers/development-(servers/development.sh))
    - [devremakeconfig()](#devremakeconfig())
    - [devsetmemoryvars()](#devsetmemoryvars())
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



# Git/Alias (git/alias.sh)

Contiene alias para Git



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
#Iniciar feature
gitfeaturestart GPHADPR-2104 dev

#Opcionalmente nos traemos los cambios de dev a la feature cuando queramos
gitfeatureupdate GPHADPR-2104 dev 

#Realizar cambios de la feature y actualizar Changelog
git add .
git commit -m "GPHADPR-2104 - ...."

#Terminar feature 
gitfeaturefinish GPHADPR-2104 dev
```

### Arguments

* **$1** (string): Nombre para la feature, se generara la rama feature/nombre.
* **$2** (string): Rama local de origen para la feature.

## gitfeaturefinish()

Finaliza una feature mezclandola con la rama recibida
Una vez terminada elimina la rama feature/xxx

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

Convierte la rama de la feature en una rama remota para trabajar con otras personas

### Example

```bash
gitfeatureremote GPHADPR-2104
```

### Arguments

* **$1** (string): Nombre de la feature.

# Git/Helpers (git/helpers.sh)

Contiene funciones generales de GIT

* [cdgit()](#cdgit)
* [gitcheckout()](#gitcheckout)
* [gitcheckoutremote()](#gitcheckoutremote)
* [gitversion()](#gitversion)
* [gitbranch()](#gitbranch)
* [gitbranchall()](#gitbranchall)
* [gitpull()](#gitpull)
* [gitstatus()](#gitstatus)
* [gitlog()](#gitlog)
* [gitfetch()](#gitfetch)
* [gitbranchages()](#gitbranchages)
* [gitbranchremove()](#gitbranchremove)


## cdgit()

Permite acceder rapidamente al directorio que contiene los repositorios GIT

### Example

```bash
cdgit
```

_Function has no arguments._

## gitcheckout()

Realiza un checkout a una rama local sobre los repositorios seleccionados

### Example

```bash
gitcheckout feature/PES all
```

### Arguments

* **$1** (string): Nombre de la rama local.
* **$2** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitcheckoutremote()

Realiza un checkout a una rama remota sobre los repositorios seleccionados

### Example

```bash
gitcheckoutremote feature/PES all
```

### Arguments

* **$1** (string): Nombre de la rama local.
* **$2** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

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

## gitpull()

Realiza un pull sobre los repositorios seleccionados

### Example

```bash
gitpull all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitstatus()

Muestra el estado de los repositorios seleccionados

### Example

```bash
gitstatus all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitlog()

Muestra el log de los repositorios seleccionados

### Example

```bash
gitlog all 15
```

### Arguments

* **$1** (int): Numero de lineas del log a mostrar.
* **$2** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitfetch()

Realiza un fetch en los repositorios seleccionados

### Example

```bash
gitfetch all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitbranchages()

Muestra un resumen de las ramas con la fecha y autor de su ultimo commit

### Example

```bash
gitbranchages
```

_Function has no arguments._

## gitbranchremove()

Elimina una rama (local y remota) en los repositorios seleccionados

### Example

```bash
gitbranchremove feature/PES all
```

### Arguments

* **$1** (string): Nombre de la rama.
* **$2** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

# Git/Hotfix (git/hotfix.sh)

Contiene funciones para realizar la parte GIT de los hotfix

* [githotfixstartalert()](#githotfixstartalert)
* [githotfixstart()](#githotfixstart)
* [githotfixfinish()](#githotfixfinish)
* [githotfixfinishalert()](#githotfixfinishalert)


## githotfixstartalert()

Envia un aviso de comienzo de hotfix a Rocket.Chat en los repositorios seleccionados

### Example

```bash
githotfixstartalert
```

_Function has no arguments._

## githotfixstart()

Crea un nuevo hotfix a partir de una rama y envia un aviso a Rocket.Chat

### Example

```bash
#Iniciar hotfix
githotfixstartalert
githotfixstart

#Realizar cambios para el hotfix y actualizar Changelog arriba y abajo
git add .
git commit -m "Hotfix changelog"

#Terminar hotfix 
githotfixfinish

#Desplegar el hotfix
...

#Notificar despligue
githotfixfinishalert
```

_Function has no arguments._

## githotfixfinish()

Finaliza el hotfix, creando una tag y eliminando la rama del hotfix

### Example

```bash
githotfixfinish
```

_Function has no arguments._

## githotfixfinishalert()

Envia un aviso de final de hotfix a Rocket.Chat en los repositorios seleccionados

### Example

```bash
githotfixfinishalert
```

_Function has no arguments._

# Git/Release (git/release.sh)

Contiene funciones para realizar la parte GIT de las releases

* [gitreleasestartalert()](#gitreleasestartalert)
* [gitreleasestart()](#gitreleasestart)
* [gitreleasefinish()](#gitreleasefinish)
* [gitreleasefinishalert()](#gitreleasefinishalert)


## gitreleasestartalert()

Envia un aviso de comienzo de release a Rocket.Chat en los repositorios seleccionados

### Example

```bash
gitreleasestartalert
```

_Function has no arguments._

## gitreleasestart()

Crea una nueva release a partir de dev

### Example

```bash
#Iniciar release
gitreleasestartalert
gitreleasestart

#Actualizar Changelog arriba y abajo
git add .
git commit -m "Release changelog"

#Terminar release 
gitreleasefinish

#Desplegar la release
...

#Notificar despligue
gitreleasefinishalert
```

_Function has no arguments._

## gitreleasefinish()

Finaliza la release, creando una tag y eliminando la rama de la release

### Example

```bash
gitreleasefinish
```

_Function has no arguments._

## gitreleasefinishalert()

Envia un aviso de final de release a Rocket.Chat en los repositorios seleccionados

### Example

```bash
gitreleasefinishalert
```

_Function has no arguments._

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
* [printwalle()](#printwalle)
* [killsshagent()](#killsshagent)
* [promptformultiselect()](#promptformultiselect)


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

## printwalle()

Dibuja a Wall-e

### Example

```bash
printwalle
```

_Function has no arguments._

## killsshagent()

Mata los procesos de SSH agent que haya corriendo

### Example

```bash
killsshagent
```

_Function has no arguments._

## promptformultiselect()

Muestra un picker multiselect

### Example

```bash
promptformultiselect results "$(echo ${array[@]})" "panel procws" 
```

### Arguments

* **$1** (array): Variable a la que se devolverá el resultado.
* **$2** (string): String de opciones separadas por espacio.
* **$3** (string): Opcional, String de las opciones seleccionadas por defecto separadas por espacio.

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
* [devsetmemoryvars()](#devsetmemoryvars)
* [devcleancache()](#devcleancache)
* [devlogphp()](#devlogphp)


## devremakeconfig()

Ejecuta el remake de config

### Example

```bash
devremakeconfig
```

_Function has no arguments._

## devsetmemoryvars()

Setea las variables de memoria necesarias para arrancar AP-2

### Example

```bash
devsetmemoryvars
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



