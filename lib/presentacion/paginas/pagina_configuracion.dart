import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../main.dart'; // Importa ThemeNotifier desde main.dart

class PaginaConfiguracion extends StatefulWidget {
  const PaginaConfiguracion({super.key});

  @override
  State<PaginaConfiguracion> createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
  bool notificaciones = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final esOscuro = themeNotifier.isDarkMode;

    // Colores uniformes con los módulos anteriores
    final colorFondo = esOscuro ? const Color(0xFF1E1E1E) : Colors.white;
    final colorPrimario = esOscuro ? const Color(0xFF00BFA5) : Colors.teal;
    final colorTexto = esOscuro ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔔 Opción de notificaciones
            SwitchListTile(
              title: Text(
                'Notificaciones',
                style: TextStyle(color: colorTexto),
              ),
              value: notificaciones,
              onChanged: (val) {
                setState(() => notificaciones = val);
              },
              activeColor: colorPrimario,
            ),

            // 🌙 Opción de modo oscuro
            SwitchListTile(
              title: Text('Modo oscuro', style: TextStyle(color: colorTexto)),
              subtitle: Text(
                themeNotifier.isDarkMode ? 'Activado' : 'Desactivado',
                style: TextStyle(
                  color: esOscuro ? Colors.white70 : Colors.black54,
                ),
              ),
              value: themeNotifier.isDarkMode,
              onChanged: (val) async {
                await themeNotifier.setDarkMode(val);
              },
              activeColor: colorPrimario,
            ),

            const SizedBox(height: 40),

            // 🚪 Botón de cerrar sesión
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimario,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesión cerrada correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al cerrar sesión: $e'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
