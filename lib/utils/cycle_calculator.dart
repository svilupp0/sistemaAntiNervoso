class CycleCalculator {
  static DateTime calcolaProssimoCiclo(DateTime inizio, int durataCiclo) {
    return inizio.add(Duration(days: durataCiclo));
  }

  static DateTime calcolaAvviso(DateTime prossimoCiclo, int giorniPrima) {
    return prossimoCiclo.subtract(Duration(days: giorniPrima));
  }
}
