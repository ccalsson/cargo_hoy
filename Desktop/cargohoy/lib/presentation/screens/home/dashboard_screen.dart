import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../widgets/weather_widget.dart';
import '../../widgets/currency_widget.dart';
import '../../widgets/news_widget.dart';
import '../../widgets/interactive_map.dart';
import '../../widgets/load_search.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      body: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        children: [
          // Panel lateral (solo desktop)
          if (isTablet)
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: _buildSidePanel(),
            ),

          // Panel principal
          ResponsiveRowColumnItem(
            rowFlex: 5,
            child: _buildMainPanel(context),
          ),

          // Panel de rastreo (solo desktop)
          if (isTablet)
            ResponsiveRowColumnItem(
              rowFlex: 3,
              child: _buildTrackingPanel(),
            ),
        ],
      ),
    );
  }

  Widget _buildMainPanel(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda y filtros
        _buildSearchBar(),

        // Mapa interactivo
        Expanded(
          flex: 3,
          child: InteractiveMap(
            onLocationSelected: (location) {
              // Manejar selección de ubicación
            },
          ),
        ),

        // Widgets informativos
        if (ResponsiveBreakpoints.of(context).smallerThan(DESKTOP))
          _buildInfoWidgetsMobile()
        else
          _buildInfoWidgetsDesktop(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return LoadSearchWidget(
      onSearch: (criteria) {
        // Implementar búsqueda
      },
      filters: const [
        FilterOption(
          label: 'Tipo de Carga',
          options: ['Contenedor', 'Granel', 'Refrigerado'],
        ),
        FilterOption(
          label: 'Distancia',
          options: ['Local', 'Nacional', 'Internacional'],
        ),
        // Más filtros...
      ],
    );
  }

  Widget _buildInfoWidgetsMobile() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          WeatherWidget(compact: true),
          CurrencyWidget(compact: true),
          NewsWidget(compact: true),
        ],
      ),
    );
  }

  Widget _buildInfoWidgetsDesktop() {
    return const Row(
      children: [
        Expanded(child: WeatherWidget()),
        Expanded(child: CurrencyWidget()),
        Expanded(child: NewsWidget()),
      ],
    );
  }

  Widget _buildSidePanel() {
    return Card(
      child: Column(
        children: [
          _buildFleetStatus(),
          _buildTripHistory(),
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildFleetStatus() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estado de la Flota',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Implementar estado de la flota
        ],
      ),
    );
  }

  Widget _buildTripHistory() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Historial de Viajes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Implementar historial de viajes
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Implementar estadísticas
        ],
      ),
    );
  }

  Widget _buildTrackingPanel() {
    return Card(
      child: Column(
        children: [
          const Text('Rastreo en Tiempo Real',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: 0, // Implementar lista de vehículos
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Vehículo'),
                  subtitle: Text('Estado'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
