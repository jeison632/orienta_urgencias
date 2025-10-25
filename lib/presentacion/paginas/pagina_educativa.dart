import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaEducativa extends StatefulWidget {
  const PaginaEducativa({super.key});

  @override
  State<PaginaEducativa> createState() => _PaginaEducativaState();
}

class _PaginaEducativaState extends State<PaginaEducativa> {
  // Lista completa de artículos con categoría
  final List<Map<String, String>> articulos = [
    {
      'titulo': 'Orientación de la OMS sobre urgencias',
      'descripcion':
          'Aprende cómo la Organización Mundial de la Salud define la atención de urgencias y sus protocolos globales.',
      'url': 'https://www.who.int/news-room/fact-sheets/detail/emergency-care',
      'categoria': 'Internacional',
      'icono': '🌍',
    },
    {
      'titulo': 'Ministerio de Salud de Colombia - Urgencias',
      'descripcion':
          'Conoce la normativa nacional sobre la atención de urgencias y derechos de los usuarios en Colombia.',
      'url': 'https://www.minsalud.gov.co/',
      'categoria': 'Colombia',
      'icono': '🇨🇴',
    },
    {
      'titulo': 'Secretaría Distrital de Salud Bogotá',
      'descripcion':
          'Consulta cómo acceder a servicios de urgencias y emergencias en la red hospitalaria de Bogotá.',
      'url':
          'https://www.saludcapital.gov.co/Paginas2/Urgencias-y-Emergencias-en-Salud.aspx',
      'categoria': 'Bogotá',
      'icono': '🏥',
    },
    {
      'titulo': 'Capital Salud EPS-S - Red de Urgencias Bogotá',
      'descripcion':
          'Descubre los puntos de atención prioritaria de Capital Salud en la ciudad.',
      'url': 'https://www.capitalsalud.gov.co/red-de-urgencias-bogota/',
      'categoria': 'Bogotá',
      'icono': '📍',
    },
    {
      'titulo': 'Cómo identificar una urgencia real',
      'descripcion':
          'Aprende a distinguir entre una urgencia y una situación que puede atenderse en consulta médica prioritaria.',
      'url':
          'https://www.minsalud.gov.co/sites/rid/Lists/BibliotecaDigital/RIDE/VS/PP/urgencias.pdf',
      'categoria': 'Prevención',
      'icono': '🧠',
    },
    {
      'titulo': 'Atención Inicial de Urgencias en Bogotá',
      'descripcion':
          'Infórmate sobre cómo recibir atención inmediata ante emergencias en la capital.',
      'url':
          'https://bogota.gov.co/servicios/tramites/atencion-inicial-de-urgencias',
      'categoria': 'Bogotá',
      'icono': '🚑',
    },
  ];

  // Categorías únicas
  final List<String> categorias = [
    'Todas',
    'Internacional',
    'Colombia',
    'Bogotá',
    'Prevención',
  ];

  String categoriaSeleccionada = 'Todas';

  // Función para abrir enlaces externos
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

  @override
  Widget build(BuildContext context) {
    // Filtrar artículos según la categoría seleccionada
    final articulosFiltrados =
        categoriaSeleccionada == 'Todas'
            ? articulos
            : articulos
                .where((art) => art['categoria'] == categoriaSeleccionada)
                .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00796B), Color(0xFF004D40)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Educación en Salud',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),

              // Menú de categorías
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children:
                      categorias.map((cat) {
                        final bool seleccionada = categoriaSeleccionada == cat;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                color:
                                    seleccionada
                                        ? Colors.white
                                        : Colors.teal[900],
                                fontWeight:
                                    seleccionada
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                              ),
                            ),
                            selected: seleccionada,
                            selectedColor: Colors.teal[700],
                            backgroundColor: Colors.white,
                            onSelected: (_) {
                              setState(() {
                                categoriaSeleccionada = cat;
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 15),

              // Lista de artículos
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: articulosFiltrados.length,
                  itemBuilder: (context, index) {
                    final articulo = articulosFiltrados[index];
                    return GestureDetector(
                      onTap: () => abrirEnlace(articulo['url']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              articulo['icono'] ?? '📘',
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articulo['titulo'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF004D40),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    articulo['descripcion'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.teal,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
