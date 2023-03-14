# Objetivo

Este ejercicio tiene los siguientes objetivos:
- Desplegar un repositorio de imagenes de contenedores sobre la infraestructura de Azure a través del servicio Azure Container Registry
- Desplegar una app en forma de contenedor utilizando Podman sobre una maquina virtual en Azure
- Desplegar un cluster de Kubernetes sobre la infraestructura de Azure a través de Azure Kubernetes Service
- Desplegar una app con almacenamiento persistente sobre el cluster Azure Kubernetes Service

## Requisitos

- Crearemos un repositorio en GITHUB con licencia MIT. Asociaremos el sshkey que crearemos mas adelante con nuestra cuenta para poder gestionar los cambios en el repositorio.
- Utilizaremos como nodo de control un Ubuntu 20.04 sobre el servicio WSL en Windows 10.
- En este nodo instalamos AZ CLI y Terraform siguiendo los pasos aqui descritos:
    - Para la instalacion de AZ CLI utilizamos este enlace: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
    - Confirmamos la instalacion haciendo **az version**: 2.45.0
    - Vincularemos nuestro nodo de control con Azure a través de **az login --use-device-code** ya que si ejecutamos tan solo **az login** intenta abrirnos una web en nuestro nodo de control donde no tenemos interfaz.
    - Instalamos Terraform siguiendo estos pasos: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform
    - Confirmamos la instalacion mediante **terraform -version**
    - Creamos la estructura de carpetas para su posterior subida a GITHUB
    - Generamos la sshkey que utilizaremos para poder utilizar GITHUB desde el nodo de control
    - De la misma manera, generamos una clave publica y privada para el acceso a las maquinas virtuales que creemos en Azure

## Funcionamiento en Azure

Para poder generar los recursos de forma automatizada, hemos creado una carpeta **terraform** donde tenemos tres ficheros .tf:
- **main.tf**: Nombramos los proveedores necesarios (azurerm)
- **vars.tf**: Aquí pondremos las variables que usaremos como referencia en resources.tf. Por poner un ejemplo basico, el nombre y la localizacion de nuestro Azure Resource Group
- **resources.tf**: Aunque lo adecuado sería tener varios ficheros de recursos (que estoy considerando) para tener todo mas ordenado (por recursos de red, recursos de maquinas virtuales, etc), vamos a utilzar uno unico donde ponemos los recursos que generamos en Azure.
    - Generamos el resource_group, donde se guardaran el resto de recursos
    - Generamos la maquina virtual que utilizaremos con sus caracteristicas de disco, qué linux lleva, cómo accederemos por ssh a él)
    - Generamos el agreement con el marketplace para que no lo tengamos que aceptar nosotros manualmente
    - Generamos el Azure Container Registry para almacenar los contenedores que generamos y utilizamos mas tarde
    - Generamos la interfaz de red, con su subnet
    - Generamos el recurso de ip publica
    - Generamos el grupo de seguridad de red para crear las reglas asociadas para el acceso ssh y web. Como tenemos una ip publica fija, la incluiremos aqui.
    - Generaremos la asociacion entre el grupo de seguridad de red y el recurso de red para que las reglas nombradas arriba se apliquen a la tarjeta.
