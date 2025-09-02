import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:printing/printing.dart';
import 'package:readsoil/screens/bluetooth_scan_screen.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/setting/setting_bloc.dart';
import '../blocs/soil_reading/soil_reading_bloc.dart';
import '../blocs/soil_reading/soil_reading_state.dart';
import '../services/pdf_services.dart';
import '../utils/fostedGlassContainer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _generatePdf(BuildContext context) async {
    final soilState = context.read<SoilReadingBloc>().state;
    if (soilState is SoilReadingLoaded && soilState.readings.isNotEmpty) {
      final pdfData =
      await PdfService().generateSoilReadingsPdf(soilState.readings);
      await Printing.sharePdf(bytes: pdfData, filename: 'soil_report.pdf');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data available to generate a report.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsBloc = context.read<SettingsBloc>();

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
                  theme.colorScheme.primary.withOpacity(0.5),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Profile & Settings',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 👤 User Profile Info (from AuthBloc)
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: authState.photoUrl != null
                                  ? NetworkImage(authState.photoUrl!)
                                  : const AssetImage("assets/default_profile.png")
                              as ImageProvider,
                            ),
                            title: Text(
                              authState.displayName ?? "User",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(authState.email ?? ""),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),



                  const SizedBox(height: 30),

                  // ⚙️ Settings
                  FrostedGlass(
                    width: double.infinity,
                    height: 250,
                    child: BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSettingRow(
                              context,
                              icon: Iconsax.moon,
                              title: 'Dark Mode',
                              trailing: Switch(
                                value: state.isDarkMode,
                                onChanged: (value) =>
                                    settingsBloc.add(ToggleTheme(value)),
                              ),
                            ),
                            _buildSettingRow(
                              context,
                              icon: Iconsax.bluetooth,
                              title: 'Use Real Bluetooth Device',
                              subtitle: 'Requires a connected sensor',
                              trailing: Switch(
                                value: state.useRealBluetooth,
                                onChanged: (value) {
                                  settingsBloc.add(ToggleDataSource(value));
                                  if (value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const BluetoothScanScreen(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📄 Download Report
                  _buildActionButton(
                    context,
                    icon: Iconsax.document_download,
                    title: 'Download Full Report',
                    onTap: () => _generatePdf(context),
                  ),

                  const SizedBox(height: 12),

                  // 🚪 Logout
                  _buildActionButton(
                    context,
                    icon: Iconsax.logout,
                    title: 'Sign Out',
                    onTap: () =>
                        context.read<AuthBloc>().add(AuthLoggedOut()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required Widget trailing,
      }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
