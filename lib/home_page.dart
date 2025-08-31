import 'package:flutter/material.dart';
import 'package:nome_app/cycle_calendar.dart';
import 'utils/cycle_calculator.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'styles.dart';
import 'floating_emojis.dart';
import 'prefs_helper.dart';
import 'constants.dart';
import 'notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? inizioCiclo;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final Random _random = Random();
  bool _isLoading = false; // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _caricaCicloSalvato();
    _initializeNotifications();
  }

  /// Inizializza il servizio notifiche
  Future<void> _initializeNotifications() async {
    try {
      final bool success = await NotificationService.initialize();
      if (success) {
        print('Servizio notifiche inizializzato con successo');
      } else {
        print('Impossibile inizializzare le notifiche');
      }
    } catch (e) {
      print('Errore nell\'inizializzazione delle notifiche: $e');
    }
  }

  Future<void> _caricaCicloSalvato() async {
    setState(() => _isLoading = true);
    
    try {
      final DateTime? saved = await PrefsHelper.caricaCiclo();
      if (mounted) {
        setState(() {
          inizioCiclo = saved;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _mostraErrore('Errore nel caricamento dei dati');
      }
    }
  }

  Future<void> _salvaCiclo(DateTime date) async {
    final bool success = await PrefsHelper.salvaCiclo(date);
    if (!success && mounted) {
      _mostraErrore('Errore nel salvare la data');
    }
  }

  void _mostraErrore(String messaggio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messaggio),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void scegliData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: inizioCiclo ?? DateTime.now(),
      firstDate: DateTime(AppConstants.annoMinimo),
      lastDate: DateTime(AppConstants.annoMassimo),
    );
    if (picked != null) {
      setState(() {
        inizioCiclo = picked;
      });
      await _salvaCiclo(picked);
      
      // Programma le notifiche automatiche per i giorni gialli e rossi
      await _scheduleNotifications(picked);
    }
  }

  /// Programma le notifiche per il ciclo
  Future<void> _scheduleNotifications(DateTime startDate) async {
    try {
      await NotificationService.scheduleNotifications(
        startDate,
        cycleDays: AppConstants.durataCicloDefault,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔔 Notifiche programmate per giorni gialli e rossi!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Errore nella programmazione delle notifiche: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Errore nella programmazione delle notifiche'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? prossimoCiclo;
    DateTime? avviso;
    if (inizioCiclo != null) {
      prossimoCiclo = CycleCalculator.calcolaProssimoCiclo(
        inizioCiclo!,
        AppConstants.durataCicloDefault,
      );
      avviso = CycleCalculator.calcolaAvviso(
        prossimoCiclo, 
        AppConstants.giorniPrimaAvviso
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: rainbowGradient)),
          FloatingEmojis(
            emojis: AppConstants.emojiDisponibili,
            count: AppConstants.numeroEmojiDefault,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    AppConstants.titoloApp,
                    style: mainTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Bottone per scegliere/aggiornare la data del ciclo
                  ElevatedButton(
                    onPressed: () => scegliData(context),
                    style: rainbowButtonStyle(
                      RainbowColors.all[_random.nextInt(
                        RainbowColors.all.length,
                      )],
                    ),
                    child: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(inizioCiclo == null 
                            ? AppConstants.scegliDataCiclo
                            : AppConstants.aggiornaDataCiclo),
                  ),
                  const SizedBox(height: 30),

                  // Blocchi informazioni e calendario
                  if (inizioCiclo != null &&
                      prossimoCiclo != null &&
                      avviso != null) ...[
                    Text(
                      'Prossimo ciclo previsto: ${formatter.format(prossimoCiclo)}',
                      style: infoTextStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Allarme per il fidanzato: ${formatter.format(avviso)} 😈',
                      style: infoTextStyle,
                    ),
                    const SizedBox(height: 20),
                    Text(AppConstants.calendarioUmore, style: infoTextStyle),
                    const SizedBox(height: 10),
                    CycleCalendar(
                      startCiclo: inizioCiclo!,
                      durataCiclo: AppConstants.durataCicloDefault,
                      faseRossa: AppConstants.faseRossaDefault,
                    ),
                  ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
