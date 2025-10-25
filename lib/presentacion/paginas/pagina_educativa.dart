import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart'; // para acceder al ThemeNotifier

class PaginaEducativa extends StatefulWidget {
  const PaginaEducativa({super.key});

  @override
  State<PaginaEducativa> createState() => _PaginaEducativaState();
}

class _PaginaEducativaState extends State<PaginaEducativa> {
  String categoriaSeleccionada = 'Todas';
  bool mostrarJuego = false;
  int preguntaActual = 0;
  int puntaje = 0;

  final List<Map<String, String>> articulos = [
    {
      'titulo': 'Orientación de la OMS sobre urgencias',
      'descripcion':
          'Aprende cómo la Organización Mundial de la Salud define la atención de urgencias y sus protocolos globales.',
      'url':
          'https://www.who.int/teams/integrated-health-services/clinical-services-and-systems/emergency-and-critical-care',
      'categoria': 'Internacional',
      'icono': '🌍',
    },
    {
      'titulo': 'Ministerio de Salud de Colombia - Urgencias',
      'descripcion':
          'Conoce la normativa nacional sobre la atención de urgencias y derechos de los usuarios en Colombia.',
      'url':
          'https://www.minsalud.gov.co/Normatividad_Nuevo/Resoluci%C3%B3n%205596%20de%202015.pdf',
      'categoria': 'Colombia',
      'icono': '🇨🇴',
    },
    {
      'titulo': 'Secretaría Distrital de Salud Bogotá',
      'descripcion':
          'Consulta ubicación de servicios de urgencias y emergencias en la red hospitalaria de Bogotá.',
      'url':
          'https://saludata.saludcapital.gov.co/osb/indicadores/instituciones-de-salud-con-servicios-de-urgencias-en-bogota-d-c/',
      'categoria': 'Bogotá',
      'icono': '🏥',
    },
    {
      'titulo': 'Cómo identificar una urgencia real',
      'descripcion':
          'Aprende a distinguir entre una urgencia y una situación que puede atenderse en consulta médica prioritaria.',
      'url': 'https://medlineplus.gov/spanish/ency/article/001927.htm',
      'categoria': 'Prevención',
      'icono': '🧠',
    },
  ];

  final List<String> categorias = [
    'Todas',
    'Internacional',
    'Colombia',
    'Bogotá',
    'Prevención',
  ];

  final List<Map<String, dynamic>> preguntas = [
    {
      'pregunta':
          'Tienes fiebre leve y dolor de garganta, pero puedes hablar y respirar sin dificultad. ¿Deberías ir a urgencias?',
      'opciones': ['Sí', 'No'],
      'respuesta': 'No',
      'explicacion':
          'Los síntomas leves deben atenderse en consulta médica prioritaria o telemedicina, no en urgencias.',
    },
    {
      'pregunta':
          'Una persona se desmaya y no responde al hablarle. ¿Qué deberías hacer?',
      'opciones': ['Esperar a que despierte', 'Llamar al 123 o ir a urgencias'],
      'respuesta': 'Llamar al 123 o ir a urgencias',
      'explicacion':
          'La pérdida de conciencia es una urgencia vital. Llama al 123 o busca atención inmediata.',
    },
    {
      'pregunta':
          'Tienes una cortada pequeña que deja de sangrar con presión. ¿Es necesario ir a urgencias?',
      'opciones': ['Sí', 'No'],
      'respuesta': 'No',
      'explicacion':
          'Si la herida se controla fácilmente y no es profunda, puedes limpiarla y acudir a consulta normal.',
    },
  ];

