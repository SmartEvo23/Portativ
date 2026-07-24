/// Cele trei niveluri de public cărora li se adresează lecțiile.
enum LessonLevel { copii, elevi, hobby }

extension LessonLevelX on LessonLevel {
  String get label {
    switch (this) {
      case LessonLevel.copii:
        return 'Copii';
      case LessonLevel.elevi:
        return 'Elevi';
      case LessonLevel.hobby:
        return 'Hobby';
    }
  }

  String get description {
    switch (this) {
      case LessonLevel.copii:
        return 'Primii pași în muzică, cu explicații simple și jucăușe';
      case LessonLevel.elevi:
        return 'Teorie muzicală structurată, pas cu pas';
      case LessonLevel.hobby:
        return 'Recapitulare rapidă și aplicații practice';
    }
  }
}
