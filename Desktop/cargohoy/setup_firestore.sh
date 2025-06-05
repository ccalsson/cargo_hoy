#!/bin/bash

# Variables
PROJECT_ID="tu-project-id" # Reemplaza con tu ID de proyecto de Firebase
FIRESTORE_PATH="projects/$PROJECT_ID/databases/(default)/documents"

# Función para crear un documento en Firestore
create_document() {
  local collection=$1
  local document=$2
  local fields=$3

  echo "Creando documento $document en la colección $collection..."
  firebase firestore:document "$FIRESTORE_PATH/$collection/$document" --data "$fields"
}

# Crear colecciones y documentos iniciales

# Colección: users
create_document "users" "user_1" '{
  "nombre": "John",
  "apellido": "Doe",
  "email": "john.doe@example.com",
  "telefono": "123456789",
  "tipo": "conductor",
  "documentos": [],
  "calificacion": 4.5,
  "fechaRegistro": "2023-10-01T00:00:00Z",
  "ultimoAcceso": "2023-10-01T00:00:00Z"
}'

# Colección: cargas
create_document "cargas" "carga_1" '{
  "tipoCarga": "Paquete",
  "peso": 100.5,
  "dimensiones": "10x10x10",
  "origen": "Ciudad A",
  "destino": "Ciudad B",
  "fechaEntrega": "2023-10-10T00:00:00Z",
  "estado": "pendiente",
  "empresaId": "empresa_1",
  "conductorId": "user_1",
  "imagenes": [],
  "documentos": []
}'

# Colección: pagos
create_document "pagos" "pago_1" '{
  "usuarioId": "user_1",
  "stripePaymentId": "pi_123456789",
  "monto": 100.0,
  "moneda": "USD",
  "fecha": "2023-10-01T00:00:00Z",
  "estado": "completado",
  "metodoPago": "tarjeta",
  "descripcion": "Pago por servicio de carga"
}'

# Colección: suscripciones
create_document "suscripciones" "suscripcion_1" '{
  "usuarioId": "user_1",
  "stripeSubscriptionId": "sub_123456789",
  "plan": "básica",
  "fechaInicio": "2023-10-01T00:00:00Z",
  "fechaFin": "2024-10-01T00:00:00Z",
  "estado": "activa"
}'

# Colección: servicios
create_document "servicios" "servicio_1" '{
  "tipo": "combustible",
  "ubicacion": "Estación de Servicio A",
  "descuentos": ["10%", "20%"],
  "reseñas": [
    {
      "usuarioId": "user_1",
      "comentario": "Excelente servicio",
      "calificacion": 5.0
    }
  ]
}'

# Colección: notificaciones
create_document "notificaciones" "notificacion_1" '{
  "usuarioId": "user_1",
  "mensaje": "Tu carga ha sido asignada",
  "fecha": "2023-10-01T00:00:00Z",
  "estado": "enviada"
}'

# Colección: flotas
create_document "flotas" "flota_1" '{
  "dueñoId": "user_1",
  "camiones": ["camion_1"],
  "membresia": "básica",
  "fechaRegistro": "2023-10-01T00:00:00Z"
}'

# Colección: camiones
create_document "camiones" "camion_1" '{
  "flotaId": "flota_1",
  "matricula": "ABC123",
  "marca": "Volvo",
  "modelo": "FH16",
  "capacidad": 20.0,
  "fechaAdquisicion": "2023-10-01T00:00:00Z"
}'

# Colección: reportes
create_document "reportes" "reporte_1" '{
  "tipo": "desempeño",
  "datos": {
    "eficiencia": 95.0,
    "costos": 500.0,
    "tiempoPromedio": 2.5
  },
  "fechaGeneracion": "2023-10-01T00:00:00Z"
}'

# Colección: gamificacion
create_document "gamificacion" "gamificacion_1" '{
  "usuarioId": "user_1",
  "puntos": 100,
  "recompensas": ["Descuento en combustible"],
  "logros": ["Primer viaje completado"]
}'

echo "¡Estructura de Firestore creada exitosamente!"