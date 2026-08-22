# MiAsistente Care - UVM

Prototipo académico desarrollado para el Proyecto Integrador de la asignatura **Soluciones de Programación Móvil**.

## Objetivo

MiAsistente Care centraliza consultas y solicitudes de soporte postventa para usuarios de dispositivos Android e HyperOS.

## Tecnologías

- Flutter y Dart
- Android Studio
- Firebase Authentication
- Cloud Firestore

## Operaciones CRUD

- **Create:** registrar una solicitud.
- **Read:** mostrar las solicitudes registradas.
- **Update:** cambiar el estado a “Atendida”.
- **Delete:** eliminar una solicitud.

`lib/main.dart` contiene un prototipo ejecutable con CRUD local. El archivo `lib/services/firestore_support_service.dart` contiene las operaciones equivalentes preparadas para Cloud Firestore.

## Configuración de Firebase

Por seguridad, el repositorio no publica credenciales privadas. Para conectarlo con Firebase:

1. Instalar Firebase CLI y FlutterFire CLI.
2. Ejecutar `flutterfire configure`.
3. Inicializar Firebase con el archivo generado `firebase_options.dart`.
4. Configurar las reglas de acceso de Firestore.
5. Ejecutar `flutter pub get` y después `flutter run`.

## Autor

Sajhid Manuel Silva Facio  
Universidad del Valle de México  
Agosto de 2026

