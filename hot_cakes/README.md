# HotCakes

**Ejemplo del Modelo de Actores (Sin supervisores).**

Este proyecto muestra cómo implementar el modelo de actores en Elixir sin usar OTP, supervisores o GenServers. En su lugar, se usan primitivas básicas como `spawn` y `receive` para crear procesos que se comunican entre sí mediante mensajes.


## ¿Por qué usar este enfoque?

Este ejemplo demuestra los conceptos fundamentales del modelo de actores:
1. **Procesos ligeros**: Cada actor es un proceso independiente.
2. **Comunicación por mensajes**: Los procesos interactúan enviándose mensajes.
3. **Estado interno**: Aunque este ejemplo no usa estado mutable, se podría ampliarlo para mantener información en cada actor. :D

## Limitaciones

- Sin supervisores, no hay mecanismos automáticos para reiniciar procesos fallidos.
- Este ejemplo es educativo; en aplicaciones reales, se recomienda usar OTP y GenServers para mayor robustez.


## Ejecutar el programa

```elixir
  > iex -S mix

  > HotCakes.start()
```