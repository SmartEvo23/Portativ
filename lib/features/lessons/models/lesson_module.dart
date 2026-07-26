/// Marile teme (module) în care sunt organizate lecțiile, independent de
/// categoria de public (Copii/Elevi/Hobby). Folosit pentru a grupa vizual
/// lecțiile pe "lumi" tematice în hărți.
enum LessonModule { teorieDeBaza, ritm, instrumente, urecheMuzicala, armonie }

extension LessonModuleX on LessonModule {
  String get label {
    switch (this) {
      case LessonModule.teorieDeBaza:
        return 'Teorie de bază';
      case LessonModule.ritm:
        return 'Ritm & Solfegiu';
      case LessonModule.instrumente:
        return 'Instrumente';
      case LessonModule.urecheMuzicala:
        return 'Ureche muzicală';
      case LessonModule.armonie:
        return 'Armonie & Acorduri';
    }
  }
}
