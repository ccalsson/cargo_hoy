# CargoHoy - Sistema de Reservas de Viajes

CargoHoy es una plataforma logística integral que permite a los conductores planificar viajes futuros, asignarse cargas disponibles y organizar sus rutas de manera eficiente.

## Características Principales

- Sistema de reservas anticipadas con prioridades
- Matching en tiempo real para viajes sin reservas
- Sistema de membresías con diferentes niveles de acceso
- Gestión de penalizaciones por cancelaciones
- Notificaciones en tiempo real
- Soporte multiplataforma (Web, Android, iOS, Desktop)

## Estructura del Proyecto

```
lib/
├── core/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── settings_provider.dart
│   │   └── theme_provider.dart
│   └── theme/
│       └── app_theme.dart
├── features/
│   ├── auth/
│   │   └── domain/
│   │       └── models/
│   │           └── user_model.dart
│   └── trips/
│       ├── data/
│       │   └── services/
│       │       ├── matching_service.dart
│       │       └── reservation_service.dart
│       └── domain/
│           └── models/
│               ├── reservation.dart
│               └── trip.dart
└── main.dart
```

## Configuración del Proyecto

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/cargohoy.git
cd cargohoy
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Configurar Firebase:
- Crear un proyecto en Firebase Console
- Agregar las aplicaciones necesarias (Web, Android, iOS)
- Descargar y configurar los archivos de configuración
- Actualizar `lib/firebase_options.dart` con tus credenciales

4. Configurar Cloud Functions:
```bash
cd functions
npm install
```

## Despliegue

### Aplicación Flutter
```bash
flutter build web  # Para web
flutter build apk  # Para Android
flutter build ios  # Para iOS
```

### Cloud Functions
```bash
cd functions
npm run deploy
```

## Sistema de Membresías

| Membresía     | Ver viajes | Reservar anticipadamente | Matching en vivo | Reservas permitidas | Posición de reserva | Tokens mensuales |
|---------------|------------|---------------------------|------------------|---------------------|---------------------|------------------|
| Básica ($10)  | Sí         | ❌ No                     | ✅ Sí            | 0                   | N/A                 | 0                |
| Pro ($30)     | Sí         | ✅ Sí                     | ✅ Sí            | 2                   | 1° o 2° lugar       | 5                |
| Premium ($50) | Sí         | ✅ Sí                     | ✅ Sí            | Ilimitadas          | 1° o 2° lugar       | Ilimitado        |

## Penalizaciones por Cancelación

- Cancelación > 24 horas antes: ✅ sin penalización
- Cancelación entre 24 y 12 h antes: ⚠️ penalización leve (consumo de token + prioridad baja por 3 días)
- Cancelación < 12 h antes: ❌ penalización fuerte (bloqueo de reservas por 48h)

## Contribuir

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
