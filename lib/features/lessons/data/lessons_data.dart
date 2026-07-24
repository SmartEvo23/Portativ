import '../models/exercise_model.dart';
import '../models/lesson_level.dart';
import '../models/lesson_model.dart';

/// Curriculumul de start al aplicației: 3 lecții pentru fiecare nivel
/// (copii, elevi, hobby), fiecare cu explicații scurte și exerciții.
class LessonsData {
  static const List<LessonModel> all = [
    // ------------------------------------------------------------------
    // COPII
    // ------------------------------------------------------------------
    LessonModel(
      id: 'copii-1',
      level: LessonLevel.copii,
      title: 'Ce este portativul?',
      summary: 'Prima ta întâlnire cu portativul și cheia sol.',
      showcaseNotePositions: [0, 2, 4, 6, 8],
      content: [
        'Portativul este "foaia" specială pe care se scrie muzica: are 5 linii și 4 spații, ca un mic gărduleț pentru note.',
        'La începutul portativului stă cheia sol - un semn rotunjit și buclat care arată unde locuiește nota Sol.',
        'Fiecare notă are casa ei: unele stau chiar pe o linie, altele se odihnesc într-un spațiu, între două linii.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Din câte linii este format portativul?',
          options: [
            ExerciseOption(text: '4', isCorrect: false),
            ExerciseOption(text: '5', isCorrect: true),
            ExerciseOption(text: '6', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce semn arată unde locuiește nota Sol?',
          options: [
            ExerciseOption(text: 'Cheia sol', isCorrect: true),
            ExerciseOption(text: 'O pauză', isCorrect: false),
            ExerciseOption(text: 'O liniuță', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'copii-2',
      level: LessonLevel.copii,
      title: 'Notele prietenoase',
      summary: 'Cunoaște cele 7 note: Do Re Mi Fa Sol La Si.',
      content: [
        'Muzica are doar 7 nume de note: Do, Re, Mi, Fa, Sol, La, Si. După Si, totul o ia de la capăt cu Do.',
        'Pe portativ, fiecare notă stă cu o treaptă mai sus decât vecina ei din stânga - ca niște trepte de scară.',
        'Hai să exersăm: uită-te la portativ și ghicește ce notă vezi!',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: 2,
          options: [
            ExerciseOption(text: 'Do', isCorrect: false),
            ExerciseOption(text: 'Sol', isCorrect: true),
            ExerciseOption(text: 'Si', isCorrect: false),
            ExerciseOption(text: 'Fa', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: -2,
          options: [
            ExerciseOption(text: 'Do', isCorrect: true),
            ExerciseOption(text: 'Re', isCorrect: false),
            ExerciseOption(text: 'La', isCorrect: false),
            ExerciseOption(text: 'Mi', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: 5,
          options: [
            ExerciseOption(text: 'Fa', isCorrect: false),
            ExerciseOption(text: 'Re', isCorrect: false),
            ExerciseOption(text: 'Do', isCorrect: true),
            ExerciseOption(text: 'Sol', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'copii-3',
      level: LessonLevel.copii,
      title: 'Lungă sau scurtă?',
      summary: 'Primul pas spre ritm: note lungi și note scurte.',
      content: [
        'Unele note se cântă lung, altele scurt - exact ca și cuvintele: unele silabe le tragem mai mult, altele le spunem repede.',
        'Nota întreagă se ține patru timpi: numeri rar 1-2-3-4, ca și cum ai bate din palme lent.',
        'Pătrimea se ține doar un timp: scurtă și hotărâtă, ca un singur "clap!".',
      ],
      exercises: [
        ExerciseModel(
          question: 'Care notă durează mai mult timp?',
          options: [
            ExerciseOption(text: 'Nota întreagă', isCorrect: true),
            ExerciseOption(text: 'Pătrimea', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Câți timpi are o pătrime?',
          options: [
            ExerciseOption(text: '4', isCorrect: false),
            ExerciseOption(text: '2', isCorrect: false),
            ExerciseOption(text: '1', isCorrect: true),
          ],
        ),
      ],
    ),

    // ------------------------------------------------------------------
    // ELEVI
    // ------------------------------------------------------------------
    LessonModel(
      id: 'elevi-1',
      level: LessonLevel.elevi,
      title: 'Portativul și cheia sol',
      summary: 'Numele exacte ale liniilor și spațiilor pe cheia sol.',
      showcaseNotePositions: [0, 1, 2, 3, 4, 5, 6, 7, 8],
      content: [
        'Portativul are 5 linii, numărate de jos în sus. Cheia sol se așază pe linia a doua și fixează poziția notei Sol (Sol4).',
        'Pe linii (de jos în sus) găsim notele Mi, Sol, Si, Re, Fa - ține minte prin propoziția "Every Good Boy Does Fine".',
        'În spații (de jos în sus): Fa, La, Do, Mi - formează chiar cuvântul FACE.',
        'Cu aceste două repere poți citi orice notă de pe portativ, fără să numeri de fiecare dată de la capăt.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce notă este pe a doua linie de jos?',
          notePosition: 2,
          options: [
            ExerciseOption(text: 'Mi', isCorrect: false),
            ExerciseOption(text: 'Sol', isCorrect: true),
            ExerciseOption(text: 'Si', isCorrect: false),
            ExerciseOption(text: 'La', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este în primul spațiu de jos?',
          notePosition: 1,
          options: [
            ExerciseOption(text: 'Fa', isCorrect: true),
            ExerciseOption(text: 'La', isCorrect: false),
            ExerciseOption(text: 'Do', isCorrect: false),
            ExerciseOption(text: 'Mi', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este pe linia de sus a portativului?',
          notePosition: 8,
          options: [
            ExerciseOption(text: 'Mi', isCorrect: false),
            ExerciseOption(text: 'Re', isCorrect: false),
            ExerciseOption(text: 'Fa', isCorrect: true),
            ExerciseOption(text: 'Sol', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este pe linia suplimentară de sub portativ?',
          notePosition: -2,
          options: [
            ExerciseOption(text: 'Si', isCorrect: false),
            ExerciseOption(text: 'La', isCorrect: false),
            ExerciseOption(text: 'Do', isCorrect: true),
            ExerciseOption(text: 'Re', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-2',
      level: LessonLevel.elevi,
      title: 'Valorile de note și pauze',
      summary: 'Cât durează fiecare notă și cum se scriu tăcerile.',
      content: [
        'Fiecare notă are o durată: nota întreagă = 4 timpi, doimea = 2 timpi, pătrimea = 1 timp, optimea = jumătate de timp.',
        'Fiecare notă are o pauză corespunzătoare - același număr de timpi, dar în tăcere.',
        'O notă întreagă echivalează cu 2 doimi, sau cu 4 pătrimi, sau cu 8 optimi - se pot împărți exact.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Câți timpi de pătrime încap într-o notă întreagă?',
          options: [
            ExerciseOption(text: '2', isCorrect: false),
            ExerciseOption(text: '4', isCorrect: true),
            ExerciseOption(text: '8', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Câți timpi are o doime?',
          options: [
            ExerciseOption(text: '1', isCorrect: false),
            ExerciseOption(text: '2', isCorrect: true),
            ExerciseOption(text: '4', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce reprezintă o pauză?',
          options: [
            ExerciseOption(text: 'O notă mai înaltă', isCorrect: false),
            ExerciseOption(text: 'Un timp de tăcere', isCorrect: true),
            ExerciseOption(text: 'O notă mai joasă', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-3',
      level: LessonLevel.elevi,
      title: 'Măsura și tactul',
      summary: 'Cum se numără timpii într-o piesă muzicală.',
      content: [
        'Cifra de măsură (ex: 4/4) are două numere: cel de sus spune câți timpi sunt într-o măsură, cel de jos spune ce notă reprezintă un timp.',
        'În 4/4 avem 4 timpi pe măsură, iar un timp = o pătrime. E cea mai comună măsură, folosită în majoritatea cântecelor.',
        'În 3/4 avem doar 3 timpi pe măsură - e măsura specifică valsului: UM-doi-trei, UM-doi-trei.',
      ],
      exercises: [
        ExerciseModel(
          question: 'În măsura 4/4, câți timpi sunt într-o măsură?',
          options: [
            ExerciseOption(text: '3', isCorrect: false),
            ExerciseOption(text: '4', isCorrect: true),
            ExerciseOption(text: '2', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce măsură este specifică valsului?',
          options: [
            ExerciseOption(text: '4/4', isCorrect: false),
            ExerciseOption(text: '2/4', isCorrect: false),
            ExerciseOption(text: '3/4', isCorrect: true),
          ],
        ),
        ExerciseModel(
          question: 'În 4/4, ce notă reprezintă un timp?',
          options: [
            ExerciseOption(text: 'Doimea', isCorrect: false),
            ExerciseOption(text: 'Pătrimea', isCorrect: true),
            ExerciseOption(text: 'Optimea', isCorrect: false),
          ],
        ),
      ],
    ),

    // ------------------------------------------------------------------
    // HOBBY
    // ------------------------------------------------------------------
    LessonModel(
      id: 'hobby-1',
      level: LessonLevel.hobby,
      title: 'Recapitulare rapidă: portativ și note',
      summary: 'Un refresh condensat pentru cine a mai citit note cândva.',
      showcaseNotePositions: [-2, 0, 2, 4, 6, 8, 10],
      content: [
        'Portativ = 5 linii, cheia sol fixează Sol4 pe linia a doua. Liniile: Mi-Sol-Si-Re-Fa, spațiile: Fa-La-Do-Mi.',
        'Notele urcă alfabetic-muzical: Do Re Mi Fa Sol La Si, apoi se reiau de la Do, la o octavă mai sus.',
        'Cu acest reper poți citi rapid orice linie melodică simplă, direct de pe partitură.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: 6,
          options: [
            ExerciseOption(text: 'Fa', isCorrect: false),
            ExerciseOption(text: 'Re', isCorrect: true),
            ExerciseOption(text: 'La', isCorrect: false),
            ExerciseOption(text: 'Si', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: 10,
          options: [
            ExerciseOption(text: 'Sol', isCorrect: false),
            ExerciseOption(text: 'Fa', isCorrect: false),
            ExerciseOption(text: 'La', isCorrect: true),
            ExerciseOption(text: 'Do', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce notă este aceasta?',
          notePosition: -4,
          options: [
            ExerciseOption(text: 'La', isCorrect: true),
            ExerciseOption(text: 'Si', isCorrect: false),
            ExerciseOption(text: 'Fa', isCorrect: false),
            ExerciseOption(text: 'Re', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-2',
      level: LessonLevel.hobby,
      title: 'Gama majoră de bază',
      summary: 'Formula tonuri-semitonuri din spatele oricărei game majore.',
      content: [
        'O gamă majoră se construiește după o formulă fixă de distanțe: Ton-Ton-Semiton-Ton-Ton-Ton-Semiton.',
        'Gama Do major respectă exact această formulă folosind doar clapele albe ale pianului - fără nicio alterație (diez sau bemol).',
        'Aceeași formulă, aplicată pornind de la orice altă notă, îți dă gama majoră a acelei note (ex: gama Sol major, gama Re major etc).',
      ],
      exercises: [
        ExerciseModel(
          question: 'Câte alterații are gama Do major?',
          options: [
            ExerciseOption(text: '0', isCorrect: true),
            ExerciseOption(text: '1', isCorrect: false),
            ExerciseOption(text: '2', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Care este formula unei game majore?',
          options: [
            ExerciseOption(text: 'Ton-Semiton-Ton-Ton-Semiton-Ton-Ton', isCorrect: false),
            ExerciseOption(text: 'Ton-Ton-Semiton-Ton-Ton-Ton-Semiton', isCorrect: true),
            ExerciseOption(text: 'Numai semitonuri', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-3',
      level: LessonLevel.hobby,
      title: 'Acordul major de bază',
      summary: 'Cum construiești un acord direct din gamă.',
      content: [
        'Un acord major de bază (o triadă) se construiește din treptele 1, 3 și 5 ale unei game majore.',
        'Pornind din gama Do major (Do-Re-Mi-Fa-Sol-La-Si), treptele 1-3-5 sunt Do-Mi-Sol - exact acordul Do major.',
        'Aceeași rețetă (treptele 1, 3, 5) funcționează pentru orice gamă majoră, ca să obții acordul ei major.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Din ce note e format acordul Do major?',
          options: [
            ExerciseOption(text: 'Do-Re-Mi', isCorrect: false),
            ExerciseOption(text: 'Do-Fa-Sol', isCorrect: false),
            ExerciseOption(text: 'Do-Mi-Sol', isCorrect: true),
          ],
        ),
        ExerciseModel(
          question: 'Ce trepte formează o triadă majoră de bază?',
          options: [
            ExerciseOption(text: '1-2-3', isCorrect: false),
            ExerciseOption(text: '1-3-5', isCorrect: true),
            ExerciseOption(text: '2-4-6', isCorrect: false),
          ],
        ),
      ],
    ),
  ];

  static List<LessonModel> byLevel(LessonLevel level) => all.where((l) => l.level == level).toList();

  static LessonModel byId(String id) => all.firstWhere((l) => l.id == id);
}
