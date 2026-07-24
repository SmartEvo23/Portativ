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
}
