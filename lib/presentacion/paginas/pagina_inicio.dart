import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart'; // Importa el ThemeNotifier
import 'pagina_orientacion.dart';
import 'pagina_educativa.dart';
import 'pagina_mapa.dart';
import 'pagina_configuracion.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDarkMode;

    // 🎨 Colores personalizados
    final colorAguamarina = const Color.fromARGB(255, 47, 177, 164);
    final colorAzulOscuro = const Color.fromARGB(255, 25, 45, 80);

    // 🌞 / 🌙 Colores dinámicos
    final fondo = isDark ? Colors.black : Colors.white;
    final appBarColor = isDark ? colorAzulOscuro : colorAguamarina;
    final botonColor = isDark ? colorAzulOscuro : colorAguamarina;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Orienta Urgencias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/imagen_inicio.png', height: 200),
            const SizedBox(height: 20),

            // 🏥 Título principal
            Text(
              'Bienvenido a Orienta Urgencias',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // 📖 Descripción
            Text(
              'Esta aplicación te orienta sobre el uso adecuado de los servicios de urgencias en Bogotá. '
              'Aprende a identificar cuándo acudir, consulta centros médicos cercanos y recibe orientación personalizada.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 🎓 Botones principales
            _buildBoton3D(
              context,
              color: botonColor,
              icon: Icons.school,
              texto: 'Ir a sección educativa',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaEducativa()),
                );
              },
            ),

            const SizedBox(height: 15),

            _buildBoton3D(
              context,
              color: botonColor,
              icon: Icons.health_and_safety,
              texto: 'Ir a orientación médica',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaOrientacion()),
                );
              },
            ),

            const SizedBox(height: 15),

            _buildBoton3D(
              context,
              color: botonColor,
              icon: Icons.map,
              texto: 'Ver mapa de urgencias',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaMapa()),
                );
              },
            ),

            const SizedBox(height: 15),

            _buildBoton3D(
              context,
              color: botonColor,
              icon: Icons.settings,
              texto: 'Panel de configuración',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaginaConfiguracion(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🌟 Botón 3D reutilizable con efecto de relieve
  Widget _buildBoton3D(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String texto,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // 🔹 Sombra inferior (efecto 3D)
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 6,
          ),
          // 🔹 Luz superior (resalta el borde)
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            offset: const Offset(-4, -4),
            blurRadius: 6,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.4),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
