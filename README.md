# Godot Fundamentals – Proyecto Shooter 2D

## Descripción del Proyecto

Este proyecto consiste en el desarrollo de un **videojuego 2D tipo shooter** utilizando el motor de videojuegos **Godot Engine** y el lenguaje **GDScript**.

El objetivo principal del juego es permitir que el jugador dispare proyectiles hacia enemigos que aparecen de manera aleatoria en el mapa. Cuando un proyectil impacta un enemigo, este es destruido.

El proyecto implementa varios conceptos fundamentales del desarrollo de videojuegos como:

* Arquitectura basada en nodos
* Sistema de escenas
* Instanciación dinámica de objetos
* Sistema de físicas 2D
* Sistema de señales
* Animaciones mediante Tween
* Manejo de eventos de entrada

Este proyecto sirve como una introducción práctica a los **fundamentos del desarrollo de videojuegos en Godot**.



# Arquitectura del Proyecto

El juego está construido utilizando el **sistema de nodos y escenas de Godot**, donde cada entidad del juego es una escena independiente.

## Estructura principal

```
project
│
├── level.tscn
├── player.tscn
├── enemy.tscn
├── bullet.tscn
│
├── scripts
│   ├── level.gd
│   ├── player.gd
│   ├── enemy.gd
│   └── bullet.gd
```

Cada escena contiene:

* nodos visuales
* nodos de colisión
* scripts que controlan su comportamiento

---

# Sistema de Nodos en Godot

Godot utiliza una **arquitectura basada en nodos**, donde cada objeto del juego está compuesto por múltiples nodos organizados jerárquicamente.

Ejemplo de estructura del jugador:

```
Player (Node2D)
│
├── Sprite2D
├── CollisionShape2D
└── AudioStreamPlayer2D
```

### Nodos utilizados en el proyecto

| Nodo                | Función                               |
| ------------------- | ------------------------------------- |
| Node2D              | Nodo base para objetos 2D             |
| Sprite2D            | Renderiza imágenes                    |
| CollisionShape2D    | Define colisiones                     |
| RigidBody2D         | Cuerpo físico controlado por el motor |
| Area2D              | Detecta interacciones entre cuerpos   |
| Timer               | Ejecuta eventos periódicos            |
| AudioStreamPlayer2D | Reproduce sonido                      |

---

# Funcionamiento del Jugador

El jugador se controla mediante el **mouse**.

## Rotación hacia el cursor

El jugador siempre rota hacia la posición del cursor utilizando:

```gdscript
look_at(get_global_mouse_position())
```

Esto permite que el jugador **apunte dinámicamente hacia cualquier dirección**.

---

## Sistema de Disparo

Cuando el usuario hace clic, el sistema detecta el evento mediante:

```gdscript
func _input(event)
```

Si el evento es un clic del mouse:

```gdscript
if event is InputEventMouseButton
```

Entonces se instancia una nueva bala.

### Instanciación dinámica

```gdscript
var bullet = bullet_scene.instantiate()
add_child(bullet)
```

La bala se posiciona en el jugador:

```gdscript
bullet.global_transform = global_transform
```

---

## Aplicación de Física

La bala utiliza el nodo:

```
RigidBody2D
```

El movimiento se genera aplicando un impulso:

```gdscript
bullet.apply_central_impulse(global_transform.x * 1000)
```

Esto utiliza el **motor de físicas de Godot** para simular el disparo.

---

## Animación de Retroceso

Para mejorar la experiencia visual, el disparo genera una animación de retroceso utilizando **Tween**.

```gdscript
var tween = create_tween()

tween.tween_property(
    polygon,
    "position",
    Vector2.ZERO,
    0.2
).from(Vector2(35,0))
```

Tween permite interpolar valores suavemente para crear animaciones.

---

# Sistema de Enemigos

Los enemigos se generan dinámicamente en el nivel mediante un **Timer**.

Cuando el timer finaliza se ejecuta:

```gdscript
func _on_timer_timeout()
```

Se crea un enemigo mediante instanciación:

```gdscript
var enemy = enemy_scene.instantiate()
add_child(enemy)
```

---

## Generación de posición aleatoria

Los enemigos aparecen en posiciones aleatorias del mapa:

```gdscript
var position = Vector2(
    randf_range(-600,600),
    randf_range(-350,350)
)
```

---

## Prevención de aparición cerca del jugador

Para evitar que los enemigos aparezcan demasiado cerca del jugador se usa:

```gdscript
while position.distance_to(Vector2(0,0)) < 150
```

Esto asegura una **distancia mínima segura de spawn**.

---

# Sistema de Colisiones

Los enemigos utilizan el nodo:

```
Area2D
```

Cuando un cuerpo entra en el área se activa la señal:

```
body_entered
```

Esto ejecuta:

```gdscript
func _on_body_entered(body)
```

Si el objeto que colisiona es una bala:

```gdscript
if body is RigidBody2D
```

Entonces:

1. Se destruye la bala

```gdscript
body.queue_free()
```

2. Se ejecuta la muerte del enemigo

```gdscript
die()
```

---

# Sistema de Destrucción del Enemigo

La función `die()` controla la eliminación del enemigo.

Primero cambia el color:

```gdscript
sprite.modulate = Color.WHITE
```

Luego se introduce un pequeño delay:

```gdscript
await get_tree().create_timer(destroy_delay).timeout
```

Finalmente se elimina del árbol de escena:

```gdscript
queue_free()
```

Esto libera memoria y elimina el objeto del juego.

---

# Variación Visual de Enemigos

Para evitar que todos los enemigos se vean iguales, se genera un color aleatorio usando el modelo **HSV**.

```gdscript
var new_color = Color.from_hsv(randf(), 0.5, 1.0)
polygon.modulate = new_color
```

Esto genera enemigos con distintos colores.

---

# Sistema de Eventos

El juego funciona mediante **programación orientada a eventos**.

Ejemplos:

| Evento          | Acción                       |
| --------------- | ---------------------------- |
| `_input()`      | detectar clic del mouse      |
| `_process()`    | actualizar lógica cada frame |
| `body_entered`  | detectar colisión            |
| `timer_timeout` | generar enemigos             |

---

# Tecnologías Utilizadas

| Tecnología   | Descripción                      |
| ------------ | -------------------------------- |
| Godot Engine | Motor de videojuegos open source |
| GDScript     | Lenguaje de scripting de Godot   |
| Física 2D    | Sistema físico integrado         |
| Tween        | Sistema de animación interpolada |

---

# Conceptos de Desarrollo de Videojuegos Aplicados

Este proyecto implementa múltiples conceptos importantes:

### Arquitectura basada en componentes

Cada entidad del juego está compuesta por nodos especializados.

### Instanciación dinámica

Los objetos se crean durante la ejecución del juego.

### Motor de físicas

Las balas utilizan simulación física real.

### Programación orientada a eventos

El juego responde a eventos como entradas, colisiones y timers.

### Gestión de memoria

Los objetos se eliminan mediante `queue_free()` cuando dejan de ser necesarios.

---

# Conclusión

Este proyecto demuestra los fundamentos del desarrollo de videojuegos en **Godot**, incluyendo la interacción entre nodos, el uso del motor de físicas, la generación dinámica de objetos y la gestión de eventos.

El uso de **GDScript** permite implementar de manera sencilla la lógica del juego mientras se aprovecha la arquitectura modular del motor.

---
