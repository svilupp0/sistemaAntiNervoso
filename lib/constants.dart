/// Costanti dell'applicazione Sistema Anti-Nervoso
class AppConstants {
  // Configurazione ciclo
  static const int durataCicloDefault = 28;
  static const int giorniPrimaAvviso = 10;
  
  // Configurazione calendario umore
  static const int faseRossaDefault = 26;
  
  // Configurazione animazioni
  static const int durataAnimazioneSecondi = 30; // Ridotto da 60 per performance
  static const int numeroEmojiDefault = 15;
  static const double velocitaAnimazioneMin = 0.001;
  static const double velocitaAnimazioneMax = 0.003;
  
  // Emoji utilizzate
  static const List<String> emojiDisponibili = [
    '😈', '😂', '🥳', '💖', '🌈', '🔥', '💪', '✨', '🦄', '🍀'
  ];
  
  // Messaggi UI
  static const String titoloApp = 'Sistema Anti-Nervoso 😎';
  static const String scegliDataCiclo = 'Scegli data del ciclo';
  static const String aggiornaDataCiclo = 'Aggiorna data ciclo';
  static const String calendarioUmore = 'Calendario umore';
  
  // Messaggi calendario
  static const String messaggioGiallo = 'Giallo: dolori / stranita';
  static const String messaggioRosso = 'Rosso: strillo / piango ⚠️';
  
  // Limiti date
  static const int annoMinimo = 2020;
  static const int annoMassimo = 2030;
}