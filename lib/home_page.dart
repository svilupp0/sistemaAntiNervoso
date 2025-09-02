// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nome_app/cycle_calendar.dart';
import 'utils/cycle_calculator.dart';
import 'utils/app_logger.dart';
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
  bool _notificationsEnabled = false; // Stato notifiche
  // Stato permessi

  @override
  void initState() {
    super.initState();
    _caricaCicloSalvato();
    _initializeNotifications();
  }

  /// Inizializza il servizio notifiche
  Future<void> _initializeNotifications() async {
    try {
      // Controlla lo stato dei permessi senza richiedere
      _checkNotificationPermission();

      final bool success = await NotificationService.initialize();
      if (success) {
        AppLogger.ui('Servizio notifiche inizializzato con successo');
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        AppLogger.uiError('Impossibile inizializzare le notifiche');
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } catch (e) {
      AppLogger.uiError('Errore nell\'inizializzazione delle notifiche', e);
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  /// Controlla lo stato dei permessi notifiche
  void _checkNotificationPermission() {
    try {
      final String permission = NotificationService.getNotificationPermission();
      setState(() {
        _notificationsEnabled = permission == 'granted';
      });
      AppLogger.ui('Stato permessi notifiche: $permission');
    } catch (e) {
      AppLogger.uiError('Errore nel controllo permessi', e);
    }
  }

  /// Attiva manualmente le notifiche
  Future<void> _enableNotifications() async {
    try {
      final bool success = await NotificationService.initialize();
      if (success) {
        setState(() {
          _notificationsEnabled = true;
        });

        // Se c'è già una data del ciclo, programma le notifiche
        if (inizioCiclo != null) {
          await _scheduleNotifications(inizioCiclo!);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Notifiche attivate con successo!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Impossibile attivare le notifiche'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.uiError('Errore nell\'attivazione delle notifiche', e);
      // Mostra errore all'utente
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Errore nell\'attivazione delle notifiche'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Mostra notifica di test
  Future<void> _showTestNotification() async {
    try {
      await NotificationService.showTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🧪 Notifica di test inviata!'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      AppLogger.uiError('Errore nell\'invio della notifica di test', e);
      // Mostra errore all'utente
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Errore nell\'invio della notifica di test'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
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
            content: Text(
              '🔔 Notifiche programmate per giorni gialli e rossi!',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.uiError('Errore nella programmazione delle notifiche', e);
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
        AppConstants.giorniPrimaAvviso,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: rainbowGradient)),
          const FloatingEmojis(
            emojis: AppConstants.emojiDisponibili,
            count: AppConstants.numeroEmojiDefault,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              inizioCiclo == null
                                  ? AppConstants.scegliDataCiclo
                                  : AppConstants.aggiornaDataCiclo,
                            ),
                    ),

                    const SizedBox(height: 20),

                    // Sezione notifiche
                    _buildNotificationSection(),
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
                      const Text(AppConstants.calendarioUmore,
                          style: infoTextStyle),
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

  /// Costruisce la sezione per le notifiche
  Widget _buildNotificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: _notificationsEnabled ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _notificationsEnabled
                      ? 'Notifiche attive 🔔'
                      : 'Notifiche disattivate ❌',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _notificationsEnabled
                ? 'Il fidanzato riceverà avvisi nei giorni gialli e rossi'
                : 'Attiva le notifiche per avvisare il fidanzato',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!_notificationsEnabled)
                ElevatedButton.icon(
                  onPressed: _enableNotifications,
                  icon: const Icon(Icons.notifications, size: 18),
                  label: const Text('Attiva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              if (_notificationsEnabled)
                ElevatedButton.icon(
                  onPressed: _showTestNotification,
                  icon: const Icon(Icons.science, size: 18),
                  label: const Text('Test'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
