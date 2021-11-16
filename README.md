# Índice

  - [Contenido](#contenido)
  - [Como instalar](#como-instalar)
  - [Admines (admines.sh)](#admines-(admines.sh))
    - [adminesversion()](#adminesversion())
    - [admineslistfunctions()](#admineslistfunctions())
  - [Alias (alias.sh)](#alias-(alias.sh))
  - [Composer/Alias (composer/alias.sh)](#composer/alias-(composer/alias.sh))
  - [Composer/Helpers (composer/helpers.sh)](#composer/helpers-(composer/helpers.sh))
    - [composerinstall()](#composerinstall())
    - [composerupdate()](#composerupdate())
    - [composerdumpautoload()](#composerdumpautoload())
  - [Git/Alias (git/alias.sh)](#git/alias-(git/alias.sh))
  - [Git/Feature (git/feature.sh)](#git/feature-(git/feature.sh))
    - [gitfeaturestart()](#gitfeaturestart())
    - [gitfeaturefinish()](#gitfeaturefinish())
    - [gitfeatureupdate()](#gitfeatureupdate())
    - [gitfeatureremote()](#gitfeatureremote())
    - [gitfeaturecancel()](#gitfeaturecancel())
  - [Git/Helpers (git/helpers.sh)](#git/helpers-(git/helpers.sh))
    - [cdgit()](#cdgit())
    - [gitcheckout()](#gitcheckout())
    - [gitmerge()](#gitmerge())
    - [gitcheckoutremote()](#gitcheckoutremote())
    - [gitversion()](#gitversion())
    - [gitbranch()](#gitbranch())
    - [gitbranchall()](#gitbranchall())
    - [gitremote()](#gitremote())
    - [gitremoteall()](#gitremoteall())
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
    - [githotfixcancel()](#githotfixcancel())
    - [githotfixfinishalert()](#githotfixfinishalert())
  - [Git/Release (git/release.sh)](#git/release-(git/release.sh))
    - [gitreleasestartalert()](#gitreleasestartalert())
    - [gitreleasestart()](#gitreleasestart())
    - [gitreleasefinish()](#gitreleasefinish())
    - [gitreleasecancel()](#gitreleasecancel())
    - [gitreleasefinishalert()](#gitreleasefinishalert())
  - [Googlechat (googlechat.sh)](#googlechat-(googlechat.sh))
    - [googlechatwebhookmessage()](#googlechatwebhookmessage())
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
    - [printtitleconnect()](#printtitleconnect())
    - [printwalle()](#printwalle())
    - [killsshagent()](#killsshagent())
    - [promptformultiselect()](#promptformultiselect())
  - [Jira (jira.sh)](#jira-(jira.sh))
    - [jirasendnotice()](#jirasendnotice())
  - [Rocketchat (rocketchat.sh)](#rocketchat-(rocketchat.sh))
    - [rocketchatsendmessage()](#rocketchatsendmessage())
  - [Servers/Deploy (servers/deploy.sh)](#servers/deploy-(servers/deploy.sh))
  - [Servers/Development (servers/development.sh)](#servers/development-(servers/development.sh))
    - [devremakeconfig()](#devremakeconfig())
    - [devxdebugtunnel()](#devxdebugtunnel())
    - [devsetmemoryvars()](#devsetmemoryvars())
    - [devkeystonegeneratetoken()](#devkeystonegeneratetoken())
    - [devkeystonesetmemory()](#devkeystonesetmemory())
    - [devkeystone()](#devkeystone())
    - [devcleancache()](#devcleancache())
    - [devlogphp()](#devlogphp())
    - [devlogprocess()](#devlogprocess())
    - [devremovedomainweb()](#devremovedomainweb())
  - [Servers/Machines (servers/machines.sh)](#servers/machines-(servers/machines.sh))
    - [machinesdnshealthy()](#machinesdnshealthy())
    - [machinednshealthy()](#machinednshealthy())
  - [Servers/Sync (servers/sync.sh)](#servers/sync-(servers/sync.sh))
    - [syncservers()](#syncservers())
  - [Styles (styles.sh)](#styles-(styles.sh))
  - [Updater (updater.sh)](#updater-(updater.sh))



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



# Admines (admines.sh)

Contiene funciones para realizar acciones sobre los admines

* [adminesversion()](#adminesversion)
* [admineslistfunctions()](#admineslistfunctions)


## adminesversion()

Devuelve las versiones de los admines en una máquina Linux

### Example

```bash
adminesversion entorno256.arsysdesarrollo.lan
```

### Arguments

* **$1** (string): Hostname de la maquina

## admineslistfunctions()

Extrae las funciones de un fichero perl

### Example

```bash
admineslistfunctions admindns.pm
```

### Arguments

* **$1** (string): Ruta al fichero del que extraer las funciones.

# Alias (alias.sh)

Contiene alias utiles para el resto de scripts y el uso normal de bash



# Composer/Alias (composer/alias.sh)

Contiene alias para Composer



# Composer/Helpers (composer/helpers.sh)

Contiene funciones para realizar acciones de composer masivamente sobre los repositorios

* [composerinstall()](#composerinstall)
* [composerupdate()](#composerupdate)
* [composerdumpautoload()](#composerdumpautoload)


## composerinstall()

Realiza un composer install en los repositorios seleccionados

### Example

```bash
composerinstall all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## composerupdate()

Realiza un composer update en los repositorios seleccionados

### Example

```bash
composerupdate all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## composerdumpautoload()

Realiza un composer dump-autoload en los repositorios seleccionados

### Example

```bash
composerdumpautoload all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

# Git/Alias (git/alias.sh)

Contiene alias para Git



# Git/Feature (git/feature.sh)

Contiene funciones para realizar la parte GIT de las features

* [gitfeaturestart()](#gitfeaturestart)
* [gitfeaturefinish()](#gitfeaturefinish)
* [gitfeatureupdate()](#gitfeatureupdate)
* [gitfeatureremote()](#gitfeatureremote)
* [gitfeaturecancel()](#gitfeaturecancel)


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

## gitfeaturecancel()

Cancelae la feature eliminando la rama y volviendo a la rama origen con los cambios pendientes

### Example

```bash
gitfeaturecancel GPHADPR-2104 dev
```

### Arguments

* **$1** (string): Nombre de la feature.
* **$2** (string): Rama desde la que se inicio la feature.

# Git/Helpers (git/helpers.sh)

Contiene funciones generales de GIT

* [cdgit()](#cdgit)
* [gitcheckout()](#gitcheckout)
* [gitmerge()](#gitmerge)
* [gitcheckoutremote()](#gitcheckoutremote)
* [gitversion()](#gitversion)
* [gitbranch()](#gitbranch)
* [gitbranchall()](#gitbranchall)
* [gitremote()](#gitremote)
* [gitremoteall()](#gitremoteall)
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

## gitmerge()

Realiza un merge --no-ff de la rama pasada como parametro sobre la rama actual sobre los repositorios seleccionados

### Example

```bash
gitmerge dev all
```

### Arguments

* **$1** (string): Nombre de la rama local a mezclar.
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

## gitremote()

Devuelve el remoto de los repositorios seleccionados

### Example

```bash
gitremote all
```

### Arguments

* **$1** (string): Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.

## gitremoteall()

Devuelve el remoto de todos los repositorios

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
* [githotfixcancel()](#githotfixcancel)
* [githotfixfinishalert()](#githotfixfinishalert)


## githotfixstartalert()

Envia un aviso de comienzo de hotfix al chat en los repositorios seleccionados

### Example

```bash
githotfixstartalert
```

_Function has no arguments._

## githotfixstart()

Crea un nuevo hotfix a partir de la rama master

### Example

```bash
#Iniciar hotfix
githotfixstartalert
githotfixstart

#Realizar cambios para el hotfix y actualizar Changelog arriba y abajo
git add .
git commit -m "Hotfix x.x.x"

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

## githotfixcancel()

Cancela el hotfix y vuelve a la rama master

### Example

```bash
githotfixcancel
```

_Function has no arguments._

## githotfixfinishalert()

Envia un aviso de final de hotfix al chat en los repositorios seleccionados

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
* [gitreleasecancel()](#gitreleasecancel)
* [gitreleasefinishalert()](#gitreleasefinishalert)


## gitreleasestartalert()

Envia un aviso de comienzo de release al cChat en los repositorios seleccionados

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
git commit -m "Release x.x.x"

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

## gitreleasecancel()

Cancela la release y vuelve a la rama dev

### Example

```bash
gitreleasecancel
```

_Function has no arguments._

## gitreleasefinishalert()

Envia un aviso de final de release al chat en los repositorios seleccionados

### Example

```bash
gitreleasefinishalert
```

_Function has no arguments._

# Googlechat (googlechat.sh)

Contiene funciones para realizar acciones sobre la plataforma Google Chat

* [googlechatwebhookmessage()](#googlechatwebhookmessage)


## googlechatwebhookmessage()

Envia un mensaje a un webhook de Google Chat

### Example

```bash
googlechatwebhookmessage "https://chat.googleapis.com/v1/spaces/AAAAKEfZZXM/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=TQ7fU3qe_i5PKjaOyjW9yqNn7XaFPzU-lyd8xGsi9UA%3D" "Mensaje de prueba"
```

### Arguments

* **$1** (string): Webhook.
* **$2** (string): Mensaje a enviar.

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
* [printtitleconnect()](#printtitleconnect)
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

## printtitleconnect()

Escribe un titulo mientras se conecta a un servidor

### Example

```bash
printtitle entornoXX.lan root
```

### Arguments

* **$1** (string): Host.
* **$2** (string): Usuario.

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

# Jira (jira.sh)

Contiene funciones para realizar acciones sobre la plataforma Jira

* [jirasendnotice()](#jirasendnotice)


## jirasendnotice()

Crea un aviso en Jira para una intervencion

### Example

```bash
jirasendnotice "Titulo de la intervencion" 2020-05-06 10:00 "Texto largo de la intervencion" cb
```

### Arguments

* **$1** (string): Mensaje a enviar.
* **$2** (string): Fecha de la intervencion (YYYY-MM-DD).
* **$3** (string): Hora de la intervencion (HH:MM), se programará una duración de una hora.
* **$4** (string): Opcional, Descripcion larga de la intervencion, si no se pasa se usa el mensaje de $1.
* **$5** (string): Opcional, Si se le pasa el valor "cb" incluye a CloudBuilder en el aviso

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

# Servers/Deploy (servers/deploy.sh)

Contiene funciones para realizar subidas



# Servers/Development (servers/development.sh)

Contiene funciones para interactuar con el servidor de desarrollo

* [devremakeconfig()](#devremakeconfig)
* [devxdebugtunnel()](#devxdebugtunnel)
* [devsetmemoryvars()](#devsetmemoryvars)
* [devkeystonegeneratetoken()](#devkeystonegeneratetoken)
* [devkeystonesetmemory()](#devkeystonesetmemory)
* [devkeystone()](#devkeystone)
* [devcleancache()](#devcleancache)
* [devlogphp()](#devlogphp)
* [devlogprocess()](#devlogprocess)
* [devremovedomainweb()](#devremovedomainweb)


## devremakeconfig()

Ejecuta el remake de config

### Example

```bash
devremakeconfig
```

_Function has no arguments._

## devxdebugtunnel()

Crea un tunel SSH al puerto 9000 del servidor de desarrollo para usar xdebug

### Example

```bash
devxdebugtunnel
```

_Function has no arguments._

## devsetmemoryvars()

Setea las variables de memoria necesarias para arrancar AP-2

### Example

```bash
devsetmemoryvars
```

_Function has no arguments._

## devkeystonegeneratetoken()

Genera un nuevo token Kestone para las APIs

### Example

```bash
devkeystonegeneratetoken
```

_Function has no arguments._

## devkeystonesetmemory()

Guarda el token Kestone para las APIs en memoria

### Example

```bash
devkeystonesetmemory
```

_Function has no arguments._

## devkeystone()

Genera un nuevo token Kestone para las APIs y lo guarda en memoria. Combina devkeystonegeneratetoken y devkeystonesetmemory

### Example

```bash
devkeystone
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

## devlogprocess()

Muestra el log de procesos del servidor de desarrollo

### Example

```bash
devlogprocess
```

_Function has no arguments._

## devremovedomainweb()

Elimina la carpeta, el vhost, la configuracion fpm y el usuario de un dominio en una maquina

### Example

```bash
devremovedomainweb entornox255.arsysdesarrollo.lan c4a-davidpes01.com
```

### Arguments

* **$1** (string): Host de la maquina en la que se quiere eliminar el dominio.
* **$2** (string): Dominio a eliminar.

# Servers/Machines (servers/machines.sh)

Contiene funciones para interactuar con máquinas

* [machinesdnshealthy()](#machinesdnshealthy)
* [machinednshealthy()](#machinednshealthy)


## machinesdnshealthy()

Comprueba la salud de DNS de las máquinas pasadas en un csv con tres columnas separadas por tabuladores (hostname, hostname de servicio, IP pública)

### Example

```bash
machinesdnshealthy < ~/machines.csv > ~/maquinas_erroneas.csv
```

_Function has no arguments._

## machinednshealthy()

Comprueba la salud de DNS de una máquina

### Example

```bash
machinednshealthy atlante.servidoresdns.net atlante.arsys.server.lan 217.76.128.10
```

### Arguments

* **$1** (string): Hostname de la máquina.
* **$2** (string): Hostname de servicio con el cambiazo.
* **$3** (string): IP pública de la máquina.

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

* **$1** (string): Proyecto, puede ser pdc, webadmin o apiauth.
* **$2** (string): Entorno, puede ser pre o pro.

# Styles (styles.sh)

Variables con estilos para las salidas de los comandos



# Updater (updater.sh)

Contiene funciones para actualizar las tools



