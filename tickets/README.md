# Tickets

Este proyecto demuestra cómo utilizar Broadway con RabbitMQ para crear una data ingestion pipeline que maneja la disponibilidad de boletos

Tecnologías

  - Elixir: Lenguaje funcional para crear aplicaciones concurrentes y distribuidas.
  - Broadway: Biblioteca para procesamiento paralelo y asincrónico de mensajes.
  - RabbitMQ: Sistema de mensajería que facilita la comunicación entre diferentes partes de la aplicación.
  - Ecto (opcional): Para realizar consultas a la base de datos y manejar la persistencia de datos (en caso de integrar un sistema de base de datos).

## Requisitos:

**Rabbitmq:**

Puedes instalarlo utilizando una imagen de docker

```shell
  docker run -d --name rabbitmq \
    -p 5672:5672 \
    -p 15672:15672 \
    rabbitmq:management
```

Después de ejecutar el comando, pudes acceder al panel de administración de RabbitMQ:

`http://localhost:15672`

  Usuario por defecto: **guest**
  Contraseña por defecto: **guest**

## Instalación

1. Clona este repositorio:

```shell  
  git clone 
  cd tickets
```
 
2. Instala las dependencias

```shell  
  mix deps.get
```

3. Inicia la aplicación 

```shell  
  iex -S mix
```

4. Puedes enviar mensajes a rabbitmq a traves de ejecutar la función `send_messages`, el cual recibe como argumento el número de mensajes que queremos enviar, esto nos ayuda el tener que estar enviando mensaje por mensaje en el panel de administracion de RabbitMQ.

```shell  
  send_messages.(2)
```


## Contribuciones

¡Las contribuciones son bienvenidas! :D Si tienes alguna mejora o corrección, no dudes en enviar un pull request.