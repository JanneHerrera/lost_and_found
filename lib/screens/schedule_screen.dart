import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedDay = 'Lunes';

  final Map<String, List<Map<String, String>>> schedule = {
    "Lunes": [
      {
        "hora": "15:00 - 16:40",
        "materia": "ÉTICA PROFESIONAL",
        "docente": "VELAZQUEZ CASTAÑEDA AIDA",
        "salon": "LABORATORIO DE CIENCIAS BASICAS"
      },
      {
        "hora": "16:40 - 18:20",
        "materia": "PROYECTO II",
        "docente": "ARENAS YERENA CARLOS DARIO",
        "salon": "LABORATORIO DE SOFTWARE"
      },
      {
        "hora": "18:20 - 20:00",
        "materia": "TECNOLOGÍAS EMERGENTES",
        "docente": "MONTIEL MENA RICARDO",
        "salon": "LABORATORIO DE SOFTWARE"
      },
      {
        "hora": "20:00 - 20:50",
        "materia": "PLANEACIÓN ESTRATÉGICA Y HABILIDADES DIRECTIVAS",
        "docente": "HUERTA FRANCO MARIA DEL CORAZON DE JESUS",
        "salon": "B:110"
      }
    ],
    "Martes": [
      {
        "hora": "15:00 - 16:40",
        "materia": "INGLÉS VII",
        "docente": "MORENO ORTIZ NESTOR",
        "salon": "B:110"
      },
      {
        "hora": "16:40 - 18:20",
        "materia": "INGENIERÍA INVERSA",
        "docente": "GASPAR PEREZ LUIS FERNANDO",
        "salon": "LABORATORIO DE SOFTWARE"
      },
      {
        "hora": "18:20 - 20:00",
        "materia": "PROYECTO II",
        "docente": "ARENAS YERENA CARLOS DARIO",
        "salon": "LABORATORIO DE SOFTWARE"
      },
      {
        "hora": "20:00 - 20:50",
        "materia": "LIBRE",
        "docente": "LIBRE",
        "salon": "LIBRE"
      },
      {
        "hora": "20:50 - 21:40",
        "materia": "PROYECTO II",
        "docente": "ARENAS YERENA CARLOS DARIO",
        "salon": "LABORATORIO DE SOFTWARE"
      }
    ],
    "Miércoles": [
      {
        "hora": "15:00 - 16:40",
        "materia": "PLANEACIÓN ESTRATÉGICA Y HABILIDADES DIRECTIVAS",
        "docente": "HUERTA FRANCO MARIA DEL CORAZON DE JESUS",
        "salon": "L:205"
      },
      {
        "hora": "16:40 - 18:20",
        "materia": "ASEGURAMIENTO DE LA CALIDAD DEL SOFTWARE",
        "docente": "MEDINA GARCIA FRANCISCO JAVIER",
        "salon": "LABORATORIOS DE COMPUTACION Y SOFTWARE LIBRE"
      },
      {
        "hora": "18:20 - 20:00",
        "materia": "TECNOLOGÍAS EMERGENTES",
        "docente": "MONTIEL MENA RICARDO",
        "salon": "LABORATORIO DE SOFTWARE"
      }
    ],
    "Jueves": [
      {
        "hora": "16:40 - 18:20",
        "materia": "ASEGURAMIENTO DE LA CALIDAD DEL SOFTWARE",
        "docente": "MEDINA GARCIA FRANCISCO JAVIER",
        "salon": "LABORATORIO DE SOFTWARE"
      },
      {
        "hora": "18:20 - 20:00",
        "materia": "INGENIERÍA INVERSA",
        "docente": "GASPAR PEREZ LUIS FERNANDO",
        "salon": "LABORATORIOS DE COMPUTACION Y SOFTWARE LIBRE"
      }
    ],
    "Viernes": [
      {
        "hora": "15:00 - 15:50",
        "materia": "PLANEACIÓN ESTRATÉGICA Y HABILIDADES DIRECTIVAS",
        "docente": "HUERTA FRANCO MARIA DEL CORAZON DE JESUS",
        "salon": "B:107"
      },
      {
        "hora": "15:50 - 16:40",
        "materia": "ÉTICA PROFESIONAL",
        "docente": "VELAZQUEZ CASTAÑEDA AIDA",
        "salon": "LABORATORIO DE CIENCIAS BASICAS"
      },
      {
        "hora": "16:40 - 18:20",
        "materia": "INGLÉS VII",
        "docente": "MORENO ORTIZ NESTOR",
        "salon": "B:110"
      }
    ]
  };

  final List<Color> colors = [
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5F98E4),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF5F98E4),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedDay,
                isExpanded: true,
                dropdownColor: Colors.white, // Cambio para mejor visibilidad
                underline: Container(),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedDay = newValue;
                    });
                    debugPrint("Día seleccionado: $selectedDay");
                  }
                },
                items: schedule.keys.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child:
                        Text(day, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: schedule[selectedDay]!.isEmpty
                ? const Center(child: Text("No hay clases para este día"))
                : ListView.builder(
                    itemCount: schedule[selectedDay]!.length,
                    itemBuilder: (context, index) {
                      var clase = schedule[selectedDay]![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(clase['hora']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(clase['materia']!,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                                "Docente: ${clase['docente']!.isEmpty ? 'N/A' : clase['docente']!}",
                                style: const TextStyle(fontSize: 12)),
                            Text(
                                "Salón: ${clase['salon']!.isEmpty ? 'N/A' : clase['salon']!}",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
