#!/bin/bash

# Crear estructura de carpetas y archivos
mkdir -p lib/core/{constants,utils,network,theme}
mkdir -p lib/data/{models,repositories,datasources}
mkdir -p lib/domain/{entities,usecases}
mkdir -p lib/presentation/{screens/{auth,home,profile,payments,services,notifications},widgets,providers,routes}
mkdir -p assets/{images/icons,fonts/roboto}
mkdir -p test/{unit,widget,integration}

# Crear archivos principales
touch lib/main.dart
touch lib/core/constants/{app_colors.dart,app_strings.dart,app_styles.dart}
touch lib/core/utils/{validators.dart,helpers.dart,navigation.dart}
touch lib/core/network/{api_client.dart,api_endpoints.dart,api_interceptor.dart}
touch lib/core/theme/{app_theme.dart,text_styles.dart}

# Crear modelos
touch lib/data/models/{user_model.dart,carga_model.dart,reserva_model.dart,flota_model.dart,servicio_model.dart,pago_model.dart,suscripcion_model.dart}

# Crear repositorios
touch lib/data/repositories/{user_repository.dart,carga_repository.dart,reserva_repository.dart,flota_repository.dart,servicio_repository.dart,pago_repository.dart,suscripcion_repository.dart}

# Crear datasources
touch lib/data/datasources/{local_datasource.dart,remote_datasource.dart}

# Crear entidades
touch lib/domain/entities/{user_entity.dart,carga_entity.dart,reserva_entity.dart,flota_entity.dart,servicio_entity.dart,pago_entity.dart,suscripcion_entity.dart}

# Crear casos de uso
touch lib/domain/usecases/{user_usecases.dart,carga_usecases.dart,reserva_usecases.dart,flota_usecases.dart,servicio_usecases.dart,pago_usecases.dart,suscripcion_usecases.dart}

# Crear pantallas
touch lib/presentation/screens/auth/{login_screen.dart,register_screen.dart,verify_screen.dart}
touch lib/presentation/screens/home/{home_screen.dart,carga_list_screen.dart,carga_detail_screen.dart,carga_create_screen.dart}
touch lib/presentation/screens/profile/{profile_screen.dart,edit_profile_screen.dart,document_upload_screen.dart}
touch lib/presentation/screens/payments/{payment_screen.dart,payment_history_screen.dart,subscription_screen.dart}
touch lib/presentation/screens/services/{service_list_screen.dart,service_detail_screen.dart,service_reserve_screen.dart}
touch lib/presentation/screens/notifications/{notification_list_screen.dart,notification_detail_screen.dart}

# Crear widgets
touch lib/presentation/widgets/{app_bar.dart,bottom_nav_bar.dart,carga_card.dart,service_card.dart,payment_card.dart,notification_card.dart}

# Crear proveedores
touch lib/presentation/providers/{auth_provider.dart,carga_provider.dart,reserva_provider.dart,flota_provider.dart,servicio_provider.dart,pago_provider.dart,suscripcion_provider.dart}

# Crear rutas
touch lib/presentation/routes/{app_routes.dart,route_generator.dart}

# Crear assets
touch assets/images/{logo.png,background.png}
touch assets/images/icons/{home_icon.png,profile_icon.png,payment_icon.png}
touch assets/fonts/roboto/{roboto_regular.ttf,roboto_bold.ttf,roboto_italic.ttf}

# Crear pruebas
touch test/unit/{user_repository_test.dart,carga_repository_test.dart,pago_repository_test.dart}
touch test/widget/{carga_card_test.dart,service_card_test.dart}
touch test/integration/app_test.dart

# Mensaje de finalización
echo "Estructura de archivos y carpetas creada exitosamente."