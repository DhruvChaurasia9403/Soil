import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../blocs/soil_reading/soil_reading_bloc.dart';
import '../blocs/soil_reading/soil_reading_event.dart';
import '../blocs/soil_reading/soil_reading_state.dart';
import '../models/soil_reading.dart';
import '../utils/fostedGlassContainer.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToHistory;

  const HomeScreen({super.key, required this.onNavigateToHistory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // scale factor based on screen width (keeps layout identical but responsive)
    final scale = screenWidth / 390.0; // 390 is a common base width

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Animated Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.6),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
              duration: 3000.ms,
              color: theme.colorScheme.secondary.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'Dashboard',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideX(),
                  Text(
                    'Latest soil condition overview.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms)
                      .slideX(),
                  SizedBox(height: 40 * scale),
                  BlocBuilder<SoilReadingBloc, SoilReadingState>(
                    builder: (context, state) {
                      if (state is SoilReadingLoading) {
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is SoilReadingLoaded &&
                          state.readings.isNotEmpty) {
                        return _buildLatestReading(
                            context, state.readings.first, scale);
                      }
                      if (state is SoilReadingError) {
                        return Expanded(
                          child: Center(child: Text('Error: ${state.message}')),
                        );
                      }
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No readings available.\nTap "Fetch New" to start.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildActionButtons(context, scale),
                  SizedBox(height: 20 * scale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestReading(
      BuildContext context, SoilReading reading, double scale) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Center(
        child: FrostedGlass(
          width: screenWidth - (48 * scale),
          height: 350 * scale,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDataRow(
                context,
                icon: Iconsax.sun_1,
                color: Colors.amber,
                label: 'Temperature',
                value: '${reading.temperature.toStringAsFixed(1)} °C',
                scale: scale,
              ),
              Divider(color: Colors.white.withOpacity(0.2)),
              _buildDataRow(
                context,
                icon: Iconsax.drop,
                color: Colors.lightBlueAccent,
                label: 'Moisture',
                value: '${reading.moisture.toStringAsFixed(1)} %',
                scale: scale,
              ),
              Divider(color: Colors.white.withOpacity(0.2)),
              Text(
                'Last updated: ${DateFormat.yMMMd().add_jms().format(reading.timestamp.toLocal())}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildDataRow(BuildContext context,
      {required IconData icon,
        required Color color,
        required String label,
        required String value,
        required double scale}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 40 * scale),
        SizedBox(width: 16 * scale),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize:
                (theme.textTheme.titleMedium?.fontSize ?? 16) * scale,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize:
                (theme.textTheme.headlineMedium?.fontSize ?? 20) * scale,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, double scale) {
    final soilBloc = context.read<SoilReadingBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () => soilBloc.add(FetchNewReading()),
          icon: Icon(Iconsax.refresh, size: 20 * scale),
          label: Text(
            'Fetch New',
            style: TextStyle(fontSize: 14 * scale),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scale,
              vertical: 16 * scale,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onNavigateToHistory,
          icon: Icon(Iconsax.document_text, size: 20 * scale),
          label: Text(
            'View History',
            style: TextStyle(fontSize: 14 * scale),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scale,
              vertical: 16 * scale,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5);
  }
}
