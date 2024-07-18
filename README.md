<div align="center">
    <a href="https://www.ui.com/" target="_blank"">
        <img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/1d7fa910-f90c-4ec6-a8f5-bfa14bf5d4b2" alt="logo">
    </a>
    <br>
    <h3>Ubiquiti networks x EdgeMax©</h3>
</div>

---

## Índice de contenido

- [Acceso a la CLI y comandos básicos](#acceso-a-la-cli-y-comandos-básicos)
  - [Comandos básicos](#comandos-básicos)
  - [Comandos VI](#comandos-básicos-de-vi)
  - [Acceso GUI](#acceso-a-la-gui)
  - [Certificado](#solucionar-problema-con-certificado-inválido)
- [Configuración inicial del EdgeRouter](#configuración-inicial-del-edgerouter)
  - [Reset fábrica](#realización-de-un-hardware-o-software-reset)
  - [Actualizaciones](#actualizar-edgerouter)
  - [Acceso interfaz](#acceso-a-la-interfaz-de-configuración-edgeos)
  - [Copia seguridad](#configuración-de-copia-de-seguridad-y-restauración)
  - [Copias de seguridad programadas de Edgerouter](#Copias-de-seguridad-programadas-de-Edgerouter)
  - [UISP](#gestión-de-uisp)
- [Hardening del dispositivo](#hardening-del-dispositivo)
  - [Configuración incial](#configuración-incial)
  - [Usuarios](#remover-default-user-y-crear-un-usuario)
  - [SSH](#ssh)
  - [Autenticador de Google para SSH](#autenticador-de-google-para-ssh)
  - [Restringir la gestión de SSH y GUI](#restringir-la-gestión-de-ssh-y-gui)
- [Firewall EdgeRouter](#firewall-edgerouter)
  - [Tipos de reglas](#tipos-de-reglas)
  - [Firewall básico](#firewall-básico)
  - [PPPoE O2 Movistar](#configurar-una-interfaz-PPPoE-de-Movistar-u-O2-en-un-edgerouter-de-Ubiquiti)
  - [IPv6](#ipv6-on-the-edgerouter)
  - [Dual wan](#dual-wan)
  - [NAT](#nat)
    - [Souce NAT](#source-nat-and-masquerade)
    - [Destination NAT](#destination-nat)
    - [Organización de reglas](#reordenación-de-las-reglas-de-firewall-y-nat)
    - [Port forwarding](#port-forwarding)
  - [ICMP](#ICMP)
- [LLDP]
  - [Habilitar servicio LLDP]
- [Routing](#routing)
  - [Load Balancing](#load-balancing)
  - [OSPF](#ospf)
  - [BGP](#bgp)
  - [VRRP](#vrrp)
  - [Public Static IP Addresses](#public-static-ip-addresses)
  - [Static Route](#static-route)
  - [VLAN](#VLANS)
- [LAN](#lan)
  - [DHCP](#dhcp)
  - [IP estáticas LAN](#configurar-IP-estática-para-dispositivo)
  - [Router switch](#router-switch)
  - [DNS dinámico](#dns-dinamico)
- [Añadir listas de seguridad al firewall](#añadir-listas-de-seguridad-al-firewall)
  - [Crear script](#Crear-script)
  - [Programar tarea](#programar-tarea)
  - [Listas IPs](#readme-con-listas-de-ips-públicas)
  - [Revision](#revisión)
  - [Monitorización IPs bloqueadas](#monitorización-de-ips-bloqueadas)
  - [Cortafuegos por país en Edgerouter](#Cortafuegos-por-país-en-Edgerouter)
- [Certificado localhost](#posibilidad-de-añadir-un-certificado-a-localhost)
- [OpenVPN](#openvpn)
  - [EdgeRouter como Servidor](#configuración-edgerouter-como-servidor-openvpn.-(servidor))
  - [EdgeRouter como Cliente](#configuración-edgerouter-como-cliente-openvpn.-(cliente))
- [Squidguard](#squidguard-proxy)
  - [Requisitos](#requisito-previo)
  - [Configuración](#ejemplo-de-configuración)
- [Syslog](#syslog)
- [WireGuard](#wireguard)
- [Diagnóstico de red](#herramientas-de-diagnostico-de-red)
- [Unifi](#unifi)         
- [Conclusión](#conclusión)
---

<div class="warning">
  :warning:
  <p><em>Recordar que los pasos aquí expuestos son orientativos.</em></p>
  <p><em>Recomiendo su lectura y compresión antes de aplicarlo sobre un entorno de producción.</em></p>
</div>

Writen by [Juan](https://github.com/juanico10) 👌🏻


**[`^        back to top        ^`](#wiki-ubiquiti)**
# Acceso a la CLI y comandos básicos
Los lectores aprenderán cómo conectarse y configurar un EdgeRouter por primera vez. Hay muchos entornos diferentes en los que es posible que sea necesario realizar ajustes específicos. Este artículo muestra un escenario de instalación común, pero no es necesario aplicarlo en todos los entornos de red.

## Comandos básicos
<ul><code>commit:</code>para activar los cambios.</ul>
<ul><code>commit-confirm:</code>Este comando reinicia el dispositivo en 10 minutos (puedes personalizar este valor) a menos que el commit sea confirmado con el comando <code>confirm</code>. Esto es útil cuando estás haciendo cambios en un dispositivo remoto y no quieres arriesgarte a perder el acceso a él.</ul>
<ul><code>save:</code> para almacenar la configuración "activa" en la configuración de inicio.</ul>
<ul><code>compare:</code> Para ver qué cambios se han realizado en la configuración.</ul>
<ul><code>configure:</code> modo configuración.</ul>
<ul><code>show:</code> mostrar -> Ejemplo: show firewall</ul>
<ul><code>set:</code> establecer configuración. -> Ejemplo: set firewall name TEST default-action drop</ul>
<ul><code>edit:</code> Para crear la misma acción y reducir la cantidad de repeticiones en la sintaxis completa. -> Ejemplo: edit firewall name TEST</ul>
<ul><code>up:</code> Para subir un nivel de edición -> Ejemplo: volver al set de configuración anterior</ul>
<ul><code>top:</code> Para volver al nivel de edición superior -> Ejemplo: Volver al ser de configuración incial</ul>
<ul><code>discard:</code> para deshacer los cambios no confirmados</ul>
<ul><code>copy:</code> Para crear una nueva acción existente -> Ejemplo: copy name WAN1_LOCAL to name WAN2_LOCAL</ul>
<ul><code>rename:</code> Para cambiar el nombre de la nueva acción -> Ejemplo: rename name WAN2_LOCAL to name WAN2_IN</ul>
<ul><code>load:</code> cargar configuración.</ul>
<ul><code>? o tecla de tab:</code> para mostrar opciones para el nivel de edición especificado</ul>

## Comandos básicos de VI
<ul><code>wq</code>Guardar y salir.</ul>
<ul><code>:q!</code>Salir sin guardar.</ul>
<ul><code>u</code>Deshace última acción.</ul>
<ul><code>i</code>modo inserción por la izquierda.</ul>
<ul><code>a</code>modo inserción por la derecha.</ul>
<ul><code>dd</code>Elimina la línea actual.</ul>
<ul><code>p</code>Copia la palabra actual.</ul>
<ul><code>A</code>Pone le puntero al final de la línea.</ul>
<ul><code>w</code>Salta de palabra en palabra.</ul>
<ul><code>D</code>Borra desde el puntero hacia el final de la línea.</ul>
<ul><code>o</code>Agrera una línea debajo de la actual.</ul>
<ul><code>O</code>Agrega una línea encima de la actual.</ul>
<ul><code>P</code>Copia la palabra pegada.</ul>
<ul><code>gw</code>Copia la palabra actual.</ul>
<ul><code>help</code>Ayuda.</ul>

## Acceso a la GUI
Mediante un navegador, accedemos a <code>https://192.168.1.1</code>. Cargara una web donde deberemos introducir unas credenciales. En este caso las que vienen de fábrica.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/bad23c40-0039-41ed-900c-e79947521d87" alt="img_login"></p>


La contraseña por defecto:
<ul><code>Usuario:</code> ubnt</ul>
<ul><code>Contraseña:</code> ubnt</ul>

Una vez introducidas las credenciales, se cargará la web de gestión del EdgeRouter.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/9dd58c41-de6c-4127-85ae-420d6d436f69" alt="img_dashboard"></p>


### Desde la Terminal
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/2396c5d9-a1fe-4e65-ac32-1eda5669e474" alt="img_terminal"></p>

### Instrucciones de uso con GUI:
0. Acceda a la interfaz de usuario web de EdgeRouter
1. Navegue a la parte superior derecha de la interfaz de usuario web.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/b9b8d65f-8c13-4a79-8fa6-cd360a45d948" alt="img_terminal_web"></p>

## Solucionar problema con certificado inválido
<p><sup>En los comandos de OpenSSL a continuación, reemplace los nombres de archivo en TODAS LAS MAYÚSCULAS con las rutas y nombres de archivo reales con los que está trabajando.</sup></p>
Cuando intentamos acceder vía web, nos indica que el certificado es inválido al ser autofirmado:
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/ab347e86-69d8-452c-89c4-63068a472f4a" alt="img_web_error_cert"></p>

Podemos ver el contenido del archivo de certificado <code>.PEM</code>:
```sh
openssl x509 -in CERTIFICATE.pem -text -noout
```
Para poder solucionar, debemos descargar el certificado del navegador. Nos descarga un archivo <code>.pem</code>:
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/33ccc6bd-068c-467b-918b-f1c0717947c7" alt="cert1"></p>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c4bea63b-7d94-4c73-990c-6c2e9ba223f1" alt="cert2"></p>

Una vez descargado tenemos que cambiar el <code>.pem</code> a <code>.crt</code> con OpenSSL:
```sh
openssl x509 -outform der -in CERTIFICATE.pem -out CERTIFICATE.crt
```
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/ed84c2a9-9388-4571-b600-5b7bd826daea" alt="cert3"></p>

Despues de haber cambiado el formato, procedemos a instalar el certificado en la raiz de confianza:
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/096b7db4-f295-4e73-84c9-a038a235f45c" alt="cert4"></p>

Una vez importado el certificado y borrado las cookies, ya no nos indicará que el certificado no es de confianza.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/151fba35-3575-470b-afb3-35d1b42733c1" alt="cert5"></p>

Tambien podemos migrar el <code>.pem</code> a <code>.pfx</code> con OpenSSL:
```sh
openssl pkcs12 -export -in CERTIFICATE.pem -inkey CERTIFICATE.key -out CERTIFICATE.pfx
```
<p><sup>Para ello necesitas la private key del certificado.</sup></p>

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# Configuración inicial del EdgeRouter:
<img src="https://help.ui.com/hc/article_attachments/360064722654" alt="Ubiquiti edgemax"/>

La configuración inicial del EdgeRouter implica la configuración básica del dispositivo para que pueda conectarse a Internet y administrar el tráfico de red.

## Realización de un Hardware o Software Reset
El EdgeRouter se puede restablecer a los valores predeterminados de fábrica utilizando un hardware o software método de restablecimiento

**Hardware Reset:** Borra todos los archivos de configuración y del sistema, restableciendo el dispositivo al estado predeterminado de fábrica.
**Software Reset:** Solo borra la configuración y deja intactos los demás archivos del sistema.

:warning: <strong><font style="vertical-align: inherit;">ATENCIÓN: </font></strong> Los métodos de reinicio de hardware a continuación borrarán todos los archivos de configuración y del sistema.

<details>
    <summary>Realización de un restablecimiento de hardware :</summary>

### Instrucciones de uso para realizar reset button:

1. Verifique que EdgeRouter esté completamente iniciado.
2. Mantenga presionado el reinicio.
3. Los LED del puerto comenzarán a encenderse en secuencia, comenzando por el puerto 1 y terminando en el último puerto.
4. Continúe presionando el botón de reinicio durante aproximadamente 10 segundos hasta que el LED del puerto 1 se encienda nuevamente.
5. Suelte el botón de reinicio.
6. El EdgeRouter se reiniciará.
7. Espere a que se complete el reinicio.
8. Conéctese al eth0 y administre el dispositivo abriendo un navegador y navegando a la <code>https://192.168.1.1</code> dirección IP predeterminada.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/blob/main/assets/reset.gif" alt="reset"></p>

### Instrucciones de uso para realizar un Power On Reset:

1. Desconecte el cable de alimentación del EdgeRouter.
2. Mientras vuelve a conectar el cable de alimentación al EdgeRouter, mantenga presionado el reinicio .
3. Los LED del puerto comenzarán a encenderse en secuencia, comenzando por el puerto 1 y terminando en el último puerto.
4. Continúe presionando el botón de reinicio durante aproximadamente 10 segundos hasta que el LED del puerto 1 se encienda nuevamente.
5. Suelte el botón de reinicio.
6. El EdgeRouter se reiniciará.
7. Espere a que se complete el reinicio.
8. Conéctese al eth0 y administre el dispositivo abriendo un navegador y navegando a la <code>https://192.168.1.1</code> dirección IP predeterminada.

&nbsp;
</details>
&nbsp;

<details>
    <summary>Realización de un reinicio de software:</summary>

### Instrucciones de uso con GUI:
0. Acceda a la interfaz de usuario web de EdgeRouter.
1. Navegue a la Sistema en la parte inferior izquierda de la interfaz de usuario web.
2. Restablezca la configuración a los valores predeterminados presionando el Restablecer a los valores predeterminados en la Restablecer  predeterminados .
3. El EdgeRouter solicitará que se reinicie el dispositivo para completar el restablecimiento.
4. Espere a que se complete el reinicio.
5. Conéctese al eth0 y administre el dispositivo abriendo un navegador y navegando a la <code>https://192.168.1.1</code> dirección IP predeterminada 

### Instrucciones de uso con CLI:
0. acceda a la interfaz de línea de comandos de EdgeRouter.
1. Sobrescriba el archivo de inicio actual <code>config.boot</code> con el archivo de inicio predeterminado <code>config.boot.default</code>.
<ul><code>sudo cp /opt/vyatta/etc/config.boot.default /config/config.boot</code></ul>
Haga clic para copiar
2. Reinicie EdgeRouter.
<ul><code>reboot</code></ul>
<ul><code>Proceed with reboot? [confirm]</code></ul>
3. Espere a que se complete el reinicio.
4. Conéctese al eth0 y administre el dispositivo abriendo un navegador y navegando a la <code>https://192.168.1.1</code> dirección IP predeterminada  

&nbsp;
</details>
&nbsp;

## Actualizar EdgeRouter
Antes de realizar cualquier cambio o configuración en los equipos Ubiquiti EdgeMax debe contar con la última versión del Firmware.
- Pueden buscar en la web de descargas de Ubiquiti:
<p><ul><a title="download" href="https://www.ui.com/download/edgemax/" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/5396b9aa-5f7f-41bc-a713-974b3ad7c4a5" alt="download" width="80" align="center" /></a></ul></p>

- Pueden buscar en la web de lanzamientos de Ubiquiti:
<p><ul><a title="download" href="https://community.ui.com/releases?q=EdgeMAX" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/e7486209-8360-44ac-971d-4fe300d6db61" alt="rss" width="80" align="center" /></a></ul></p>

Y seguir la guía que indica fabricante: <a href="https://help.ui.com/hc/en-us/articles/205146110-EdgeRouter-How-to-Upgrade-the-EdgeOS-Firmware" target="_blank">Cómo actualizar el firmware de EdgeOS</a>

## Acceso a la interfaz de configuración EdgeOS
<details>
    <summary>Opción 1:</summary>

### Instrucciones de uso con IP ESTÁTICA:
1. Conecte un cable Ethernet desde el puerto Ethernet del ordenador al puerto eth0 del EdgeRouter.
2. Configure el adaptador de Ethernet en su sistema host con una dirección IP estática en la subred  <code>192.168.1.x</code>.
3. Inicie el explorador web. Escriba <code>https://192.168.1.1</code> en la barra de direcciones. Pulse Intro (PC) o Retorno (Mac).
4. Introduzca ubnt en los campos de nombre de usuario y contraseña. Lea el acuerdo de licencia de Ubiquiti y marque la casilla junto a I agree to the terms of this License Agreement (Acepto los términos de este acuerdo de licencia) para aceptarlo. Haga clic en Login (Inicio de sesión).

&nbsp;
</details>
&nbsp;

<details>
    <summary>Opción 2:</summary>

### Instrucciones de uso con DHCP:
1. Conecte un cable Ethernet de eth1 en el EdgeRouter a un segmento de LAN que ya tiene un servidor DHCP.
2. Para comprobar la dirección IP del EdgeRouter, utilice uno de los métodos siguientes:
<ul>2.1 Configure el servidor DHCP para que proporcione una dirección IP específica al EdgeRouter en función de su dirección MAC (en la etiqueta).</ul>
<ul>2.2 Deje que el EdgeRouter obtenga una dirección IP y luego compruebe el servidor DHCP para ver qué dirección IP se asignó.</ul>
3. Inicie el explorador web. Introduzca la dirección IP correcta en el campo de dirección. Pulse Intro (PC) o Retorno (Mac).
4. Introduzca ubnt en los campos de nombre de usuario y contraseña. Lea el acuerdo de licencia de Ubiquiti y marque la casilla junto a I agree to the terms of this License Agreement (Acepto los términos de este acuerdo de licencia) para aceptarlo. Haga clic en Login (Inicio de sesión).

&nbsp;
</details>
&nbsp;

## Configuración de copia de seguridad y restauración
Realizar una copia de seguridad y restaurar el archivo de configuración de un EdgeRouter.

<details>
    <summary>Realización copia de seguridad y restauración vía GUI:</summary>

### Instrucciones de uso para realizar copia vía GUI
1. Navegue al sistema en la parte inferior izquierda de la GUI para descargar el archivo de configuración de la copia de seguridad.
<ul><code>**Sistema** > **Gestión de configuración** y **mantenimiento de dispositivos** > **Back Up Config**</code></ul>
2. Descargue el archivo de configuración de la copia de seguridad haciendo clic en el Descargar .
3. EdgeRouter le pedirá que guarde el archivo en su ordenador.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/cbee38cf-3fc9-46ad-9604-6f7e46e61d4c" alt="backup"></p>

### Instrucciones de uso para restaurar copia vía GUI
1. Navegue al sistema en la parte inferior izquierda de la GUI para descargar el archivo de configuración de la copia de seguridad.
<ul><code>**Sistema** > **Gestión de configuración** y **mantenimiento de dispositivos** > **Restore Config**</code></ul>
2. Cargue el archivo de configuración de la copia de seguridad haciendo clic en el **Upload a file** .
3. EdgeRouter solicitará que se reinicie el dispositivo para completar la restauración.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/94c88a7e-eed8-47db-b764-24c1a3000be2" alt="restore"></p>

### Instrucciones de uso para realizar/restaurar copia vía UNMS
Para realizar o restaurar vía UNMS deben seguir los pasos de este artículo:
<ul><a href="https://help.ui.com/hc/en-us/articles/360002535514" target="_blank">realizar o restaurar vía UNMS</a></ul>
<p><ul>Tambien hay un contenedor docker unms en el enlace:<a href="https://github.com/Nico640/docker-unms" target="_blank">Github</a></ul></p>

&nbsp;
</details>
&nbsp;

<details>
    <summary>Realización copia de seguridad y restauración vía CLI:</summary>

### Instrucciones de uso para realizar copia vía CLI

<p>1. Puede hacerlo usando el botón CLI en la GUI o usando el terminal Linux.</p>
<p>2. Ingrese al modo de configuración y asegúrese de que todos los cambios en las configuraciones actualmente activas/en funcionamiento se guarden en la arranque/inicio.</p>
<ul><code>commit ; save</code></ul>
<p>3. Guarde el archivo de configuración <code>config.boot</code> en una máquina remota mediante una de estas opciones: TFTP, SCP, FTP o SFTP.</p>

```sh
scp://<user>:<passwd>@<host>/<file>   Save to file on remote machine
sftp://<user>:<passwd>@<host>/<file>  Save to file on remote machine
ftp://<user>:<passwd>@<host>/<file>   Save to file on remote machine
tftp://<host>/<file>                  Save to file on remote machine
```
Y con el comando <code>**save tftp://host/config.boot**</code> guardamos el archivo de configuración.
<p>4. Verifique el contenido de la configuración de inicio abriendo el <code>config.boot</code> con un editor de texto y compare con el del equipo que se haya exportado correctamente.</p>
<ul><code>cat /config/config.boot</code></ul>

### Instrucciones de uso para restaurar copia vía CLI
<p>1. Puede hacerlo usando el botón CLI en la GUI o usando un programa como PuTTY.</p>
<p>2. Compare las diferencias entre la respaldo/funcionamiento y la activa.</p>
<p>3. Guarde el archivo de configuración <code>config.boot</code> en una máquina remota mediante una de estas opciones: TFTP, SCP, FTP o SFTP.</p>

```sh
scp://<user>:<passwd>@<host>/<file>   Load from file on remote machine
sftp://<user>:<passwd>@<host>/<file>  Load from file on remote machine
ftp://<user>:<passwd>@<host>/<file>   Load from file on remote machine
http://<host>/<file>                  Load from file on remote machine
tftp://<host>/<file>                  Load from file on remote machine
```

Y con el comando <code>**load tftp://host/config.boot**</code> guardamos el archivo de configuración.
<p>4. Verifique que la restauración ha sido correcta y con el contenido de la configuración del <code>config.boot</code> con un editor de texto y compare con el del equipo que se haya importado correctamente.</p>
<ul><code>cat /config/config.boot</code> y con el comando <code>compare</code></ul>
<p>5. Una vez asegurado de que todos los cambios en las configuraciones actualmente activas/en funcionamiento son correctas se procede a guardar en el arranque/inicio.
<ul><code>commit ; save</code></ul></p>

&nbsp;
</details>
&nbsp;

- También hay una opción que nos indican Ubiquiti, ellos la llaman **desinfectar** o **limpiar** las configuraciones de EdgeRouter para eliminar toda la información personal y confidencial.
Ubiquiti nos dedica un articulo muy detallado para esta opción. Esta opción de **desinfectar** es cuando necesitas ayuda y quieres enviar la plantilla o "cachos" de la plantilla al foro o fabricante.
<ul><a href="https://help.ui.com/hc/en-us/articles/360012074414" target="_blank">Sanear las configuraciones de EdgeRouter</a></ul>

## Copias de seguridad programadas de Edgerouter
En esta sección, describiré cómo configurar una copia de seguridad diaria programada de la configuración del Edgerouter a través de SFTP a otro Linux.

#### En el Edgerouter
Primero necesitamos generar un par de claves públicas en nuestro Edgerouter. Esto es mucho más seguro que usar una contraseña para la autenticación.

```sh
sudo bash
mkdir /config/ssh-keys
cd /config/ssh-keys
ssh-keygen -f backup -C "SSH key for backup" -N ""
cat backup.pub
```

La última línea imprime nuestra clave pública. Esta clave es necesaria en nuestro servidor de respaldo. Una clave podría verse así:
```sh
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjsIf2CJz7cM5axHSsm+Zj1HvfAdbgVFvoWcGEw4rfKo+sRY/QQjNZfFCQyBRLzY5MBBnPrk1y75iILddaLVQvSm/3gSj6ZrEGH1ZS5mxznnwIovrROZ9tJeCPiS/1QDMMZDbTRR+Ez+eQVnaWdIhLGBhBEjj13VFAyV33QVzaaBc0SbtpzfbmUAVFHIjBXuUHoRTw0uZlvEg1GD68Mp7GhC6f1YeNU+zt2pA+6KRP9rZvshLfvAH9IP6uzgu17o2cDowF3tZmlhCFnr062ptbfDSnTO6ywEyzCIue85H6hEItmC3VBdnx SSH key for backup
```

#### En el servidor de respaldo
Ahora vamos a nuestro servidor que recibirá las copias de seguridad y creamos un usuario para este fin:
```sh
adduser backupuser
su backupuser
mkdir /home/backupuser/.ssh
mkdir /home/backupuser/edge-backups
vi /home/backupuser/.ssh/authorized_keys
```

La última línea edita el archivo `"authorized_keys"`, donde debe pegar la clave pública generada en Edgerouter.


#### De vuelta en el Edgerouter
Ahora crea este script "/config/scripts/backup-remote.sh" y chmod 755:
```sh
#!/bin/bash
sftp_host=192.168.X.X
sftp_user=backupuser
sftp_folder=/home/backupuser/edge-backups
sftp_key=/config/ssh-keys/backup

now=$(date +%d%m%y-%H%M)
tar -cf - /config | gzip | \
        curl -k --key $sftp_key --pubkey $sftp_key.pub \
        -u $sftp_user: -T - sftp://$sftp_host$sftp_folder/backup-$now.tar.gz
```

Ahora debe probar si los scripts funcionan ejecutándolos. Si es así, debe agregar las siguientes líneas a su configuración de Edgerouter para que el script se ejecute diariamente:
```sh
set system task-scheduler task backup-conf executable path /config/scripts/backup-remote.sh
set system task-scheduler task backup-conf interval 1d
```

## Gestión de UISP
Puede administrar el dispositivo mediante el UISP, que le permite configurar, supervisar, actualizar y realizar copias de seguridad de sus dispositivos a través de una sola aplicación.
1. Para empezar, vaya a <a href="https://help.ui.com/hc/en-us/articles/115012196527-UNMS-Installation-Guide" target="_blank">UISP - Guía de instalación </a>
2. Despues logarse en la web de UISP <a href="uisp.ui.com" target="_blank">uisp.ui.com</a>
3. Pueden utilizar la aplicación móvil, enlace de configuración: <a href="https://help.ui.com/hc/en-us/articles/115010608187-UISP-Mobile-App#2" target="_blank">UISP-Mobile-App</a>
<p>
<a href="https://play.google.com/store/apps/details?id=com.ubnt.umobile"><img src="https://lh3.googleusercontent.com/q1k2l5CwMV31JdDXcpN4Ey7O43PxnjAuZBTmcHEwQxVuv_2wCE2gAAQMWxwNUC2FYEOnYgFPOpw6kmHJWuEGeIBLTj9CuxcOEeU8UXyzWJq4NJM3lg=s0" width="130px"></a>
<a href="https://apps.apple.com/us/app/unms-mobile/id1183022489"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Download_on_the_App_Store_Badge.svg/640px-Download_on_the_App_Store_Badge.svg.png" width="130px"></a>
</p>
:warning: Cuidado con la opción cloud. Cuando creas la cuenta indica:
<ul><code>Una consola en la nube de UISP gratuita requiere al menos 10 dispositivos Ubiquiti activos en total después del día 30 de la configuración.</code></ul>

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# Hardening del dispositivo
El hardening del dispositivo Edgerouter se refiere a la aplicación de medidas de seguridad para proteger y fortalecer la configuración del enrutador Edgerouter.

Esto incluye medidas de seguridad como cambiar las contraseñas predeterminadas de inicio de sesión, asegurarse de que la última versión del firmware esté instalada, deshabilitar los servicios no utilizados, como SSH o Telnet, y configurar el firewall para bloquear tráfico no deseado que configuraremos en el siguiente punto.

## Configuración incial
Primero una pequeña configuración general importante del sistema

```sh
set system host-name mynameedge
set system domain-name mydomain.com
set system name-server 1.1.1.1
set system time-zone Europe/Madrid
```

## Habilitar funciones de rendimiento
Offloading se utiliza para ejecutar funciones del enrutador usando el hardware directamente, en lugar de un proceso de funciones de software.  El beneficio de la descarga en EdgeOS es un mayor rendimiento y rendimiento al no depender de la CPU para las decisiones de reenvío. Enlace a la web oficial de Ubiquiti: <a href="https://help.ui.com/hc/en-us/articles/115006567467-EdgeRouter-Hardware-Offloading" target="_blank">EdgeRouter-Hardware-Offloading</a></p>

<blockquote>
  <p>
    <strong><mark>UTILIZAR CON CUIDADO LA FUNCION DE RENDIMIENTO.</mark></strong>
  </p>
</blockquote>


Hay dos plataformas que utilizan diferentes modelos de EdgeRouter. Cada plataforma tiene su propio soporte de descarga y comandos únicos para habilitar la funcionalidad. Las plataformas son: 

| CPU fabricante | Modelos EdgeRouter |
|---|---|
| MediaTek | ER-X, ER-10X, ER-X-SFP, EP-R6 |
| Cavium | ERLite-3, ERPoE-5, ER-8, ERPro-8, EP-R8, ER-4, ER-6P, ER-12, ER-12P, ER-8-XG |

### Equipos con MediaTek
```sh
configure
set system offload hwnat enable
set system offload ipsec enable
commit ; save
```

### Equipos con Cavium
Para todos los demás modelos de Edgerouter
```sh
configure
set system offload ipv4 forwarding enable
set system offload ipv4 gre enable
set system offload ipv4 pppoe enable
set system offload ipv4 vlan enable
set system offload ipv6 forwarding enable
set system offload ipv6 pppoe enable
set system offload ipv6 vlan enable
set system offload ipsec enable
commit ; save
```
Usar una herramienta como [iPerf/iPerf3](https://iperf.fr/) es una forma común de generar y probar el rendimiento. Es importante no utilizar EdgeRouter como servidor o cliente para iPerf al ejecutar la prueba, ya que los enrutadores están diseñados para enrutar/reenviar tráfico y no para generarlo. 

## Remover default user y crear un usuario
Antes de eliminar el usuario por defecto, crear un usuario, en la GUI en la pestaña USERS o por CLI:
```sh
set system login user <user>
set system login user <user> level admin
set system login user <user> authentication plaintext-password <contraseña>
set system login user <user> full-name <Nombre>
commit ; save
```
<sup>La contraseña se encripta una vez introducida en texto plano</sup>

Despues eliminarmos el usuario por defecto
```sh
configure
delete system login user ubnt
commit ; save
```
**PD:** Si creas un usuario como operador, no tiene acceso por ssh.
```sh
This account is currently not available.
Connection to 192.168.1.1 closed.
```

## SSH

### Añadir una clave ssh pública a EdgeRouter
Para poder generar una clave pública SSH RSA.
```sh
ssh-keygen -t rsa -b 4096
```

```sh
ssh-copy-id -i ~/.ssh/mykey USER@IP_EDGEROUTER
```

Accedemos al equipo y configuramos la clave pública generada:
```sh
configure
loadkey <user> /tmp/id_rsa.pub
sudo chown -R <user> /home/<user>
commit ; save
```

### Comprobación de acceso
:warning:  Asegúrate de que puedes acceder con tu clave pública antes de salir de la sesión SSH actual.
Probamos acceso sin salir de la sesión SSH por si tienes que hacer un rollback:
```sh
$ ssh USER@IP_EDGEROUTER
exit
```

### Desactivar la autenticación de contraseñas en texto plano
Si puede iniciar sesión con éxito en el EdgeRouter, un paso para reforzar la seguridad de su EdgeRouter es eliminar la opción de utilizar una contraseña de texto simple.  
:warning:  Asegúrate de que puedes acceder con tu clave pública antes de desactivar la autenticación en texto plano.

```sh
configure
set service ssh disable-password-authentication
commit ; save
```
### Asegurar acceso a la GUI y ssh
Pueden asegurar el acceso al ssh o gui con vuestro rango de IPs, es opcional, pero seguro.
(opcional)
```sh
configure
set service gui listen-address <lan ip address/range>
set service ssh listen-address <lan ip address/range>
commit ; save
```

Recomendado, cambiar el puerto de ssh y habilitar V2
```sh
configure
set service ubnt-discover disable
set service ssh protocol-version v2
set service ssh port <port>
delete service telnet
commit ; save
```
### Autenticador de Google para SSH
<code>OPCIONAL</code>: Un factor adicional pero recomendado, agregar el autenticador de Google para SSH

El uso de certificados para la autenticación es un buen paso adelante. Pero, ¿qué pasa si mi máquina con mi certificado se ve comprometida? Luego está el acceso al Edgerouter 24/7. Una contramedida podría ser usar Google Authenticator en mi teléfono. Luego, el atacante necesita mi certificado en mi PC y mi teléfono.

Primero descargamos e instalamos el paquete debian de Google Authenticator

```sh
sudo -i
apt-get install libqrencode3 -y
cd ~ && mkdir ./downloaded-packages && cd downloaded-packages
curl -O http://ftp.us.debian.org/debian/pool/main/g/google-authenticator/libpam-google-authenticator_20170702-1_mips.deb
dpkg --force-all -i libpam-google-authenticator_20170702-1_mips.deb
exit
```
Nota: Para versiones pequeñas de Edgerouter lite, use "libpam-google-authenticator_20160607-2_mips.deb" en su lugar... No tienen la arquitectura de 64 bits.

Ahora ejecutamos el autenticador para que nos dé una clave privada para nuestro teléfono.

```sh
google-authenticator
Do you want authentication tokens to be time-based (y/n) y
Do you want me to update your "/home/$USER/.google_authenticator" file (y/n): y
Do you want to disallow multiple uses of the same authentication token? This restricts you to one login about every 30s, but it increases your chances to notice or even prevent man-in-the-middle attacks (y/n): y
By default, tokens are good for 30 seconds. In order to compensate for possible time-skew between the client and the server, we allow an extra token before and after the current time. If you experience problems with poor time synchronization, you can increase the window from its default size of +-1min (window size of 3) to about + 4min (window size of 17 acceptable tokens). Do you want to do so? (y/n): y
If the computer that you are logging into isn't hardened against brute-force login attempts, you can enable rate-limiting for the authentication module. By default, this limits attackers to no more than 3 login attempts every 30s. Do you want to enable rate-limiting (y/n): y
```

Simplemente responda afirmativamente a todas las preguntas. Esto arrojaría una clave privada que puede escribir en la aplicación de autenticación. Si ha instalado el paquete apt "libqrencode3", obtendrá un enorme código QR en la pantalla que puede escanear con el teléfono.

Ahora necesitamos configurar PAM en Linux para usar Google Authenticator. También deshabilitamos la autenticación de contraseña.

```sh
sudo -i
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
sed -i -e 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd
sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /opt/vyatta/etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /opt/vyatta/etc/ssh/sshd_config
echo "AuthenticationMethods publickey,keyboard-interactive" >> /opt/vyatta/etc/ssh/sshd_config
```

En este punto sería inteligente probarlo. Guarde la configuración con el comando "guardar" y luego reinicie el dispositivo con el comando "reiniciar".

### Restringir la gestión de SSH y GUI
Edgerouter se puede administrar desde cualquier lugar. Esto solo debe permitirse desde redes internas.
```sh
configure
set service gui listen-address <lan ip address>
set service ssh listen-address <lan ip address>
commit ; save
exit
```

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# Firewall Edgerouter
El Firewall EdgeRouter es conocido por su potencia y flexibilidad. Se basa en una plataforma de hardware de alto rendimiento que puede manejar grandes cantidades de tráfico de red con un bajo impacto en el rendimiento del sistema. Además, el Firewall EdgeRouter es altamente configurable y se puede ajustar para satisfacer las necesidades específicas de una organización o aplicación.

El Firewall EdgeRouter admite varias funciones avanzadas de firewall, como reglas de filtrado de paquetes, filtrado de contenido, prevención de intrusiones y detección de tráfico anómalo, entre otras. También tiene la capacidad de crear VLANs y segmentar la red en zonas separadas para una mayor seguridad.

<div align="center">
        <img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c644316f-bfc7-4802-97b3-710059fccdec" alt="network" width="320">
    </a>
    <br>
    <h4>Explicación del Firewall.</h4>
</div>

### TIPOS DE REGLAS
* Para poder añadir una regla, deben saber que hay 3 WAN en Ubiquiti:
  - `WAN_IN` = es para paquetes externos que llegan a su enrutador y se dirigen a su LAN. Deje el destino en blanco. Solo debe preocuparse por el grupo de direcciones de origen BlockedIP. Coloque la regla DESPUÉS de que los dos primeros normales acepten establecidos/relacionados y eliminen los no válidos.
  - `WAN_LOCAL` = es para paquetes externos que llegan a su enrutador y se dirigen a su propio enrutador. El origen debe volver a ser el grupo de direcciones BlockedIP y dejar el destino vacío. También ponga después de las mismas dos reglas que arriba.
  - `WAN_OUT` = Para bloquear el saliente, debe crear un nuevo conjunto de reglas y adjuntarlo como OUT a ethX con la aceptación predeterminada. Luego agregue una sola regla para colocar con el grupo de direcciones de destino BlockedIP y nada en el origen. 

* Tipos de LAN
  - `LAN_IN` = Todo lo que ingresa al enrutador desde su LAN que está destinado a otro lugar WAN u otra LAN. En una configuración SMB o SOHO, esto probablemente sea explícitamente permisivo. En un entorno empresarial, esto puede ser permisivo o no (por ejemplo, bloquear todo el tráfico saliente excepto SFTP en un puerto no estándar)
  - `LAN_LOCAL` = Todo lo que ingresa al enrutador desde su LAN destinado al enrutador.

Las reglas se añaden en las `WAN`, dependiendo del sentido que queramos hacer.
Si desea bloquear el entrante y saliente, debemos de añadir en la IN u OUT, y en el LOCAL para bloquear los accesos hacia el sentido del router.

Ejemplo para una `WAN`con pppoe,
- Indicamos la interfaz a la WAN_IN la pppoe en modo `IN`
- Indicamos la interfaz a la WAN_LOCAL la pppoe en modo `LOCAL`
- Indicamos la interfaz a la WAN_IN la pppoe en modo `OUT`.
    - <sup>No olvidar poner la acción por defecto en ACCEPT, o denegará todo el tráfico desde la red interna.</sup>
- Añadiríamos la regla en la IN u OUT y en el LOCAL.
- Despues realizar una prueba para comprobar la acción deseada.

<sup>En EdgeMax no es necesario añadir la misma regla en IN y OUT. Denegará o permitirá la acción deseada en cualquiera de ellas.</sup>

El EdgeRouter utiliza un cortafuegos de estado, lo que significa que las reglas del cortafuegos del router pueden coincidir en diferentes estados de conexión. Los estados de tráfico son:
  - `new` Los paquetes entrantes proceden de una nueva conexión.
  - `established` Los paquetes entrantes están asociados a una conexión ya existente.
  - `related` Los paquetes entrantes son nuevos, pero están asociados a una conexión ya existente.
  - `invalid` Los paquetes entrantes no coinciden con ninguno de los otros estados.
Utilizando estos estados de cortafuegos, el router puede aceptar/rechazar tráfico en diferentes direcciones dependiendo del estado de la conexión.
Por ejemplo:
  - En ejemplo, el router puede bloquear todo el tráfico de WAN a LAN, a menos que sea tráfico de retorno asociado a una conexión ya existente. El asistente de configuración básica de EdgeOS añade las siguientes reglas de cortafuegos al router.

### Firewall básico
Aquí viene la parte más difícil. Si anteriormente no te has peleado con un Firewall algunos conceptos te serán extraños, pero intentare explicar cada paso con algún ejemplo, haciéndolo mas fácil de entender.

- Configuración básica del firewall. Asignar la interfaz de la WAN que vayan a utilizar:
```sh
configure

set firewall name WAN_IN default-action drop
set firewall name WAN_IN description 'WAN to internal'
set firewall name WAN_IN rule 10 action accept
set firewall name WAN_IN rule 10 description 'Allow established/related'
set firewall name WAN_IN rule 10 state established enable
set firewall name WAN_IN rule 10 state related enable
set firewall name WAN_IN rule 20 action drop
set firewall name WAN_IN rule 20 description 'Drop invalid state'
set firewall name WAN_IN rule 20 state invalid enable

set firewall name WAN_LOCAL default-action drop
set firewall name WAN_LOCAL description 'WAN to router'
set firewall name WAN_LOCAL rule 10 action accept
set firewall name WAN_LOCAL rule 10 description 'Allow established/related'
set firewall name WAN_LOCAL rule 10 state established enable
set firewall name WAN_LOCAL rule 10 state related enable
set firewall name WAN_LOCAL rule 20 action drop
set firewall name WAN_LOCAL rule 20 description 'Drop invalid state'
set firewall name WAN_LOCAL rule 20 state invalid enable

set interfaces ethernet eth0 firewall in name WAN_IN
set interfaces ethernet eth0 firewall local name WAN_LOCAL

commit ; save
```

### Configurar una interfaz PPPoE de Movistar u O2 en un EdgeRouter de Ubiquiti
<p>:warning: Asegúrate de cambiar los parámetros del ISP y utilizar los que el ISP os indique.</p>


<p>1. Lo primero es entrar en la web de gestión del Edgerouter y pulsar en la pestaña Wizards de la parte superior derecha. Esto nos cargara un grupo de asistentes de configuración en la parte izquierda. Pulsamos sobre el que se llama WAN + +2LAN2. Esto nos cargara un formulario que deberemos rellenar con los datos de acuerdo a nuestras necesidades.</p>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/ea6567fe-133c-4f5f-ab91-04407837d837" alt="pppoe_1.png"></p>

<p>2. Internet port: En esta sección definiremos como está conectado nuestro Edgerouter al router HGU de Movistar/O2.</p>
<p><code>Port</code>: En el menú despegable seleccionamos el puerto de ethernet con el que está conectado al router HGU de Movistar o O2, etho o eth4.</p>
<p><code>Internet connection type</code>: Aquí seleccionamos PPPoE y rellenamos los campos de ls siguiente manera:</p>
<ul><p>Account name: <code>adsl@telefonicapa</code></ul></p>
<ul><p>Password: <code>adslppp</code></ul></p>
<ul><p>VLAN ID: <code>6</code></ul></p>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/ae5a1242-bd72-403e-b2b1-c3ba71edd9d4" alt="pppoe_2.png"></p>

<p>3. LAN ports: Desplegando está sección podremos configurar la IP que tendrá nuestro router y habilitaremos el DHCP por defecto para que asigne IPs a aquellos equipos que se conecten al router.</p>
<sup>Tener en cuenta que el rango de IP debe ser distinto al que esta nuestro Edgerouter con el router HGU de Movistar o O2. La opción de DHCP viene habilitada por defecto, así que no la tocamos y la dejamos como está.</sup>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c156db42-b63a-4fa8-bcb0-d11c28e3877c" alt="pppoe_3.png"></p>

<p>4. User setup: Por último, es recomendable cambiar la contraseña del usuario ubnt que viene por defecto por otra más segura.</p>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/24c763d3-4d10-4776-8c86-d2ae797206e5" alt="pppoe_4.png"></p>

<p>Para aplicar la configuración definida, pulsamos sobre Apply.</p>

<div class="warning">
  :warning:
  <p><em>Recordar que los pasos aquí expuestos son orientativos. Utilízalos como una guía, ya que la configuración de vuestra red puede diferir con la de aquí expuesta. Pudiendo causar un mal funcionamiento de vuestra red.</em></p>
  <p><em>Recomiendo su lectura y compresión antes de aplicarlo sobre un entorno de producción.</em></p>
</div>

Puedes asignar la MAC del HGU a la WAN:

## IPv6 on the EdgeRouter
El cortafuegos para IPv6 es independiente del cortafuegos de IPv4 y actualmente debe configurarse mediante la CLI ("establecer el nombre de ipv6 del cortafuegos...", etc.). O el árbol de configuración en la interfaz de usuario web, por lo que deberá crear reglas de IPv6 por separado y aplicarlas a la interfaz/dirección adecuada.

### Firewall
Primero, es importante que configuremos el firewall ya que la política predeterminada es "aceptar" y sus clientes de LAN tendrán IP enrutables.

En comparación con nuestras reglas de firewall IPv4, hay una diferencia importante: debemos permitir ICMPv6 y DHCP para que DHCPv6-PD funcione.

- Cree una política para clientes WAN->LAN:
```sh
edit firewall ipv6-name WAN6_IN
set default-action dropset rule 10 action accept
set rule 10 description "allow established"
set rule 10 protocol all
set rule 10 state established enable
set rule 10 state related enableset rule 20 action drop
set rule 20 description "drop invalid packets"
set rule 20 protocol all
set rule 20 state invalid enableset rule 30 action accept
set rule 30 description "allow ICMPv6"
set rule 30 protocol icmpv6
top
```

- Ahora cree una política para WAN->Router (también conocido como local):
```sh
edit firewall ipv6-name WAN6_LOCAL
set default-action dropset rule 10 action accept
set rule 10 description "allow established"
set rule 10 protocol all
set rule 10 state established enable
set rule 10 state related enableset rule 20 action drop
set rule 20 description "drop invalid packets"
set rule 20 protocol all
set rule 20 state invalid enableset rule 30 action accept
set rule 30 description "allow ICMPv6"
set rule 30 protocol icmpv6set rule 40 action accept
set rule 40 description "allow DHCPv6 client/server"
set rule 40 destination port 546
set rule 40 source port 547
set rule 40 protocol udp
top
```

- Ahora adjunte las políticas a su interfaz WAN:
```sh
set interfaces ethernet eth1 firewall in ipv6-name WAN6_IN
set interfaces ethernet eth1 firewall local ipv6-name WAN6_LOCAL
```

- Ahora solicitaremos direcciones IPv6 a nuestro ISP. Es posible que deba descubrir manualmente la longitud del prefijo que proporciona su ISP. Las dos longitudes más comunes son /56 y /64.
> Nota: Usaremos SLAAC (Configuración automática de direcciones sin estado) en lugar de DHCP con estado (que es como funciona DHCP IPv4).

```sh
edit interfaces ethernet eth1
set dhcpv6-pd pd 0 prefix-length /64
set dhcpv6-pd pd 0 interface eth0 host-address ::1
set dhcpv6-pd pd 0 interface eth0 prefix-id :0
set dhcpv6-pd pd 0 interface eth0 service slaac
top
```

En resumen, le estamos diciendo a eth1 (WAN) que proporcione delegación de prefijo a eth0 (LAN). Si también está usando eth2 para un segundo puerto LAN, necesitará usar el prefijo-id:1 para esa interfaz.

> Para cualquiera que use vlans, lo siguiente también funciona:
```sh
set interfaces ethernet eth2 vif 17 ipv6 router-advert prefix ::/64
```

- Para hacerlo vía [GUI](https://davidwesterfield.net/2021/03/enabling-ipv6-prefix-delegation-on-att-internet-for-a-second-firewall/). No lo recomiendo.

- Información
<ul>
<li><a href="https://davidwesterfield.net/2020/06/edgerouter-4-ipv6-setup"><img src="https://img.shields.io/badge/Link-green.svg?style=flat" alt="Link"></a></li>
<li><a href="https://noobient.com/2018/08/02/ipv6-on-ubnt-edgerouter-x-with-digi-pppoe/#Firewall"><img src="https://img.shields.io/badge/Link-green.svg?style=flat" alt="Link"></a></li>
<li><a href="https://help.pentanet.com.au/hc/en-us/articles/4403292092307-IPv6-configuration-on-Ubiquiti-Edgerouters"><img src="https://img.shields.io/badge/Link-green.svg?style=flat" alt="Link"></a></li>
</ul>

### Opciones básicas del cortafuegos
Este cortafuegos básico permite a los usuarios hacer ping a un dispositivo IPv6 desde Internet. El resto del tráfico hacia el dispositivo está bloqueado (acción por defecto drop).

```sh
set firewall ipv6-name ipv6-fw default-action drop
set firewall ipv6-name ipv6-fw description 'IPv6 firewall'
set firewall ipv6-name ipv6-fw rule 1 action accept
set firewall ipv6-name ipv6-fw rule 1 log disable
set firewall ipv6-name ipv6-fw rule 1 protocol icmpv6
set firewall ipv6-name ipv6-fw rule 1 description 'allow ICMPv6 traffic'
set firewall ipv6-name ipv6-fw rule 10 action accept
set firewall ipv6-name ipv6-fw rule 10 state established enable
set firewall ipv6-name ipv6-fw rule 10 state related enable
```

### Permitir que un host sea de acceso público
```sh
set firewall ipv6-name ipv6-fw rule 4 action accept
set firewall ipv6-name ipv6-fw rule 4 description 'allow access to host x'
set firewall ipv6-name ipv6-fw rule 4 destination address '2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxx
```

## Dual-wan

### Establecer nat para ambas interfaces
```sh
set load-balance group LB-GROUP interface eth3 failover-only
set load-balance group LB-GROUP interface eth3 route-test initial-delay 60
set load-balance group LB-GROUP interface eth3 route-test interval 10
set load-balance group LB-GROUP interface eth3 route-test type ping target 1.1.1.1

set load-balance group LB-GROUP interface pppoe0 route-test initial-delay 60
set load-balance group LB-GROUP interface pppoe0 route-test interval 10
set load-balance group LB-GROUP interface pppoe0 route-test type ping target 1.1.1.1

set load-balance group LB-GROUP lb-local enable
set load-balance group LB-GROUP lb-local-metric-change disable
```

## NAT
NAT (Network Address Translation) es una técnica utilizada en redes informáticas para permitir que varios dispositivos en una red privada se conecten a Internet utilizando una dirección IP pública única. NAT traduce las direcciones IP privadas de los dispositivos en la red privada en una dirección IP pública antes de enviar los paquetes a Internet y viceversa, cuando los paquetes regresan a la red privada.

### Source NAT and Masquerade
Las reglas NAT de origen se pueden utilizar para muchas aplicaciones diferentes. Un uso popular de NAT Masquerade es traducir un rango de direcciones privadas a una única dirección IP pública. Esto permite que los hosts detrás de EdgeRouter se comuniquen con otros dispositivos en Internet.

En la GUI se configura en: `Firewall/NAT > NAT > Add Source NAT Rule`

**Masquerade Rule**
Masquerade, también conocido como NAT de muchos a uno, PAT o sobrecarga de NAT. Un uso popular de NAT Masquerade es traducir un rango de direcciones privadas a una única dirección IP pública.

```sh
set service nat rule 5010 description 'masquerade for WAN'
set service nat rule 5000 log disable
set service nat rule 5010 outbound-interface eth0
set service nat rule 5010 type masquerade
set service nat rule 5010 protocol all
```

**Source NAT rule**
Source NAT se usa para proporcionar una traducción 1:1

```sh
set service nat rule 5000 description 'source NAT for 192.168.1.10'
set service nat rule 5000 outbound-interface eth0
set service nat rule 5000 type source
set service nat rule 5000 protocol all
set service nat rule 5000 outside-address address 203.0.113.2
set service nat rule 5000 source address 192.168.1.10
```

### Destination NAT
EL destination NAT y el Port Forwarding tienen el mismo propósito y se pueden usar para reenviar puertos a un host interno detrás de NAT. Destination NAT, también conocido como DNAT, es otra variante de NAT en la que se utiliza una dirección IP pública única para traducir las direcciones IP de destino de los paquetes que se envían desde Internet hacia la red privada.

En la GUI se configura en: `Firewall / NAT > NAT > +Add Destination NAT Rule`

```sh
set service nat rule 1 description https443
set service nat rule 1 destination address 203.0.113.1
set service nat rule 1 destination port 443
set service nat rule 1 inbound-interface eth0
set service nat rule 1 inside-address address 192.168.1.10
set service nat rule 1 inside-address port 443
set service nat rule 1 log disable
set service nat rule 1 protocol tcp
set service nat rule 1 type destination
```

### Reordenación de las reglas de firewall y NAT
Las reglas de firewall y NAT coinciden en orden de preferencia. Las reglas con un ID más bajo se comparan antes que las reglas con un ID más alto.

NAT y firewall se pueden reordenar desde la CLI usando el comando de cambio de nombre . Siga los pasos a continuación para reordenar las reglas:
**CLI**:  acceda a la interfaz de línea de comandos. Puede hacerlo usando el botón CLI en la GUI o usando un programa como PuTTY.

Para las reglas de firewall, edite el subárbol de configuración de firewall específico para cambiar el número de regla:
```sh
configure
edit firewall name <name>
rename rule 10 to rule 20
exit
commit ; save
```

Para las reglas de NAT, edite el subárbol de configuración de NAT para cambiar el número de regla:
```sh
configure
edit service nat
rename rule 5010 to rule 5020
exit
commit ; save
```
NOTE: La CLI también le permite cambiar el nombre de las reglas de firewall modificadas que se usan para el enrutamiento basado en políticas y el equilibrio de carga.


**GUI**: acceda a la interfaz de usuario web de EdgeRouter .

1. Navegue a la pestaña Firewall/NAT para modificar la política de firewall existente.
`Cortafuegos/NAT > Políticas de cortafuegos > Nombre de la política > Acciones > Editar`
2. Arrastre y reordene las reglas del cortafuegos en el orden deseado.
3. Guarde el nuevo orden de reglas.

Las reglas NAT se reordenan utilizando un método muy similar. Navegue a la pestaña Firewall/NAT > NAT y arrastre las reglas al orden deseado. Finalmente guarde el nuevo orden de reglas.
### Port Forwarding
Seleccione las interfaces WAN y LAN que se utilizarán para el reenvío de puertos.
- Pueden realizar el procedimiento mediante la GUI o mediante CLI.
- Mediante CLI: Firewall/NAT > Port Forwarding

:warning:  Asegúrate de cambiar el rando de la red a la de tu red y la interfaz a modificar
```sh
configure

set port-forward auto-firewall enable
set port-forward hairpin-nat enable
set port-forward wan-interface eth0
set port-forward lan-interface eth1

set port-forward rule 1 description https
set port-forward rule 1 forward-to address 192.168.1.10
set port-forward rule 1 forward-to port 443
set port-forward rule 1 original-port 443
set port-forward rule 1 protocol tcp

commit ; save
```

## ICMP
Para aquellos de ustedes que desean usar la GUI para habilitar/deshabilitar ICMP en una de sus interfaces WAN de EdgeRouter.

<ol>
<li>inicie sesión en su EdgeRouter.</li>
<li>haga clic en la pestaña <code>Firewall/NAT</code>.</li>
<li>haga clic en la pestaña <code>Firewall Policies</code>.</li>
<li>localice el conjunto de reglas llamado <code>WAN_LOCAL</code>, aquí es donde permitiremos hacer ping. edite el conjunto de reglas.</li>
<li>haga clic en el botón <code>Agregar nueva regla</code>. Aquí es donde agrega una nueva regla.</li>
<li>En la descripción, coloque algo como Permitir ping o denegar ping.</li>
<li>En <code>Acción</code>, haga clic en Aceptar o Denegar.</li>
<li>En Protocolo, seleccione Elija un protocolo por nombre y luego seleccione <code>icmp</code> en el menú desplegable.</li>
<li>Haga clic en la pestaña Destino y luego seleccione su Interfaz WAN del menú desplegable Dirección de interfaz.</li>
<li>Haga clic en Guardar</li>
</ol>
<p>Ahora su EdgeRouter responderá/denegará a las solicitudes de ping en la interfaz WAN que seleccionó.</p>
<div align="center">
  <a href="https://youtu.be/hTFqZAZeDqQ"><img src="https://img.youtube.com/vi/hTFqZAZeDqQ/0.jpg" alt="youtube"></a>
</div>


#### Avanzado
<p>Para otros que utilizan este método, también ayuda especificar más el tipo de ICMP dentro de la regla. El método GUI no tiene esta opción cuando establece la regla. Sin embargo, es fácil agregarlo en la pestaña <code>Árbol de configuración</code>.</p>

<ol>
<li>Haga clic en la pestaña <code>Árbol de configuración</code></li>
<li>Debajo del panel <code>Configuración</code> a la izquierda, expanda el nodo <code>firewall</code>, expanda el nodo <code>nombre</code>, expanda el nodo de <code>WAN_LOCAL</code>(donde hayan creado la regla icmp) y expanda el nodo de <code>regla</code>.</li>
<li>Una vez expanda el nodo <code>regla</code>, expanda la regla que hayan creado la regla ICMP. (cualquiera que sea el último, que debería ser la regla que acaba de establecer)</li>
<li>Una vez sepan la regla buscar el apartado <code>icmp</code>.</li>
<li>Ingrese el número de tipo de icmp como el valor de <code>tipo</code>.</li>
<li>Haga clic en Vista previa y haga clic en Aplicar en el cuadro de diálogo de configuración emergente.</li>
</ol>

#### Vía ***CLI*** sería:
```sh
set firewall name WAN_LOCAL rule 21 icmp type 8
```
#### :point_right: Tabla de tipos de ICMP
En la siguiente tabla aparece una recopilación de los tipos de paquetes más importantes basados en el Internet Control Message Protocol:

<table>
<thead>
<tr>
<th style="text-align:center">Tipo ICMP</th>
<th style="text-align:center">Tipo ICMPv6</th>
<th style="text-align:center">Nombre del tipo</th>
<th style="text-align:center">Descripción</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center">0</td>
<td style="text-align:center">129</td>
<td style="text-align:center">Echo Reply</td>
<td style="text-align:center">Respuesta a un ping de red para comprobar la accesibilidad</td>
</tr>
<tr>
<td style="text-align:center">3</td>
<td style="text-align:center">1</td>
<td style="text-align:center">Destination Unreachable</td>
<td style="text-align:center">Mensaje ICMP que informa acerca de, por ejemplo, la accesibilidad de red de los componentes del campo “Código” (red, protocolo, puerto, host), sobre problemas de enrutamiento o sobre el bloqueo por parte de los cortafuegos</td>
</tr>
<tr>
<td style="text-align:center">5</td>
<td style="text-align:center">137</td>
<td style="text-align:center">Redirect Message</td>
<td style="text-align:center">Mensaje sobre el redireccionamiento de un paquete para la red indicada (0), para el host escogido (1), para el servicio especificado y para la red (2) o para el servicio y host especificados (3)</td>
</tr>
<tr>
<td style="text-align:center">8</td>
<td style="text-align:center">128</td>
<td style="text-align:center">Echo Request</td>
<td style="text-align:center">Ping de red</td>
</tr>
<tr>
<td style="text-align:center">9</td>
<td style="text-align:center">134</td>
<td style="text-align:center">Router Advertisement</td>
<td style="text-align:center">Lo utilizan los routers para informarse acerca de los diferentes clientes de red</td>
</tr>
<tr>
<td style="text-align:center">11</td>
<td style="text-align:center">3</td>
<td style="text-align:center">Time Exceeded</td>
<td style="text-align:center">Informe de estado que o bien indica que el tiempo de vida (Time to Live, TTL) de un paquete (0) o el tiempo de espera para el ensamblaje de paquetes IP (1) ha expirado</td>
</tr>
<tr>
<td style="text-align:center">13</td>
<td style="text-align:center">13</td>
<td style="text-align:center">Timestamp</td>
<td style="text-align:center">Dota al paquete IP de una marca de tiempo que se corresponde con el momento del envío y que es de utilidad para la sincronización de dos ordenadores</td>
</tr>
<tr>
<td style="text-align:center">14</td>
<td style="text-align:center">-</td>
<td style="text-align:center">Timestamp Reply</td>
<td style="text-align:center">Mensaje de respuesta a una petición de marca de tiempo enviado por el destinatario tras la recepción de la misma</td>
</tr>
<tr>
<td style="text-align:center">30</td>
<td style="text-align:center">-</td>
<td style="text-align:center">Traceroute</td>
<td style="text-align:center">Tipo de mensaje ICMP obsoleto que se utilizaba para el seguimiento de la ruta de un paquete de datos en la red. Hoy en día se utilizan “Echo Request” y “Echo Reply” para estos fines</td>
</tr>
</tbody>
</table>

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# LLDP
En este punto vamos habilitar el Protocolo de Descubrimiento de Capa de Enlace (LLDP) en las interfaces de EdgeRouter.

## Habilitar servicio LLDP
En el EdgeRouter, es tan sencillo como entrar por cli, de esta forma lo habilitamos para todos los interfaces de red
```sh
configure
set service lldp interface all
commit ; save
```

O si queremos en algun interface concreto
```sh
configuration
set service lldp interface ethX
commit ; save
```

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# ROUTING
Estos procediminetos son muy extensos y para que el README no sea muy extenso, añado el enlace a la web donde se configura. Están muy bien explicados y redactados.

## Load Balancing
<a href="https://help.ui.com/hc/en-us/articles/205145990-EdgeRouter-WAN-Load-Balancing" target="_blank">Load Balancing</a>

## OSPF
<a href="https://help.ui.com/hc/en-us/articles/205204050-EdgeRouter-OSPF-Routing" target="_blank">OSPF</a>

## BGP
<a href="https://help.ui.com/hc/en-us/articles/205222990-EdgeRouter-Border-Gateway-Protocol-BGP-" target="_blank">BGP</a>

## VRRP
<a href="https://help.ui.com/hc/en-us/articles/204962174-EdgeRouter-Virtual-Router-Redundancy-Protocol-VRRP-" target="_blank">VRRP</a>

## Public Static IP Addresses
<a href="https://help.ui.com/hc/en-us/articles/204975244-EdgeRouter-Configuring-Public-Static-IP-Addresses" target="_blank">Public Static IP Addresses]</a>

## Static Route
<a href="https://help.ui.com/hc/en-us/articles/360024021873-EdgeRouter-How-to-Add-a-Static-Route" target="_blank">Static Route</a>

## VLANS

#### Creando redes internas en EdgeOS

Acabo de comprar un punto de acceso WiFi y lo conecté a eth3. Esta red no está etiquetada y se usa para que el AP se conecte a su controlador si es necesario. Es solo para fines administrativos y no fluirá tráfico real en esta red.

```sh
set interfaces ethernet eth3 poe output 24v

set interfaces ethernet eth3 address 192.168.20.1/24
set interfaces ethernet eth3 description "WIFI AP management"
set service dhcp-server shared-network-name vlan20 subnet 192.168.20.1/24 default-router 192.168.20.1
set service dhcp-server shared-network-name vlan20 subnet 192.168.20.1/24 dns-server 192.168.20.1
set service dhcp-server shared-network-name vlan20 subnet 192.168.20.1/24 start 192.168.20.10 stop 192.168.20.100
set service dhcp-server shared-network-name vlan20 subnet 192.168.20.1/24 unifi-controller 192.168.100.10
set service dns forwarding listen-on eth3
```
Ahora creamos un par de redes que deben transmitirse en el AP. Planeo usar vlan 30 como red confiable y vlan 40 como red de invitados. El tráfico a estas dos redes se envía como tráfico etiquetado al AP. El AP se encargará de colocar cada VLAN en su propio SSID.
```sh
set interfaces ethernet eth3 vif 30 address 192.168.30.1/24
set interfaces ethernet eth3 vif 30 description "WIFI trusted"
set service dhcp-server shared-network-name vlan30 subnet 192.168.30.1/24 default-router 192.168.30.1
set service dhcp-server shared-network-name vlan30 subnet 192.168.30.1/24 dns-server 192.168.30.1
set service dhcp-server shared-network-name vlan30 subnet 192.168.30.1/24 start 192.168.30.10 stop 192.168.30.100
set service dns forwarding listen-on eth3.30

set interfaces ethernet eth3 vif 40 address 192.168.40.1/24
set interfaces ethernet eth3 vif 40 description "WIFI guest"
set service dhcp-server shared-network-name vlan40 subnet 192.168.40.1/24 default-router 192.168.40.1
set service dhcp-server shared-network-name vlan40 subnet 192.168.40.1/24 dns-server 192.168.40.1
set service dhcp-server shared-network-name vlan40 subnet 192.168.40.1/24 start 192.168.40.10 stop 192.168.40.100
set service dns forwarding listen-on eth3.40
```

<div class="warning">
  :warning:
  <p><em>Recordar que los pasos aquí expuestos son orientativos. Solo mira esto como un <strong>ejemplo</strong> y utilízalos como una guía, ya que la configuración de vuestra red puede diferir con la de aquí expuesta. Pudiendo causar un mal funcionamiento de vuestra red. Las redes podrían haberse creado en cualquier interfaz para cualquier tipo de propósito, con o sin etiquetas.</em></p>
  <p><em>Recomiendo su lectura y compresión antes de aplicarlo sobre un entorno de producción.</em></p>
</div>

#### Cortafuegos: Protección de las redes internas
Ahora que tenemos un par de redes, el objetivo es aislar algunas de ellas. Como ejemplo, nos aseguraremos de que la red invitada `(vlan 40)` pueda conectarse a Internet, pero bajo ninguna circunstancia conectarse a nuestras otras redes internas, por ejemplo, `vlan 30`. Hacemos esto haciendo algunas reglas de propósito general que pueden ser reutilizadas si decidimos hacer otras redes protegidas.

El primer conjunto de reglas permite que todo el tráfico ingrese a través de la interfaz, excepto las nuevas conexiones a nuestras redes internas (192.168.0.0/16).
```sh
set firewall name PROTECT_IN default-action accept
set firewall name PROTECT_IN rule 10 action drop
set firewall name PROTECT_IN rule 10 description "Drop new connecions to LAN"
set firewall name PROTECT_IN rule 10 destination address 192.168.0.0/16
set firewall name PROTECT_IN rule 10 state new enable
set firewall name PROTECT_IN rule 10 protocol all
```
Nuevamente, necesitamos crear un conjunto de reglas que elimine todo lo destinado a la interfaz, excepto DNS y DHCP.
```sh
set firewall name PROTECT_LOCAL default-action drop
set firewall name PROTECT_LOCAL rule 10 action accept
set firewall name PROTECT_LOCAL rule 10 description "Allow DNS"
set firewall name PROTECT_LOCAL rule 10 destination port 53
set firewall name PROTECT_LOCAL rule 10 protocol udp
set firewall name PROTECT_LOCAL rule 20 action accept
set firewall name PROTECT_LOCAL rule 20 description "Accept DHCP"
set firewall name PROTECT_LOCAL rule 20 destination port 67
set firewall name PROTECT_LOCAL rule 20 protocol udp
```
Ahora solo necesitamos vincular estos conjuntos de reglas generales a nuestra interfaz vlan de invitados. – o cualquier otra interfaz que no queramos conectar a nuestra red interna.
```sh
set interfaces ethernet eth3 vif 40 firewall in name PROTECT_IN
set interfaces ethernet eth3 vif 40 firewall local name PROTECT_LOCAL
```

# LAN
:warning: Asegúrate de adaptar el rango de la red a la de tu red y la interfaz a modificar, porque puede no ajustarse a la del ejemplo.

## DHCP

### Modificar DHCP mediante CLI
```sh
configure
set interfaces ethernet eth1 description LAN
set interfaces ethernet eth1 address 192.168.1.1/24
set service dhcp-server disabled false
set service dhcp-server shared-network-name LAN authoritative enable
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 default-router 192.168.1.1
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 dns-server 192.168.1.1
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 lease 86400
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 start 192.168.1.38 stop 192.168.1.243
set service dns forwarding listen-on eth3
commit ; save
```

### Modificar DHCP mediante GUI
Lo primero es acceder a la web de gestión a la web de gestion del router. Una vez dentro en tramos en la pestaña <code>Services</code> y después en la sub-pestaña <code>DHCP Server</code>. Aquí se podrán ver los servicios <code>DHCP</code> que tenemos en marcha, si es la primera este listado estará vacío por lo que pulsamos en el botón <code>+ Add DHCP Server</code>.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/f094ef4b-f2a1-49b1-ba21-6892489d48e5" alt="dhcp_1.png"></p>

Nos aparecerá un formulario que deberemos rellenar con los datos adecuados a nuestras necesidades.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/27b6f5fc-0955-4c48-9307-d8bd91f6ffdf" alt="dhcp_2.png"></p>

<p>  &nbsp;<code>DHCP Name</code>: Podremos darle un nombre al servicio pero eso si, no se pueden utilizar espacios.
<p>  &nbsp;<code>Subnet</code>: Definimos la subred que ya tengamos configurada en alguna interfaz de nuestro router.
<p>  &nbsp;<code>Range Start</code>: metemos la dirección IP por la que empezara el rango que queremos que sirva nuestro DHCP.
<p>  &nbsp;<code>Range Stop</code>: la dirección IP fin del rango de direcciones a repartir.
<p>  &nbsp;<code>Router</code>: Este sería el Gateway, es decir, la salida a otras redes de nuestra LAN, ya sea internet o aotras redes.
<p>  &nbsp;<code>DNS 1</code>: Dirección IP del servidor DNS primario.
<p>  &nbsp;<code>DNS 2</code>:: Dirección IP del servidor DNS secundario.
<p>  &nbsp;<code>:Enable</code>:* Marcamos este checkbox para que una vez pulsemos el botón Save, se guarde la configuración y esta empiece a funcionar. Si no lo marcamos, la configuración se guardará pero esta no estará habilitada, así que el servicio no empezara a repartir direcciones IP.

Por ultimo pulsamos en el botón <code>Save</code>. Desde ese mismo momento cualquier dispositivo que se conecte a la red de nuestro router y solicite una dirección IP, el servicio que acabamos de configurar le asignara una del rango predefinido.

### Ver estado del DHCP
Ahora que está en marcha podemos interactuar con el servicio pudiendo cambiar su configuración o viendo el estado de asignaciones <code>(leases)</code> de direcciones IP.

Para ello en basta con pulsar en el menú desplegable <code>Actions</code> y después en <code>View Details</code>.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c5850c1c-0cd6-4f6d-9fe9-929e5d7b8625" alt="dhcp_3.png"></p>

Se nos cargara las características del servicio pudiendo cambiarlas si es que lo deseamos. También aparecerá un resumen del estado del servicio, como la cantidad de IPs tiene de para repartir, cuantas estas asignadas, cuantas dispone para repartir etc.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/7a51ed87-52aa-40e5-a72a-7a006bbdd2a2" alt="dhcp_4.png"></p>

También hay opción de asignar una dirección del rango de manera estática a un dispositivo de nuestra red. Bastara con pulsar en <code>Create New Mapping</code> y asignar un IP del rango a la dirección MAC del dispositivo.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c5f5e5ae-4046-4988-bac0-2e73128436de" alt="dhcp_5.png"></p>

En la pestaña <code>Leases</code> nos encontraremos con aquellas direcciones que ya están asignadas a algún dispositivo. Pudiendo ver cuánto tiempo les queda de asignación y pudiendo asignar de manera estática la IP que ya tienen asignada.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/c93be274-8139-4a96-bf68-9cfaef0df53a" alt="dhcp_6.png"></p>

- Vía CLI: `show dhcp leases` muestre la dirección IP, la dirección MAC, el grupo y el nombre del cliente 


## Configurar IP estática para dispositivo 
```sh
set service dhcp-server shared-network-name MGMT-VLAN subnet 10.10.99.0/24 static-mapping cgn-monitor ip-address 10.10.99.11
set service dhcp-server shared-network-name MGMT-VLAN subnet 10.10.99.0/24 static-mapping cgn-monitor mac-address '52:54:xx:xx:xx:xx'
```

## Router switch
El router también puede actuar como un conmutador. Aquí hay un ejemplo:
```sh
set interfaces switch switch0 address 172.22.1.1/24
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth2
set interfaces switch switch0 switch-port interface eth3
set interfaces switch switch0 switch-port interface eth4
set interfaces switch switch0 switch-port vlan-aware disable
```

## DNS DINAMICO

<details>
    <summary>Mediante interfaz GUI:</summary>

### Instrucciones de uso con GUI:
1. Estando dentro de la web de gestión entramos en la pestaña <code>Service</code> y a continuación en <code>DNS</code>. Por ultimo en la sección <em>Dynamic DNS</em> pulsamos el botón <code>+ Add DDNS Interface</code>.
2. Se cargará un formulario vació que deberemos rellenar con los datos adecuados:
<ul><code>Interface:</code> Aquí hay que seleccionar la interfaz en la que está configurada nuestra IP pública.</ul>
<ul><code>Service:</code> En el menú desplegable hay varios servicios ya pre-configurados, pero entre ellos al no estar DuckDNS optamos por la opción custom.</ul>
<ul><code>Hostname:</code> Aquí hay que meter el subdominio DuckDNS que queremos asignar a nuestro router. Solamente el subdominio, no hace falta meter <code>.duckdns.org </code></ul>
<ul><code>Login:</code> poniendo nouser servirá, ya que nos identificaremos mediante nuestro Token.</ul>
<ul><code>Password:</code> Aquí deberemos introducir el Token de nuestra cuenta dyndns2.</ul>
<ul><code>Protocol:</code> Seleccionamos el protocolo.</ul>
<ul><code>Server:</code> por último metemos la url del servidor de DuckDNS, www.duckdns.org.</ul>

3. Para terminar pulsamos en Apply para guardar todo lo que hemos metido.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/e40473fb-b7cb-4e81-92c0-05fd417b98ba" alt="GUI1"></p>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/4a8523fd-642a-4f82-b833-9b2cdae3ea7c" alt="GUI2"></p>

&nbsp;
</details>
&nbsp;

<details>
    <summary>Mediante interfaz CLI:</summary>

### Instrucciones de uso con CLI:

Esto podemos realizarlo conectando al router mediante el protocolo SSH o usando el intérprete CLI incorporado en la propia web de gestión.
En todo caso ya sea mediante un método u otro, deberemos iniciar sesión utilizando las mismas credenciales que usamos para acceder vía web.

1. Accedemos por ssh o cli web.
2. Configuramos lo siguiente y con atención:
:warning:  <sup><strong><font style="vertical-align: inherit;">ATENCIÓN: </font></strong> Teneis que cambiar el "SUBDMIONIO", "TOKEN" y la "INTERFAZ".</sup>
```sh
configure
set service dns dynamic interface INTERFAZ service custom-duckdns
set service dns dynamic interface INTERFAZ service custom-duckdns host-name SUBDMIONIO
set service dns dynamic interface INTERFAZ service custom-duckdns login nouser
set service dns dynamic interface INTERFAZ service custom-duckdns password TOKEN
set service dns dynamic interface INTERFAZ service custom-duckdns protocol dyndns2
set service dns dynamic interface INTERFAZ service custom-duckdns server www.duckdns.org
commit ; save
```
3. Periódicamente el router ira actualizando nuestra IP pública en el DNS de DuckDNS. En caso de querer forzar la actualización, se puede realizar lanzando el siguiente comando.
<ul><code>update dns dynamic interface INTERFAZ</code></ul>
4. Si hemos realizado bien todos los pasos anteriores, ejecutando el siguiente comando veremos si todo está funcionando como debería.
<p><code>show dns dynamic status</code></p>

```sh
interface    : INTERFAZ
ip address   : xxx.xxx.xxx.xxx
host-name    : SUBDOMINIO
last update  : Tue Jun 23 16:28:09 2024
update-status: good
```
 
<p>Si en el apartado <code>update-status:</code> vemos que aparece <code>good</code> es que todo está funcionando perfectamente.</p>


&nbsp;
</details>
&nbsp;

<details>
    <summary>Mediante interfaz CLI: Configuración de un servicio de DNS dinámico personalizado</summary>

<p><h2 id="configuraci-n-de-un-servicio-de-dns-din-mico-personalizado">Configuración de un servicio de DNS dinámico personalizado</h2></p>

En este ejemplo, se utiliza el servicio DNS dinámico de **Cloudflare**.

<p><h3 id="panel-de-control-de-cloudflare">Panel de control de Cloudflare</h3></p>
Antes de comenzar a configurar, vamos a configurar primero el panel de Cloudflare:
1. Creamos en el panel de <code>/dns/records</code> creamos un subdominio que usaremos. En IP usar por ejemplo la localhost, luego Cloudflare la actualizará.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/39dd0e60-006f-42c5-9581-8a71c7ccac47" alt="subdomain"></p>

2. Creamos un Token API, tomen ejemplo de la imagen. Para acceder es en <code>/profile/api-tokens</code>
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/09f18f1d-5ab7-42f4-b459-736b48cf34dd" alt="TokenAPI"></p>

3. Para la password de configuración se usa la Global KEY.
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/bd4adbfe-223c-4beb-9ab8-e7504f12cab7" alt="TokenGlobal"></p>

<p><h3 id="comenzamos-configuraci-n-del-router">Comenzamos configuración del router</h3></p>
<strong>CLI:</strong>  acceda a la interfaz de línea de comandos. Puede hacerlo usando el botón CLI en la GUI o usando un programa como PuTTY.

1. Ingrese al modo de configuración.
```sh
configure
```

2. Configure el nombre de host de DNS dinámico.
```sh
set service dns dynamic interface pppoe0 service custom-cloudflare host-name subdomain.domain.com
```

3. Defina las credenciales de DNS dinámico.

```sh
set service dns dynamic interface pppoe0 service custom-cloudflare login user@domain.com
set service dns dynamic interface pppoe0 service custom-cloudflare password your_cloudflare_global_API_key
```

<strong>NOTA:</strong>  La clave API de Cloudflare se utiliza en Ubiquiti la Global KEY. Esta clave se puede encontrar en su perfil de Cloudflare indicado anteriormente.

4. Defina el protocolo DNS dinámico y el servidor a conectar.

```sh
set service dns dynamic interface pppoe0 service custom-cloudflare protocol cloudflare
set service dns dynamic interface pppoe0 service custom-cloudflare server api.cloudflare.com/client/v4/
```

5. Especifique un nombre de dominio para la zona de Cloudflare.

```sh
set service dns dynamic interface pppoe0 service custom-cloudflare options zone=domain.com
```

Si desea establecer múltiples opciones, debe usar comillas dobles. Ejemplo:
<code>"zone=yourdomain.com use=web ssl=yes ttl=1"</code>
<p><sup>Si desea establecer opciones y no saben el significado, acceder al siguiente link: <a href="https://ddclient.net/#documentation"><img src="https://img.shields.io/badge/Link-green.svg?style=flat" alt="Link"></a></sup></p>

**NOTA:** Si se establece un subdominio, **también debe** existir en el portal de Cloudflare. El comando anterior solo actualizará un dominio existente.

6. Confirme los cambios y guarde la configuración.

```sh
commit ; save
```

<p><h3 id="atenci-n-problemas-de-cloudflare">ATENCIÓN: Problemas de Cloudflare</h3></p>
<p>La versión actual de ddclient es v3.8.3 (para Edge Router 4 con firmware [v2.0.9](https://ui.com/download/edgemax)). Esta versión anterior de ddclient no funciona con los nuevos tokens de API de cloudflare, por lo que debe usar el <strong>token de clave de API global</strong> anterior en su lugar.</p>
<p>Las versiones v3.9.x de ddclient deberían funcionar con los tokens api más nuevos, así que verifique cuál es la versión de ddclient que usa su firmware:</p>

```sh
/usr/sbin/ddclient --version
```

Puede averiguar qué parte del proceso está fallando llamando directamente a ddclient. Para obtener una salida de depuración, use lo siguiente (cambie el nombre del archivo conf para que coincida con la interfaz que está usando, por ejemplo, eth0 o pppoe0, etc.):

```sh
sudo /usr/sbin/ddclient -daemon=0 -debug -verbose -noquiet -file /etc/ddclient/ddclient_eth0.conf
```

Puede editar su ddclient.conf con el comando siguiente: (cambiar la interfaz que esté usando):

```sh
sudo vi /etc/ddclient/ddclient_eth0.conf
```

Esto facilitará probar diferentes configuraciones y solucionar su problema.  Si no está usando su nueva configuración, intente eliminar el archivo de caché, por ejemplo `sudo rm /var/cache/ddclient/ddclient_eth0.cache`(recuerde cambiar el nombre del archivo para que coincida con su interfaz nuevamente).

Una vez que lo tengas funcionando, actualiza tu configuración con `update dns dynamic interface eth0` y comprobar de nuevo `show dns dynamic status`

<p><em>En versiones de firmware más antiguas (anteriores a la v1.10.5), o para algunos proveedores (p. ej., Google Domains), también es necesario especificar la dirección del servidor remoto mediante el siguiente comando.</em></p>

7. Especifique el servidor remoto.

```sh
set service dns dynamic interface pppoe0 service custom-cloudflare server api.cloudflare.com/client/v4/
```

Puede verificar el estado y forzar una actualización del servicio DNS dinámico usando los siguientes comandos:

```sh
show dns dynamic status
update dns dynamic interface <interface-name>
```

Ejemplo de salida del comando <code>show dns dynamic status</code>:
<p><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/f207defd-504f-43de-92c8-c8fc1cadcab1" alt="command"></p>

<p><strong>NOTA:</strong>  Los servidores pueden tardar algún tiempo en actualizarse y resolver el nombre de host en la dirección correcta.</p>

&nbsp;
</details>
&nbsp;

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# Añadir listas de seguridad al firewall
Agregar listas de seguridad al firewall es una práctica común para mejorar la seguridad de un sistema informático. Una lista de seguridad es un conjunto de reglas que se configuran en el firewall para controlar el acceso a recursos del sistema o a la red. Estas reglas permiten o bloquean el tráfico entrante o saliente en función de ciertas condiciones, como la dirección IP de origen, el protocolo utilizado, el puerto de origen o destino, entre otros.

La configuración de una lista de seguridad puede ayudar a prevenir ataques maliciosos, como el acceso no autorizado a recursos del sistema, la propagación de malware o la denegación de servicio.
    
## Crear script

### Escoger script a utilizar
Antes de crear el script, asegurar que lista van a escoger, si `IPv4` o `IPv6`. Una vez sepan que lista, escoger el script correspondiente:
<p><ul><li><code>IPv4.sh:</code></li></ul></p>
<ul><ul><a title="list" href="https://github.com/azagramac/ubiquiti-edgerouter/blob/main/scripts/IPv4.sh" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/5396b9aa-5f7f-41bc-a713-974b3ad7c4a5" alt="download" width="100" align="center" /></a></ul></ul></p>

<p><ul><li><code>IPv6.sh:</code></li></ul></p>
<ul><ul><a title="list" href="https://github.com/azagramac/ubiquiti-edgerouter/blob/main/scripts/IPv6.sh" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/5396b9aa-5f7f-41bc-a713-974b3ad7c4a5" alt="download" width="100" align="center" /></a></ul></ul></p>


### Creamos el grupo y agregamos una regla de firewall a la WAN:
* Creamos un nuevo grupo y modificamos nombre de grupo.
<p><sup>Para ver los grupos que tenemos: <code>show firewall group network-group</code>.</sup></p>

```sh
set firewall group network-group SPAMHAUS_DROP
commit
```

* Para añadir la regla en el firewall, modificamos el número de regla y cambiamos el <code>network-group</code> con el nombre del grupo creado.
<p><sup>Para ver la regla y el orden: <code>show firewall name WAN_IN</code>.</sup></p>

```sh
set firewall name WAN_IN rule 10 source group network-group SPAMHAUS_DROP
set firewall name WAN_IN rule 10 description "networks to drop from spamhaus.org list"
set firewall name WAN_IN rule 10 action drop
set firewall name WAN_IN rule 10 state established enable
set firewall name WAN_IN rule 10 state new enable
set firewall name WAN_IN rule 10 state related enable
set firewall name WAN_IN rule 10 log enable
set firewall name WAN_IN rule 10 protocol all
commit ; save
```

<p>Importante, deshabilitamos el `auto-firewall` del port forwarding</p>

```sh
configure
set port-forward auto-firewall disable
commit ; save
```

<p><sup>El <code>auto-firewall</code> del <code>port forwarding</code> anula el cortafuegos real, por lo que establece reglas de permiso para esos puertos.</sup></p>

### Crear y Añadir el script /config/scripts/post-config.d/update-spamhaus
<p>Modificamos en el script el nombre de los argumentos: <code>NETGROUP</code>, con el nombre del grupo creado.</p>
<p>Las listas a añadir tienen que tener formato <code>.raw</code> o <code>.txt</code>.</p>

> EDIT: Crear el script en `/config/scripts/post-config.d` mejor que en `/config/scripts/` porque después de un reinicio el grupo de firewall volverá a estar vacío, pero si el script está en ese directorio `/config/scripts/post-config.d`, se ejecutará automáticamente después del arranque.

```sh
sudo vi /config/scripts/post-config.d/update-spamhaus
```

- Ahora pegan el scrip escogido en el punto: **[`^ Escoger script a utilizar ^`](#escoger-script-a-utilizar)**
<p><sup>Importante sustituir las listas si son <code>IPv4</code> o si son <code>IPv6</code>, en los siguientes ejemplos son <code>IPv4</code>.</sup></p>
<p>El comando VI del equipo no está completo, por lo que para guardar, utilizar <code>ZZ</code> o <code>:wq</code></p>

### Hazlo ejecutable:
```sh
sudo chmod +x /config/scripts/post-config.d/update-spamhaus
```

EJECUTAR:
```sh
sudo /config/scripts/post-config.d/update-spamhaus
```
<p><sup>No pensar que se ha quedado bloqueado al insertar el comando, tarda un poco si la lista es muy grande.</sup></p>

Resultado:
<ul><code>Added 561 entries to SPAMHAUS_DROP</code></ul>

## PROGRAMAR TAREA:

OPCIÓN 1:
### Este es el programador de tareas, configura para ejecutar un cron diario cada 12h:
<ul><code>set system task-scheduler {task update_spamhaus {crontab-spec "00 12 * * *"ejecutable {path /config/scripts/post-config.d/update-spamhaus}</code></ul>

### También puede colocar su configuración para que sobreviva a una actualización cada 24h:
<ul><code>set system task-scheduler SPAMHAUS {crontab-spec "00 24 * * *" executable {path /config/scripts/post-config.d/update-spamhaus}}</code></ul>


OPCIÓN 2:
###  Simplemente agregue el script al programador de tareas tal como está, cambiando el nombre del task y el path de su script:
<ul><code>set system task-scheduler task update-spamhaus executable path /config/scripts/post-config.d/update-spamhaus</code></ul>
<ul>Las tareas se programan en horas:<code>24h,48h...</code></ul>
<ul><code>set system task-scheduler task update-spamhaus interval 24h</code></ul>

* Ajustes de <code>system task-scheduler interval</code>
<ul><p><code>minutes</code>      Execution interval in minutes</ul></p>
<ul><p><code>minutes m</code>    Execution interval in minutes</ul></p>
<ul><p><code>hours h</code>      Execution interval in hours</ul></p>
<ul><p><code>days d</code>       Execution interval in days</ul></p>

--> Despues vemos las tareas
<ul><code>show system task-scheduler</code></ul>


### Buenas prácticas.
<p>Buenas prácticas para un correcto funcionamiento del firewall:</p>

- Coloque la regla spamhaus en primer lugar en WAN_IN y WAN_LOCAL (es decir, antes de la regla de permiso para conexiones establecidas y relacionadas). Esto es para evitar la situación "rara" de que un host interno (por ejemplo, infectado con malware) de alguna manera establezca una conexión con un host listado de spamhaus, dando la oportunidad de usar la conexión establecida para fines de spam.
- Ponga la regla de spamhaus en WAN_OUT, otra vez antes que cualquier otra cosa.
- Hoy noté en mis registros que el WAN_OUT coincidió (y rechazó) con el tráfico saliente a la dirección IP 185.3.135.146 (búsqueda de spamhaus aquí, listado desde el 29/2/2016). Este tráfico se originó en el cliente bittorrent que se ejecuta en mi NAS. No sé si los spammers usan bittorrent para infiltrarse en hosts posiblemente vulnerables, pero lo considero como un paso de protección adicional que funcionó.
- Debería asignar las reglas de firewall solo en el pppoe

## README con listas de IPs públicas
<p><a title="list" href="https://github.com/azagramac/ubiquiti-edgerouter/tree/main/list" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/deef8e5a-a511-4848-9e70-7b6437a0dc3e" alt="list" width="60" align="center" /></a></p>

## REVISIÓN
<p>Listar</p>
<ul><code>sudo /sbin/ipset list update-spamhaus o sudo /sbin/ipset list -L update-spamhaus</code></ul>
<ul><li>Sin que muestre las ips: <code>sudo /sbin/ipset list -t</code></li></ul>
<p>Comprobar una ip</p>
<ul><code>sudo /sbin/ipset test update-spamhaus 192.168.1.100</code></ul>
<p>Limpiar grupo de IPs</p>
<ul><code>sudo /sbin/ipset flush update-spamhaus</code></ul>
<p>Utilice este comando a través de la CLI para ver las entradas:</p>
<ul><code>show firewall group SPAMHAUS_DROP</code></ul>
<p>Despues vemos las tareas</p>
<ul><code>show system task-scheduler</code></ul>
<p>Ver log</p>
<ul><code>cat /var/log/messages</code></ul>


### EJEMPLO DE REGLAS:
```sh
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        enable-default-log
        rule 10 {
            action drop
            description "Networks to drop from spamhaus.org list"
            log enable
            source {
                group {
                    network-group SPAMHAUS_DROP
                }
            }
        }
.........................
.........................

 name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        enable-default-log
        rule 10 {
            action drop
            description "Networks to drop from spamhaus.org list"
            log enable
            source {
                group {
                    network-group SPAMHAUS_DROP
                }
            }
        }
.........................
.........................

    name WAN_OUT {
        default-action accept
        description "WAN OUT firewall rules"
        rule 10 {
            action reject
            description "Networks to drop from spamhaus.org list"
            destination {
                group {
                    network-group SPAMHAUS_DROP
                }
            }
            log enable
        }
```
### EJEMPLO DE INTERFAZ WAN:
```sh
ethernet eth1 {
        description "Internet (PPPoE)"
        duplex auto
        firewall {
            in {
                name WAN_IN
            }
            local {
                name WAN_LOCAL
            }
        }
        pppoe 0 {
            default-route auto
            firewall {
                in {
                    name WAN_IN
                }
                local {
                    name WAN_LOCAL
                }
            }
```

## Monitorización de IPs bloqueadas
He creado un script para poder informar al telegram de las IPs bloqueadas por una regla desde el log.
<ul><p><sup>Modificar en el script la WAN con la regla a buscar y añadir vuestro ID CHAT y token del bot.</sup></ul></p>
<ul><p>El script pueden descargarlo o verlo desde la carpeta del repositorio en este enlace:</ul></p>
<ul><p><a title="download" href="https://github.com/azagramac/ubiquiti-edgerouter/blob/main/scripts/TelegramQueryLog.sh" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/5396b9aa-5f7f-41bc-a713-974b3ad7c4a5" alt="download" width="100" align="center" /></a></ul></p>
<ul><p>Tambien he dejado la consulta con AbuseIPDB.</ul></p>
<ul><p><a title="download" href="https://github.com/azagramac/ubiquiti-edgerouter/blob/main/scripts/TelegramQueryLog_ABUSEIPDB" target="_blank"><img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/5396b9aa-5f7f-41bc-a713-974b3ad7c4a5" alt="download" width="100" align="center" /></a></ul></p>

## Cortafuegos por país en Edgerouter
Ejemplo:
`Tengo un pequeño servidor web ejecutándose dentro de mi red en el puerto 55555. Solo quiero que mis amigos puedan acceder a él. Sé que viven en Dinamarca, Noruega y Suecia. Quiero asegurarme de que China, Rusia y otras partes del mundo no tengan acceso, para minimizar el riesgo de explotar los días cero en mi servidor.`

#### Configuración del Edgerouter

Esta es la configuración que agrego:
```sh
set firewall group network-group countries_allowed description 'Allowed countries'
set firewall group network-group countries_allowed network 10.254.254.254/31
set service nat rule 10 description 'My funny dmz server'
set service nat rule 10 destination group address-group ADDRv4_eth0
set service nat rule 10 destination port 55555
set service nat rule 10 inbound-interface eth0
set service nat rule 10 inside-address address 192.168.xxx.xxx
set service nat rule 10 inside-address port 55555
set service nat rule 10 protocol tcp

set firewall name WAN_IN rule 20 action accept
set firewall name WAN_IN rule 20 description 'My funny dmz server'
set firewall name WAN_IN rule 20 destination port 55555
set firewall name WAN_IN rule 20 protocol tcp
set firewall name WAN_IN rule 20 source group network-group countries_allowed

commit
```

Esto básicamente hace lo siguiente:

  1. Crea un grupo de red que será un marcador de posición para todas las subredes a las que quiero permitir el acceso a mi servidor. Solo agrego una regla, que estará allí cuando se inicie Edgerouter. Eso significa que todo (excepto una IP arbitraria/aleatoria `10.254.254.254`) está bloqueado hasta que las reglas reales del país se carguen más tarde.
  2. Luego crea una regla de reenvío NAT que reenvía todo el tráfico al puerto `55555` que ingresa en mi interfaz externa (`eth0`) a mi servidor interno
  3. Permite el tráfico a mi servidor en el cortafuegos si el tráfico se origina en mi grupo de red "countries_allowed"

#### Obtener subredes de países

Ahora creo un archivo de script "`/config/scripts/post-config.d/country-load`" (`chmod 755`):
```sh
#!/bin/bash
countryList="dk no se"
firewallGroupName=countries_allowed

#mkdir /config/zonefiles
function loadcountry () {
        firewallGroupName=$1
        country=$2

        echo "Downloading country definition for $country..." >> /var/log/alex
        wget http://www.ipdeny.com/ipblocks/data/countries/${country}.zone -O /config/zonefiles/${country}.zone -q
        echo "Adding rules to firewall group $firewallGroupName..." >> /var/log/alex
        for rule in `cat /config/zonefiles/${country}.zone`; do
                ipset add $firewallGroupName $rule
        done
}

ipset -F $firewallGroupName
for country in $countryList; do
        loadcountry $firewallGroupName $country
done
```

Este script se ejecutará cuando se inicie Edgerouter:

  1. Recorra la lista de países definidos en la parte superior del script
  2. Descarga una lista de subredes en cada país
  3. Agréguelo a la tabla ipset (eso es lo que usa Edgerouter para los grupos de red)

#### Pruebas

Después de reiniciar el enrutador de borde o ejecutar manualmente el script, puede verificar que realmente tenemos algunas subredes en nuestro grupo de red:
```sh
ipset -L countries_allowed
```

---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# POSIBILIDAD DE AÑADIR UN CERTIFICADO A LOCALHOST
<img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/cd6c628f-ade0-4841-a2ff-4dafc94ae429" alt="Ubiquiti edgemax" width="40"/>

### Añadir certificado CA para localhost
Usando [mkcert](https://words.filippo.io/mkcert-valid-https-certificates-for-localhost/) para crear un certificado CA para localhost.  
Opción de ir a la ruta de certificados SSL con Let's Encrypt hay varios diferentes para elegir. Por ejemplo, [ubnt-letsencrypt](https://github.com/j-c-m/ubnt-letsencrypt) por [Jesse Miller](https://github.com/j-c-m)

```sh
configure
set system static-host-mapping host-name <hostname> inet <ip-of-edgerouter>
commit ; save
```

**Crear certificado**
```sh
mkcert <ip-of-edgerouter> <hostname>
cat <ip-of-edgerouter>+1-key.pem <ip-of-edgerouter>+1.pem > server.pem
```

**Copia de seguridad del archivo de certificado existente**
```sh
sudo cp /etc/lighttpd/server.pem /etc/lighttpd/.server-OLD.pem
exit
```

**Copie el nuevo archivo de certificado en la dirección del usuario de su router**
```sh
scp /path/to/server.pem <user>@<ip-of-edgerouter>:/home/<user>/server.pem
```

**Copiar el nuevo archivo de certificado desde la dirección del usuario y habilitar el certificado**
```sh
sudo cp /home/<user>/server.pem /etc/lighttpd/server.pem
# Kill webserver service by PID
sudo kill -SIGINT $(cat /var/run/lighttpd.pid)
# Start webserver
sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
exit
```

**Comprueba tu conexión con curl**
Si se hace correctamente, una forma de comprobarlo es utilizar curl. Si obtiene una redirección a un puerto de protocolo SSL, es decir, 443, el certificado está instalado correctamente en su router.

```sh
$ curl -I http://<ip-of-edgerouter>/
HTTP/1.1 301 Moved Permanently
Location: https://<ip-of-edgerouter>:443/
Date: Sun, 11 Jan 2015 07:46:13 GMT
Server: Server
```
---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# OpenVPN
Este tutorial describe como configurar un servidor OpenVPN en un EdgeRouter.

## Configuración EdgeRouter como servidor OpenVPN. (Servidor)

### Crear certificados
Aqui hay una lista con los archivos que necesitas. Puedes usar el Software XCA <a href="https://github.com/chris2511/xca/">XCA</a> para eso.
- ca.crt (CA Raíz)
- server.crt (Certificado del Servidor)
  - Para prevenir ataques MITM asegúrese de configurar
     - Uso de claves X509v3: Firma digital, cifrado de claves
     - Uso extendido de claves X509v3: Autenticación de servidor web TLS
- server.key (Archivo de claves para el certificado del servidor)
- dh.pem (clave de intercambio de claves Diffie-Hellman; la buena es de 2048 bits)
- revocation-list.crl (Opcional; Lista de revocación de certificados)

Una vez creados los archivos, cópielos todos en `/config/auth/`.

Para la configuración del cliente: Asegúrese de que `remote-cert-tls server` está activado.

### Configuración básica de OpenVPN
```sh
configure
set interfaces openvpn vtun0
set interfaces openvpn vtun0 mode server
set interfaces openvpn vtun0 server name-server 1.1.1.1 # change to your favourite
set interfaces openvpn vtun0 server domain-name example.com # change to your favourite
# set your network
set interfaces openvpn vtun0 server push-route 192.168.178.0/24 
# Establece el rango para los clientes openvpn. Los clientes recibirán una dirección IP de esta subred
set interfaces openvpn vtun0 server subnet 192.168.177.0/24
```

### Configuración del certificado
Como se ha descrito anteriormente. Asegúrese de que su clave privada tiene `sudo chmod 600`.
```sh
set interfaces openvpn vtun0 tls ca-cert-file /config/auth/ca.crt
set interfaces openvpn vtun0 tls cert-file /config/auth/server.crt
set interfaces openvpn vtun0 tls dh-file /config/auth/dh2048.pem
set interfaces openvpn vtun0 tls key-file /config/auth/server.key
# optional: set revocation list
set interfaces openvpn vtun0 tls crl-file /config/auth/revocation-list.crl
```

### Configurar el registro
```sh
set interfaces openvpn vtun0 openvpn-option "--log /var/log/openvpn.log"
set interfaces openvpn vtun0 openvpn-option "--status /var/log/openvpn-status.log"
set interfaces openvpn vtun0 openvpn-option "--verb 7"
```

### Configuración del cortafuegos
No olvides configurar NAT para los clientes openvpn.
```sh
set firewall name XXX rule XX action accept
set firewall name XXX rule XX description 'Allow OpenVPN'
set firewall name XXX rule XX destination port 1194
set firewall name XXX rule XX log disable
set firewall name XXX rule XX protocol udp
```
## WireGuard server
<img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/0635ed8a-4df3-4faf-a47f-33ddbbecbe78" alt="Wireguard" width="64"/>

### Instalar servidor Wireguard, for ER-4, ER-6P, ER-12 and ER-12P solamente.
```sh
cd /home/ubnt
curl -OL https://github.com/WireGuard/wireguard-vyatta-ubnt/releases/download/1.0.20220627-1/e300-v2-v1.0.20220627-v1.0.20210914.deb
sudo dpkg -i e300-v2-v1.0.20220627-v1.0.20210914.deb
```
### Generar claves
```sh
cd /home/ubnt
mkdir -p wireguard/server; cd wireguard/server/
wg genkey | tee private_server.key | wg pubkey > public_server.key
cat private_server.key
cat public_server.key
```

### Crear semillas, los clientes.
```sh
cd /home/ubnt/wireguard/
mkdir peer1; cd peer1 ## aqui crearas tantos usuarios necesites, cambia el numero por cada cliente que generes. 
wg genkey | tee private_peer.key | wg pubkey > public_peer.key
wg genpsk > presharedkey_peer.key
cat private_peer.key 
cat public_peer.key
cat presharedkey_peer.key
```

### Configuracion del servidor
```sh
configure
set interfaces wireguard wg0 private-key /home/ubnt/wireguard/server/private_server.key
set interfaces wireguard wg0 route-allowed-ips true
set interfaces wireguard wg0 listen-port 51820       ## El puerto por defecto de Wireguard, recomendable cambiarlo.
set interfaces wireguard wg0 address 10.10.1.0/24    ## el rango de IP pondremos el que queramos que tengan los clientes que se vayan a conectar y el [CIDR](https://azagramac.gitbook.io/myblog/linux/cidr-mascaras-de-subred).
```

### Configuramos los clientes
```sh
set interfaces wireguard wg0 peer1 $(cat /home/ubnt/wireguard/peer1/public_peer.key) allowed-ips 10.10.1.10/32          ## Añadimos la public key de cada peer, y le asignamos su IP
set interfaces wireguard wg0 peer1 $(cat /home/ubnt/wireguard/peer1/public_peer.key) endpoint YOUR_DDNS_DOMAIN:51820    ## Ponemos nuestro DDNS y el puerto
set interfaces wireguard wg0 peer1 $(cat /home/ubnt/wireguard/peer1/public_peer.key) description OnePlus                ## Ponemos una descripcion
```

### Aplicamos las reglas
```sh
set firewall name WAN_LOCAL rule 30 action accept
set firewall name WAN_LOCAL rule 30 protocol udp
set firewall name WAN_LOCAL rule 30 destination port 51820
set firewall name WAN_LOCAL rule 30 description 'WireGuard'

set firewall name WG_IN default-action drop
set firewall name WG_IN description 'Wireguard to LAN'

set interfaces wireguard wg0 firewall in name WG_IN
set interfaces wireguard wg0 firewall local name WG_LOCAL
```

### Guardamos los cambios
```sh
commit ; save
```

### Fichero de configuracion
```sh
vi /home/ubnt/wireguard/peer1/peer.conf

[Interface]
Address = 10.10.1.10
PrivateKey = ## Clave publica del cliente, /home/ubnt/wireguard/peer1/private_peer.key
ListenPort = 51820
DNS = 1.1.1.1,1.0.0.1

[Peer]
PublicKey = ## Clave publica del servidor, /home/ubnt/wireguard/peer1/private_peer.key
PresharedKey = ## Clave preshared del cliente, /home/ubnt/wireguard/peer1/presharedkey_peer.key
Endpoint = YOUR_DDNS_DOMAIN:51820
AllowedIPs = 0.0.0.0/0
```

Ya tenemos el servidor, y el fichero de configuracion, necesitamos el cliente.
- [Android](https://play.google.com/store/apps/details?id=com.wireguard.android)
- [iPhone/iPad](https://apps.apple.com/es/app/wireguard/id1441195209)
- [MacOS](https://apps.apple.com/us/app/wireguard/id1451685025?mt=12)
- [Windows](https://download.wireguard.com/windows-client/wireguard-installer.exe)


## OpenVPN (client)
<img src="https://github.com/azagramac/ubiquiti-edgerouter/assets/571796/2467da27-d3c3-4e5b-887b-361db7686b50" alt="openvpn" width="64"/>
 Este tutorial describe cómo configurar el EdgeRouter como Cliente OpenVPN.

Usefull links:
- EdgeRouter OpenVPN to Private Internet Access!
<div align="center">
  <a href="https://youtu.be/B9dXiKhDVl0"><img src="https://img.youtube.com/vi/B9dXiKhDVl0/0.jpg" alt="youtube"></a>
</div>

- Dedicated Private Internet VLAN and Wireless Network
<div align="center">
  <a href="https://youtu.be/_TBj5MYmgQc"><img src="https://img.youtube.com/vi/_TBj5MYmgQc/0.jpg" alt="youtube"></a>
</div>

### Configuración básica
Primero necesita hacer ssh en su EdgeRouter. A continuación, cree un directorio donde almacenar sus archivos OpenVPN.

```sh
sudo su
mkdir -p /config/auth/example
```

En este ejemplo tengo los siguientes archivos:
- ca.crt (CA raíz)
- client.key (Clave privada del usuario)
- client.crt (Certificado de usuario)
- openvpn-static-key-v1.key (para tls-auth)
- example.ovpn (configuración del cliente OpenVPN (ver más abajo))

Asegúrese de que `key.pem` tiene `chmod 600`

### Ejemplo del archivo de configuración OpenVPN
Este archivo puede variar dependiendo de la configuración de su servidor openvpn.
```sh
client
dev tun
proto udp
remote YOUR_DOMAIN
resolv-retry infinite
nobind
persist-key
persist-tun
key-direction 1
remote-cert-tls server
auth-nocache
auth SHA512
cipher AES-256-GCM

# files
ca /config/auth/example/ca.crt
cert /config/auth/example/client.crt
key /config/auth/example/key.pem
tls-auth /config/auth/example/openvpn-static-key-v1.key 1
```

### Configurar la interfaz
Si ya ha configurado su EdgeRouter como un servidor OpenVPN, entonces usted necesita cambiar la interfaz de red de `vtun0` a otra cosa (por ejemplo, `vtun1`)

```sh
configure
set interfaces openvpn vtun0 description 'example vpn'
set interfaces openvpn vtun0 config-file /config/auth/example/example.ovpn
commit
save
```

### Setup an extra VLAN for clients
```sh
# create a new vlan (VLAN 10)
set interfaces switch switch0 vif 10 address 192.168.40.1/24
set interfaces switch switch0 vif 10 description 'example VLAN'
set interfaces switch switch0 vif 10 mtu 1500
```

### Setup a DHCP server
```sh
set service dhcp-server shared-network-name EXAMPLE-LAN authoritative disable
set service dhcp-server shared-network-name EXAMPLE-LAN subnet 192.168.40.0/24 default-router 192.168.40.1
set service dhcp-server shared-network-name EXAMPLE-LAN subnet 192.168.40.0/24 dns-server 1.1.1.1
set service dhcp-server shared-network-name EXAMPLE-LAN subnet 192.168.40.0/24 domain-name example.com
set service dhcp-server shared-network-name EXAMPLE-LAN subnet 192.168.40.0/24 lease 86400
set service dhcp-server shared-network-name EXAMPLE-LAN subnet 192.168.40.0/24 start 192.168.40.10 stop 192.168.40.100
```

### Setup NAT & routing
```sh
# setup NAT
set service nat rule 5020 description NAT-EXAMPLE-VPN
set service nat rule 5020 log disable
set service nat rule 5020 outbound-interface vtun0
set service nat rule 5020 source address 192.168.40.0/24
set service nat rule 5020 type masquerade

# setup routing
set protocols static table 1 interface-route 0.0.0.0/0 next-hop-interface vtun0

set firewall modify VPN_EXAMPLE_ROUTE rule 10 description 'Subnet to VPN'
set firewall modify VPN_EXAMPLE_ROUTE rule 10 source address 192.168.40.0/24
set firewall modify VPN_EXAMPLE_ROUTE rule 10 modify table 1

# apply the firewall route to VLAN 10
set interfaces switch switch0 vif 10 firewall in modify VPN_EXAMPLE_ROUTE
```
---
**[`^        back to top        ^`](#wiki-ubiquiti)**
# squidguard proxy
Puede utilizar su router Edge como un servidor proxy para bloquear ciertas categorías, por ejemplo, anuncios o malware.

## requisito previo
- SSH en su enrutador Edge.
- Descargue las categorías disponibles. Dependiendo de su dispositivo, esto puede tardar unos minutos (en mi dispositivo tardó unos 100 minutos).
- Actualizar y configurar <a href="https://help.ui.com/hc/en-us/articles/204961694-EdgeRouter-Web-Proxy" target="_blank">webproxy</a>

```sh
update webproxy blacklists
```

## ejemplo de configuración
```sh
set service webproxy cache-size 0
set service webproxy default-port 3128
set service webproxy listen-address 172.22.3.1
set service webproxy mem-cache-size 5
set service webproxy url-filtering squidguard block-category ads
set service webproxy url-filtering squidguard block-category porn
set service webproxy url-filtering squidguard default-action allow
set service webproxy url-filtering squidguard redirect-url 'https://brainoftimo.com/not-for-you'
```
### possible categories to block
- ads
- adult
- aggressive
- agressif
- arjel
- associations_religieuses
- astrology
- audio-video
- bank
- bitcoin
- blog
- celebrity
- chat
- child
- cleaning
- cooking
- cryptojacking
- dangerous_material
- dating
- ddos
- dialer
- download
- drogue
- drugs
- educational_games
- filehosting
- financial
- forums
- gambling
- games
- hacking
- jobsearch
- lingerie
- liste_blanche
- liste_bu
- local-ok-default
- local-ok-url-default
- mail
- malware
- manga
- marketingware
- mixed_adult
- mobile-phone
- phishing
- porn
- press
- proxy
- publicite
- radio
- reaffected
- redirector
- remote-control
- sect
- sexual_education
- shopping
- shortener
- social_networks
- special
- sports
- strict_redirector
- strong_redirector
- translation
- tricheur
- update
- violence
- warez
- webmail
---

**[`^        back to top        ^`](#wiki-ubiquiti)**
# Syslog
Configure el dispositivo para iniciar sesión en un SYSLOG
Nuestro Servidor Syslog tiene la ip de: `10.10.99.111`

Estamos registrando todo: (`level debug`) pero puede establecer otro nivel de registro, por ejemplo `level err`.
```sh
configure
set system syslog global facility all level notice
set system syslog global facility protocols level debug
set system syslog host 10.10.99.111 facility all level debug

commit
save
exit
```

**[`^        back to top        ^`](#wiki-ubiquiti)**

# Herramientas de diagnostico de red
Una herramienta de diagnóstico de red es un software que permite a los administradores de redes y a los usuarios comunes analizar y solucionar problemas de conectividad en una red informática. Estas herramientas pueden proporcionar información sobre la velocidad y el rendimiento de la red, la disponibilidad de los recursos de red, y la identificación de problemas de configuración o de seguridad.

<details>
<summary>BGP:</summary>

<Original>&nbsp;Pagina para comprobar tu BGP</Original>

<p>  &nbsp;&nbsp;https://isbgpsafeyet.com/</p>
</details>
&nbsp;

<details>
<summary>test IPv6/IPv4:</summary>

<Original>&nbsp;Pagina para comprobar IPv6/IPv4</Original>

<p>  &nbsp;&nbsp;https://www.whatismyip.com/</p>
<p>  &nbsp;&nbsp;https://www.wireshark.org/tools/v46status.html</p>
<p>  &nbsp;&nbsp;http://www.test-ipv6.com/</p>
<p>  &nbsp;&nbsp;https://ipv6-test.com/</p>
<p>  &nbsp;&nbsp;http://testmyipv6.com/</p>
<p>  &nbsp;&nbsp;https://ipv6test.google.com/</p>
</details>
&nbsp;

<details>
<summary>Test velocidad:</summary>

<Original>&nbsp;Pagina para comprobar la velocidad de conexión</Original>

<p>  &nbsp;&nbsp;https://speedsmart.net/</p>
<p>  &nbsp;&nbsp;https://www.speedtest.net/</p>
<p>  &nbsp;&nbsp;https://openspeedtest.com/</p>
<p>  &nbsp;&nbsp;https://speed.cloudflare.com/</p>
</details>
&nbsp;

<details>
<summary>Test DNS:</summary>

<Original>&nbsp;Pagina para comprobar las DNS de Cloudflare</Original>

<p>  &nbsp;&nbsp;https://1.1.1.1/help</p>
<p>  &nbsp;&nbsp;https://www.dnsleaktest.com/</p>
</details>
&nbsp;

# Unifi
Unifi es una plataforma de red desarrollada por Ubiquiti Networks que proporciona soluciones de administración de redes escalables y de alta calidad para pequeñas y medianas empresas, así como para usuarios domésticos avanzados. La plataforma Unifi permite a los usuarios controlar y supervisar de manera centralizada sus redes de acceso, puntos de acceso inalámbricos, cámaras de seguridad, interruptores y otros dispositivos de red mediante una interfaz de usuario intuitiva y fácil de usar. Unifi también ofrece una variedad de características avanzadas, como la capacidad de crear redes de invitados personalizadas, implementar políticas de seguridad, monitorear el rendimiento de la red y administrar dispositivos a través de la nube. En general, Unifi es una solución de red completa y confiable para aquellos que buscan una forma fácil y eficiente de administrar sus redes.

## UniFi Controller
[Docker UniFi Controller](https://github.com/azagramac/unificontroller-docker)

## Conclusión
Con esta información puedes configurar un EdgeMax© para sustituir un router neutro. Aquí podrás encontrar todo lo que he conseguido hacer con este router. Los pasos anteriormente explicados están basados en una red que puede diferir de la que tú tienes montada. Si sigues al pie de la letra todos los pasos, pueden no coincidir con la configuración de tu `red` y dejarla inservible. Adapta en todo momento la documentación que se ha expuesto para que cuadre con tu red.

<sup>Estos archivos/textos se proporcionan "TAL CUAL", sin garantías de ningún tipo, expresas o implícitas, incluidas, entre otras, las garantías de comerciabilidad, idoneidad para un fin determinado y no infracción. En ningún caso los autores o los titulares de los derechos de autor serán responsables de ninguna reclamación, daño u otra responsabilidad derivada de, o relacionada con los archivos o el uso de los mismos.</sup>

<sub>Todas y cada una de las marcas registradas son propiedad de sus respectivos dueños.</sub>