  void abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $url')),
      );
    }
  }

  void responder(String respuesta) {
    final correcta = preguntas[preguntaActual]['respuesta'] as String;
    final explicacion = preguntas[preguntaActual]['explicacion'] as String;
    final esCorrecta = respuesta == correcta;

    setState(() {
      if (esCorrecta) puntaje++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          esCorrecta
              ? '✅ ¡Correcto! $explicacion'
              : '❌ Incorrecto. $explicacion',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (preguntaActual < preguntas.length - 1) {
        setState(() => preguntaActual++);
      } else {
        mostrarResultado();
      }
    });
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Resultado del juego'),
            content: Text(
              'Tu puntaje fue de $puntaje/${preguntas.length}.\n\n'
              '${puntaje == preguntas.length ? '¡Excelente! Entiendes cuándo usar urgencias.' : 'Sigue aprendiendo, estás mejorando.'}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    preguntaActual = 0;
                    puntaje = 0;
                    mostrarJuego = false;
                  });
                },
                child: const Text('Volver'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDarkMode;

    final colorClaro = const Color.fromARGB(255, 47, 177, 164); // aguamarina
    final colorOscuro = const Color.fromARGB(
      255,
      25,
      45,
      80,
    ); // azul oscuro (botón cerrar sesión)

    final fondo = isDark ? const Color(0xFF10141B) : Colors.white;
    final primario = isDark ? colorOscuro : colorClaro;
    final texto = isDark ? Colors.white : Colors.black;

    // primarioClaro: si es modo claro mantenemos el mismo primario (como pediste),
    // si es modo oscuro calculamos una versión más clara para usar en labels no seleccionados.
    final Color primarioClaro =
        isDark
            ? HSLColor.fromColor(primario)
                .withLightness(
                  (HSLColor.fromColor(primario).lightness + 0.45).clamp(
                    0.0,
                    1.0,
                  ),
                )
                .toColor()
            : primario;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: primario,
        title: const Text(
          'Educación en Salud',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            mostrarJuego
                ? _buildJuego(primario, texto)
                : _buildListaEducativa(primario, texto, isDark, primarioClaro),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => mostrarJuego = !mostrarJuego),
        backgroundColor: primario,
        icon: Icon(mostrarJuego ? Icons.book : Icons.quiz, color: Colors.white),
        label: Text(
          mostrarJuego ? 'Ver artículos' : 'Jugar y aprender',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 📚 Vista principal con artículos educativos (igual a la versión que te gustó)
  Widget _buildListaEducativa(
    Color primario,
    Color texto,
    bool isDark,
    Color primarioClaro,
  ) {
    final articulosFiltrados =
        categoriaSeleccionada == 'Todas'
            ? articulos
            : articulos
                .where((a) => a['categoria'] == categoriaSeleccionada)
                .toList();

    return Column(
      children: [
        const SizedBox(height: 10),
        // Menú de categorías
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children:
                categorias.map((cat) {
                  final seleccionada = categoriaSeleccionada == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: seleccionada ? Colors.white : primarioClaro,
                          fontWeight:
                              seleccionada ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      selected: seleccionada,
                      selectedColor: primario,
                      backgroundColor:
                          isDark ? const Color(0xFF2A3B57) : Colors.grey[200],
                      onSelected:
                          (_) => setState(() => categoriaSeleccionada = cat),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: articulosFiltrados.length,
            itemBuilder: (_, i) {
              final art = articulosFiltrados[i];
              return GestureDetector(
                onTap: () => abrirEnlace(art['url']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient:
                        isDark
                            ? LinearGradient(
                              colors: [
                                primario.withOpacity(0.4),
                                Colors.black.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : LinearGradient(
                              colors: [
                                Colors.white,
                                primario.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDark
                                ? Colors.black54
                                : Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        art['icono'] ?? '📘',
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              art['titulo'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: texto,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              art['descripcion'] ?? '',
                              style: TextStyle(
                                color: texto.withOpacity(0.8),
                                fontSize: 14.5,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        color:
                            isDark ? Colors.white70 : primario.withOpacity(0.9),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 🧠 Juego educativo interactivo
  Widget _buildJuego(Color primario, Color texto) {
    final pregunta = preguntas[preguntaActual];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pregunta ${preguntaActual + 1}/${preguntas.length}',
            style: TextStyle(color: texto.withOpacity(0.7)),
          ),
          const SizedBox(height: 10),
          Text(
            pregunta['pregunta'],
            style: TextStyle(
              color: texto,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...List.generate((pregunta['opciones'] as List).length, (i) {
            final opcion = pregunta['opciones'][i];
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primario,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => responder(opcion),
                child: Text(
                  opcion,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }),
          const SizedBox(height: 40),
          Text(
            'Puntaje: $puntaje',
            style: TextStyle(
              color: texto.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
