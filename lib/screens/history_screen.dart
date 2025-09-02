import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../utils/customIIconButton.dart';
import '../utils/fostedGlassContainer.dart';

import '../blocs/soil_reading/soil_reading_bloc.dart';
import '../blocs/soil_reading/soil_reading_event.dart';
import '../blocs/soil_reading/soil_reading_state.dart';
import '../models/soil_reading.dart';
import '../services/pdf_services.dart';

enum ChartType { line, bar }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ChartType _chartType = ChartType.line;
  final PdfService _pdfService = PdfService();

  void _toggleChartType() {
    setState(() {
      _chartType = _chartType == ChartType.line ? ChartType.bar : ChartType.line;
    });
  }

  Future<void> _generatePdf(List<SoilReading> readings) async {
    final pdfData = await _pdfService.generateSoilReadingsPdf(readings);
    await Printing.sharePdf(bytes: pdfData, filename: 'soil_report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final soilReadingBloc = context.read<SoilReadingBloc>();

    // --- scale values (responsive) ---
    double h(double px) => (px / 812) * screenHeight; // base iPhone X height
    double w(double px) => (px / 375) * screenWidth; // base iPhone X width

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.secondary.withOpacity(0.5),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
              duration: 3500.ms,
              color: theme.colorScheme.primary.withOpacity(0.2)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h(40)), // scaled top spacing
                  _buildHeader(context),
                  SizedBox(height: h(20)),
                  Expanded(
                    child: BlocBuilder<SoilReadingBloc, SoilReadingState>(
                      builder: (context, state) {
                        if (state is SoilReadingLoaded) {
                          if (state.readings.isEmpty) {
                            return const Center(
                                child: Text('No readings found.'));
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: h(220), // scaled height
                                child: FrostedGlass(
                                  width: double.infinity,
                                  height: h(220),
                                  child: _buildChart(state.readings),
                                ).animate().fadeIn(duration: 500.ms),
                              ),
                              SizedBox(height: h(20)),
                              Expanded(
                                child:
                                _buildReadingsList(soilReadingBloc, state),
                              ),
                            ],
                          );
                        }
                        if (state is SoilReadingError) {
                          return Center(
                              child: Text('Error: ${state.message}'));
                        }
                        return const Center(
                            child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading History',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'View trends and past data.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        BlocBuilder<SoilReadingBloc, SoilReadingState>(
          builder: (context, state) {
            return Row(
              children: [
                CustomIconButton(
                  icon: _chartType == ChartType.line
                      ? Iconsax.chart_2
                      : Iconsax.chart_1,
                  onPressed: _toggleChartType,
                  tooltip: 'Toggle Chart Type',
                ),
                if (state is SoilReadingLoaded &&
                    state.readings.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  CustomIconButton(
                    icon: Iconsax.document_download,
                    onPressed: () => _generatePdf(state.readings),
                    tooltip: 'Export as PDF',
                  ),
                ],
              ],
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildReadingsList(SoilReadingBloc bloc, SoilReadingLoaded state) {
    final readings = state.readings;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: readings.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= readings.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () => bloc.add(LoadMoreReadings()),
                child: const Text('Load More'),
              ),
            ),
          );
        }
        final reading = readings[index];
        return _buildHistoryCard(context, reading)
            .animate()
            .fadeIn(delay: (100 * (index % 10)).ms, duration: 400.ms)
            .slideY(begin: 0.2, curve: Curves.easeOut);
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, SoilReading reading) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Iconsax.timer_1, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temp: ${reading.temperature.toStringAsFixed(1)}°C | Moisture: ${reading.moisture.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd()
                        .add_jm()
                        .format(reading.timestamp.toLocal()),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<SoilReading> readings) {
    if (readings.isEmpty) {
      return const Center(child: Text('No data for charts'));
    }

    final chronologicalReadings = readings.reversed.toList();
    final spotsTemp = <FlSpot>[];
    final spotsMoisture = <FlSpot>[];

    for (int i = 0; i < chronologicalReadings.length; i++) {
      spotsTemp
          .add(FlSpot(i.toDouble(), chronologicalReadings[i].temperature));
      spotsMoisture
          .add(FlSpot(i.toDouble(), chronologicalReadings[i].moisture));
    }

    final tempColor = Colors.amber.shade400;
    final moistureColor = Colors.cyan.shade300;

    if (_chartType == ChartType.line) {
      return LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _getLineChartBarData(spotsTemp, tempColor),
            _getLineChartBarData(spotsMoisture, moistureColor),
          ],
        ),
      );
    } else {
      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(chronologicalReadings.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    toY: chronologicalReadings[index].temperature,
                    color: tempColor,
                    width: 5,
                    borderRadius: BorderRadius.circular(4)),
                BarChartRodData(
                    toY: chronologicalReadings[index].moisture,
                    color: moistureColor,
                    width: 5,
                    borderRadius: BorderRadius.circular(4)),
              ],
            );
          }),
        ),
      );
    }
  }

  LineChartBarData _getLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2),
      ),
    );
  }
}
