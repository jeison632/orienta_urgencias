import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// Importamos las páginas principales
import 'presentacion/paginas/login_page.dart';
import 'presentacion/paginas/pagina_inicio.dart';
import 'presentacion/paginas/pagina_educativa.dart';
import 'presentacion/paginas/pagina_mapa.dart';
import 'presentacion/paginas/pagina_orientacion.dart';
import 'presentacion/paginas/pagina_configuracion.dart'; // ✅ Panel de configuración

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 Leemos la preferencia del modo oscuro guardado
  final prefs = await SharedPreferences.getInstance();
  final savedDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(savedDarkMode),
      child: const MyApp(),
    ),
  );
}

/// 🌙 Provider para controlar el modo oscuro
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode;
  ThemeNotifier(this._isDarkMode);

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Orienta Urgencias',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode, // 🌙 Control dinámico del tema
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
      ),
      home: const AuthGate(),
    );
  }
}

/// 🔐 Controla si se muestra el login o la app principal
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage(); // ✅ Usuario logueado
        }

        return const LoginPage(); // ❌ Usuario no logueado
      },
    );
  }
}

/// 🏠 Pantalla principal con barra inferior de navegación
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _paginaSeleccionada = 0;

  // 🔹 Lista de páginas disponibles en la app
  final List<Widget> _paginas = const [
    PaginaInicio(),
    PaginaEducativa(),
    PaginaMapa(),
    PaginaOrientacion(),
    PaginaConfiguracion(), // ✅ Panel de configuración
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_paginaSeleccionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaSeleccionada,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _paginaSeleccionada = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Educativa'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Orientación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
