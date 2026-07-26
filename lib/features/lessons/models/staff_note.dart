/// Sistemul de coordonate folosit pentru a poziționa notele pe portativ (cheia sol).
///
/// Poziția 0 corespunde liniei a doua de jos a portativului (nota Mi4), iar fiecare
/// treaptă (+1 / -1) urcă, respectiv coboară, cu o linie sau un spațiu.
/// Poziții pare (0, 2, 4, 6, 8, -2, -4, 10...) cad exact pe o linie a portativului
/// (sau pe o linie suplimentară, dacă ies din portativ); poziții impare cad într-un spațiu.
class TrebleClefNotes {
  static const Map<int, String> positionToName = {
    -4: 'La',
    -3: 'Si',
    -2: 'Do',
    -1: 'Re',
    0: 'Mi',
    1: 'Fa',
    2: 'Sol',
    3: 'La',
    4: 'Si',
    5: 'Do',
    6: 'Re',
    7: 'Mi',
    8: 'Fa',
    9: 'Sol',
    10: 'La',
  };

  static String nameFor(int position) => positionToName[position] ?? '?';

  /// Numele fișierului audio (literă + octavă, notație internațională - ex.
  /// "A3", "C4") corespunzător poziției de pe portativ - folosit de
  /// [NoteSoundService] ca să găsească clipul audio potrivit din
  /// `assets/sounds/notes/`. Acoperă La3-La5 (pozițiile -4..10).
  static const Map<int, String> positionToAudioFile = {
    -4: 'A3',
    -3: 'B3',
    -2: 'C4',
    -1: 'D4',
    0: 'E4',
    1: 'F4',
    2: 'G4',
    3: 'A4',
    4: 'B4',
    5: 'C5',
    6: 'D5',
    7: 'E5',
    8: 'F5',
    9: 'G5',
    10: 'A5',
  };

  static String? audioFileFor(int position) => positionToAudioFile[position];
}
