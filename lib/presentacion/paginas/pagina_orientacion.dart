import 'package:flutter/material.dart';

class PaginaOrientacion extends StatefulWidget {
  const PaginaOrientacion({super.key});

  @override
  State<PaginaOrientacion> createState() => _PaginaOrientacionState();
}

class _PaginaOrientacionState extends State<PaginaOrientacion> {
  // Categorías principales
  final List<String> categorias = [
    'Dolor o malestar',
    'Problemas respiratorios',
    'Trauma o accidente',
    'Síntomas digestivos',
    'Problemas neurológicos',
    'Fiebre o infección',
    'Problemas cardiovasculares',
  ];

  // Síntomas específicos por categoría
  final Map<String, List<String>> sintomasPorCategoria = {
    'Dolor o malestar': [
      'Dolor de cabeza intenso',
      'Dolor abdominal',
      'Dolor muscular generalizado',
      'Dolor articular',
    ],
    'Problemas respiratorios': [
      'Dificultad para respirar',
      'Tos persistente',
      'Dolor al respirar',
      'Congestión nasal leve',
    ],
    'Trauma o accidente': [
      'Golpe en la cabeza',
      'Sangrado abundante',
      'Dolor intenso tras caída',
      'Herida leve o raspón',
    ],
    'Síntomas digestivos': [
      'Náuseas o vómito persistente',
      'Diarrea leve',
      'Dolor abdominal intenso',
      'Sangre en las heces',
    ],
    'Problemas neurológicos': [
      'Mareos leves',
      'Convulsiones',
      'Pérdida de fuerza en un lado del cuerpo',
      'Dificultad para hablar',
    ],
    'Fiebre o infección': [
      'Fiebre menor de 38°C',
      'Fiebre alta persistente',
      'Dolor al orinar',
      'Escalofríos fuertes',
    ],
    'Problemas cardiovasculares': [
      'Dolor en el pecho con esfuerzo',
      'Palpitaciones rápidas',
      'Hinchazón en piernas',
      'Desmayo súbito',
    ],
  };

  String? categoriaSeleccionada;
  Map<String, bool> sintomasSeleccionados = {};
  String orientacion = '';
  String nivelAlerta = '';

  void generarOrientacion() {
    if (categoriaSeleccionada == null ||
        !sintomasSeleccionados.containsValue(true)) {
      setState(() {
        orientacion =
            'Por favor selecciona una categoría y al menos un síntoma para obtener orientación.';
        nivelAlerta = '';
      });
      return;
    }

    // Nivel de orientación según gravedad
    if (categoriaSeleccionada == 'Problemas cardiovasculares' &&
        sintomasSeleccionados['Dolor en el pecho con esfuerzo'] == true) {
      nivelAlerta = '🚨 Atención Inmediata';
      orientacion =
          'Podrías estar ante un problema cardíaco. Acude **de inmediato** al servicio de urgencias o llama a los números de emergencia.';
    } else if (categoriaSeleccionada == 'Problemas respiratorios' &&
        sintomasSeleccionados['Dificultad para respirar'] == true) {
      nivelAlerta = '🚨 Atención Inmediata';
      orientacion =
          'La dificultad respiratoria puede indicar una emergencia. Busca atención médica urgente.';
    } else if (categoriaSeleccionada == 'Trauma o accidente' &&
        sintomasSeleccionados['Sangrado abundante'] == true) {
      nivelAlerta = '🚨 Atención Inmediata';
      orientacion =
          'Aplica presión sobre la herida y acude **inmediatamente** a urgencias.';
    } else if (categoriaSeleccionada == 'Fiebre o infección' &&
        sintomasSeleccionados['Fiebre alta persistente'] == true) {
      nivelAlerta = '📞 Cita Prioritaria o Teleconsulta';
      orientacion =
          'Podría tratarse de una infección que requiere valoración médica. Puedes solicitar una **cita prioritaria** o usar una **teleconsulta médica**.';
    } else if (categoriaSeleccionada == 'Dolor o malestar' &&
        sintomasSeleccionados['Dolor muscular generalizado'] == true) {
      nivelAlerta = '🏠 Manejo en Casa';
      orientacion =
          'Descansa, mantente hidratado y utiliza analgésicos de venta libre si es necesario. Si el dolor aumenta, programa una cita médica.';
    } else if (categoriaSeleccionada == 'Síntomas digestivos' &&
        sintomasSeleccionados['Diarrea leve'] == true) {
      nivelAlerta = '🏠 Manejo en Casa';
      orientacion =
          'Mantente hidratado y evita alimentos grasos o pesados. Si la diarrea dura más de 2 días o hay sangre, solicita una **cita médica prioritaria**.';
    } else if (categoriaSeleccionada == 'Problemas neurológicos' &&
        sintomasSeleccionados['Mareos leves'] == true) {
      nivelAlerta = '📞 Cita Prioritaria o Teleconsulta';
      orientacion =
          'Podrías tener una alteración leve del equilibrio o presión baja. Monitorea los síntomas y consulta mediante **telemedicina** si persisten.';
    } else {
      nivelAlerta = '📞 Cita Prioritaria o Teleconsulta';
      orientacion =
          'Según los síntomas seleccionados, te recomendamos solicitar una **cita médica prioritaria** o usar una **teleconsulta** para una valoración profesional.';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orientación Médica'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una categoría:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: categoriaSeleccionada,
              hint: const Text('Elige una categoría'),
              isExpanded: true,
              items:
                  categorias.map((String categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
              onChanged: (String? valor) {
                setState(() {
                  categoriaSeleccionada = valor;
                  sintomasSeleccionados.clear();
                  for (var sintoma
                      in sintomasPorCategoria[categoriaSeleccionada] ?? []) {
                    sintomasSeleccionados[sintoma] = false;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            if (categoriaSeleccionada != null)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Selecciona los síntomas que presentas:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...sintomasSeleccionados.keys.map((sintoma) {
                      return CheckboxListTile(
                        title: Text(sintoma),
                        value: sintomasSeleccionados[sintoma],
                        onChanged: (bool? valor) {
                          setState(() {
                            sintomasSeleccionados[sintoma] = valor ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: generarOrientacion,
                icon: const Icon(Icons.health_and_safety),
                label: const Text('Obtener orientación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (orientacion.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nivelAlerta,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      orientacion,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
