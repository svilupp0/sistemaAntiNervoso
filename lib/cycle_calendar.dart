import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class CycleCalendar extends StatelessWidget {
  final DateTime startCiclo; // data inizio ciclo
  final int durataCiclo; // numero di giorni del ciclo

  const CycleCalendar({
    super.key,
    required this.startCiclo,
    this.durataCiclo = AppConstants.durataCicloDefault,
    required int faseRossa,
  });

  // Giorni gialli secondo il ciclo umorale reale
  List<DateTime> getGiorniGialli() {
    return [
      startCiclo, // 30/08 giallo
      startCiclo.add(const Duration(days: 1)), // 31/08 giallo
      startCiclo.add(const Duration(days: 13)), // 12/09 giallo
      startCiclo.add(const Duration(days: 14)), // 13/09 giallo
      startCiclo.add(const Duration(days: 22)), // 21/09 giallo
      startCiclo.add(const Duration(days: 23)), // 22/09 giallo
      startCiclo.add(const Duration(days: 24)), // 23/09 giallo
      startCiclo.add(const Duration(days: 25)), // 24/09 giallo
    ];
  }

  // Giorni rossi secondo il ciclo umorale reale
  List<DateTime> getGiorniRossi() {
    return [
      startCiclo.add(const Duration(days: 26)), // 25/09 rosso
      startCiclo.add(const Duration(days: 27)), // 26/09 rosso
      startCiclo.add(const Duration(days: 28)), // 27/09 rosso
    ];
  }

  // Restituisce il colore di un giorno
  Color coloreGiorno(DateTime giorno) {
    if (getGiorniGialli().any(
      (d) =>
          d.year == giorno.year &&
          d.month == giorno.month &&
          d.day == giorno.day,
    )) {
      return Colors.yellow;
    } else if (getGiorniRossi().any(
      (d) =>
          d.year == giorno.year &&
          d.month == giorno.month &&
          d.day == giorno.day,
    )) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }



  @override
  Widget build(BuildContext context) {
    // Prepara i dati per il GridView
    List<Map<String, dynamic>> giorni = [];

    for (int i = 0; i < durataCiclo; i++) {
      DateTime giorno = startCiclo.add(Duration(days: i));
      Color colore = coloreGiorno(giorno);
      
      giorni.add({
        'numero': DateFormat('d').format(giorno),
        'colore': colore,
        'data': giorno,
      });
    }

    return Column(
      children: [
        // Calendario in formato griglia settimanale
        GridView.count(
          shrinkWrap: true, // il Grid prende solo lo spazio necessario
          physics: const NeverScrollableScrollPhysics(), // disabilita lo scroll interno
          crossAxisCount: 7, // 7 giorni per riga (una settimana)
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1.0, // quadrati perfetti
          children: giorni.map((giorno) {
            return Container(
              decoration: BoxDecoration(
                color: giorno['colore'],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  giorno['numero'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Legenda dei colori
        _buildLegenda(),
      ],
    );
  }
  
  /// Widget per la legenda dei colori
  Widget _buildLegenda() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Legenda Umore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendaItem(Colors.green, 'Tranquilla 😊'),
              _legendaItem(Colors.yellow, 'Dolori 😕'),
              _legendaItem(Colors.red, 'Critico ⚠️'),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Item singolo della legenda
  Widget _legendaItem(Color colore, String testo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: colore,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          testo,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
