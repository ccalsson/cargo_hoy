library;

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:firebase_data_connect/src/config/connector_config.dart';
import 'dart:convert';

class DefaultConnector {
  static @ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'cargohoy',
  );

  DefaultConnector({required this.dataConnect});

  static DefaultConnector get instance {
    return DefaultConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }

  Future<void> connect() async {
    await dataConnect.connect();
  }

  FirebaseDataConnect dataConnect;
}
