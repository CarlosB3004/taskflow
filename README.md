# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Alcance de TaskFlow

Problema: necesito organizar mis actividades académicas para saber cuáles tengo pendientes y cuáles he completado.

Usuario objetivo: estudiantes universitarios que necesitan organizar sus tareas y entregas semanales.

### Historias de usuario y criterios de aceptación

1. Como estudiante, quiero ver mis tareas académicas para organizar mis actividades.
   Criterio: la lista muestra el título, la prioridad y el estado de cada tarea.

2. Como estudiante, quiero consultar los detalles de una tarea para conocer la actividad que debo realizar.
   Criterio: al seleccionar una tarea, aparece su descripción, prioridad, estado y usuario.

3. Como estudiante, quiero crear nuevas tareas para registrar mis actividades pendientes.
   Criterio: el formulario permite guardar una tarea válida y mostrarla en el listado.

4. Como estudiante, quiero editar una tarea para actualizar su información.
   Criterio: los cambios guardados aparecen correctamente en el listado y el detalle.

5. Como estudiante, quiero eliminar tareas que ya no necesito para mantener organizada mi lista.
   Criterio: después de confirmar la eliminación, la tarea desaparece del listado.

### Modelo de datos

Task:
- id: identificador único de la tarea (int).
- title: título de la tarea (String).
- description: descripción de la actividad (String).
- priority: prioridad Alta, Media o Baja (String).
- isCompleted: indica si está completada (bool).
- userId: identificador del usuario propietario (int).

### Pantallas previstas

Lista: muestra las tareas académicas y permitirá crear nuevas actividades.

Detalle: muestra la información completa de una tarea y permitirá editarla o eliminarla.

Formulario: permitirá ingresar el título, la descripción y la prioridad de una tarea.

### Requisitos no funcionales

- La navegación debe mostrar textos claros y comprensibles.
- Si se consulta un identificador inexistente, la aplicación debe mostrar un mensaje en lugar de cerrarse.

### Contrato de API que necesitaremos

GET /tasks        listar tareas
GET /tasks/:id    consultar el detalle de una tarea
POST /tasks       crear una tarea
PATCH /tasks/:id  actualizar una tarea
DELETE /tasks/:id eliminar una tarea

La API concreta se elegirá posteriormente. Estas rutas representan las operaciones previstas y todavía no corresponden a un servidor conectado.

## API de tareas

Para el Codelab 07 conecté TaskFlow con JSONPlaceholder, una API REST pública que proporciona datos de prueba. Utilicé Dio para realizar las peticiones HTTP y obtener las tareas que se muestran en la aplicación.

### URL y consulta utilizada

- URL base: https://jsonplaceholder.typicode.com
- Endpoint: `/todos`
- Método HTTP: `GET`
- Parámetro de consulta: `userId=2`
- URL completa: https://jsonplaceholder.typicode.com/todos?userId=2

Primero trabajé con el usuario 1 para comprobar la conexión. Después cambié el valor de `userId` a 2 y verifiqué que la aplicación mostrara tareas diferentes.

### Datos recibidos de la API

La respuesta JSON contiene cuatro campos:

- `userId`: identificador del usuario.
- `id`: identificador de la tarea.
- `title`: título de la tarea.
- `completed`: indica si la tarea está completada.

### Valores predeterminados

Mi modelo `Task` tiene seis propiedades, pero la API solo proporciona cuatro campos. Por eso, TaskFlow completa los datos faltantes con estos valores:

- `description`: Sin descripción (API).
- `priority`: Sin prioridad (API).

Además, el campo `completed` de la API se convierte en `isCompleted` dentro del modelo de TaskFlow.

### Arquitectura utilizada

La aplicación mantiene la arquitectura MVVM con Provider.

El servicio `TaskApiService` realiza la consulta HTTP mediante Dio. El repositorio `RemoteTaskRepository` obtiene las tareas del servicio. El modelo `Task` convierte los datos JSON y el `TasksViewModel` notifica a la interfaz cuando termina la carga.

También conservé `LocalTaskRepository` con las cinco tareas académicas de la sesión anterior como respaldo.

### Actualización del estado de las tareas

Actualmente puedo marcar una tarea como completada o pendiente desde su pantalla de detalle.

Sin embargo, este cambio se realiza únicamente en memoria. JSONPlaceholder se utiliza como API de práctica y TaskFlow todavía no guarda estos cambios permanentemente en el servidor.

Al reiniciar la aplicación, las tareas recuperan el estado que devuelve la API.


## Sesión 8 - Estados de la lista remota

En esta sesión mejoré la aplicación TaskFlow para mostrar
los diferentes estados de una consulta a la API REST,
manteniendo la arquitectura MVVM.

### Estados de la aplicación

- **Carga:** utilicé la opción 3G de las herramientas de
  desarrollador de Chrome para reducir la velocidad de
  conexión y observar el indicador de carga. Durante este
  proceso, el botón de actualización permanece deshabilitado.

- **Éxito:** con una conexión a internet y el userId = 2,
  la aplicación muestra las tareas obtenidas desde la API.
  También comprobé que se puede acceder al detalle de una
  tarea desde el listado.

- **Vacío:** cambié temporalmente el userId a 9999 en
  TaskApiService. La API devolvió una lista vacía y la
  aplicación mostró un mensaje con una opción para
  actualizar las tareas.

- **Error:** utilicé la opción Offline de Chrome DevTools
  y presioné el botón de actualización. La aplicación
  mostró un mensaje de error y el botón Reintentar.

### Prueba de reintento

Restablecí la conexión seleccionando No throttling y
presioné el botón Reintentar. La aplicación recuperó el
listado de tareas sin necesidad de reiniciarse.

### Personalización

Personalicé los mensajes de error y lista vacía, así como
los textos de las acciones de actualización, conservando
el funcionamiento del listado remoto y la navegación
al detalle.

### Configuración final

- API: JSONPlaceholder.
- Endpoint: https://jsonplaceholder.typicode.com/todos?userId=2
- Usuario: 2.
- Arquitectura: MVVM con Provider.
- Cliente HTTP: Dio.

Después de realizar las pruebas, restauré el userId a 2.
Los cambios de estado de las tareas siguen siendo locales
y pueden perderse al consultar nuevamente la API.
