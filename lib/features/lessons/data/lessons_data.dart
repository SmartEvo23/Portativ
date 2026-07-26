import '../models/exercise_model.dart';
import '../models/lesson_level.dart';
import '../models/lesson_model.dart';
import '../models/lesson_module.dart';

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

    // ==================================================================
    // MODUL: RITM & SOLFEGIU
    // ==================================================================
    LessonModel(
      id: 'copii-ritm-1',
      level: LessonLevel.copii,
      module: LessonModule.ritm,
      title: 'Bate ritmul cu mine!',
      summary: 'Prima întâlnire cu pulsul care se repetă într-o melodie.',
      content: [
        'Ritmul este bătaia inimii unei melodii - un puls care se repetă, ca și cum ai bate din palme la fel de des.',
        'Poți simți ritmul chiar și fără muzică: bate din picior, bate din palme, sau numără rar: 1, 2, 3, 4.',
        'Unele bătăi sunt accentuate (mai tari) - de obicei prima dintr-un grup, ca un mic "BUM" la început.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce este ritmul unei melodii?',
          options: [
            ExerciseOption(text: 'Culoarea notelor', isCorrect: false),
            ExerciseOption(text: 'Pulsul care se repetă', isCorrect: true),
            ExerciseOption(text: 'Numele notei', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Care bătaie este de obicei mai accentuată într-un grup?',
          options: [
            ExerciseOption(text: 'Ultima', isCorrect: false),
            ExerciseOption(text: 'Prima', isCorrect: true),
            ExerciseOption(text: 'Nu contează', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'copii-ritm-2',
      level: LessonLevel.copii,
      module: LessonModule.ritm,
      title: 'Măsura de 4 timpi',
      summary: 'Cum se grupează bătăile în seturi care se repetă.',
      content: [
        'Multe cântece grupează bătăile în seturi de 4: 1-2-3-4, apoi iar 1-2-3-4.',
        'Fiecare grup se numește măsură. Poți bate din palme și număra: UNU-doi-trei-patru, UNU-doi-trei-patru.',
        'Încearcă: bate din palme rar, numărând până la 4, apoi ia-o de la capăt - simți cum se formează un tipar?',
      ],
      exercises: [
        ExerciseModel(
          question: 'Câte bătăi are, de obicei, un grup numit măsură?',
          options: [
            ExerciseOption(text: '2', isCorrect: false),
            ExerciseOption(text: '4', isCorrect: true),
            ExerciseOption(text: '7', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Cum se numește un grup de bătăi care se repetă?',
          options: [
            ExerciseOption(text: 'Măsură', isCorrect: true),
            ExerciseOption(text: 'Portativ', isCorrect: false),
            ExerciseOption(text: 'Pauză', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-ritm-1',
      level: LessonLevel.elevi,
      module: LessonModule.ritm,
      title: 'Măsuri simple și compuse',
      summary: 'Diferența dintre 4/4 și 6/8 - și de ce sună altfel.',
      content: [
        'Măsurile simple (2/4, 3/4, 4/4) împart fiecare timp în două părți egale. Măsurile compuse (6/8, 9/8, 12/8) împart fiecare timp în trei părți egale.',
        'În 6/8, deși sunt scrise 6 optimi, ei se simt ca 2 timpi mari, fiecare cu câte 3 optimi - de-aici vine legănarea specifică multor cântece de leagăn.',
        'Recunoști o măsură compusă după cifra de sus: dacă e 6, 9 sau 12, e compusă; dacă e 2, 3 sau 4, e simplă.',
      ],
      exercises: [
        ExerciseModel(
          question: 'În câte părți împarte fiecare timp o măsură compusă?',
          options: [
            ExerciseOption(text: 'Două', isCorrect: false),
            ExerciseOption(text: 'Trei', isCorrect: true),
            ExerciseOption(text: 'Patru', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Care dintre acestea este o măsură compusă?',
          options: [
            ExerciseOption(text: '3/4', isCorrect: false),
            ExerciseOption(text: '6/8', isCorrect: true),
            ExerciseOption(text: '2/4', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Câți optimi are, în total, o măsură de 6/8?',
          options: [
            ExerciseOption(text: '6', isCorrect: true),
            ExerciseOption(text: '8', isCorrect: false),
            ExerciseOption(text: '3', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-ritm-2',
      level: LessonLevel.elevi,
      module: LessonModule.ritm,
      title: 'Sincopa: ritmul care surprinde',
      summary: 'Când accentul cade unde nu te aștepți.',
      content: [
        'Sincopa apare când accentul cade unde nu te aștepți - pe un timp slab, sau între timpi, în loc de pe timpul tare.',
        'Ea dă senzația de "legănare" sau "surpriză" ritmică, fiind foarte folosită în jazz, funk și muzica pop.',
        'Un exemplu simplu: dacă în loc să accentuezi 1-2-3-4, accentuezi "și"-ul dintre 2 și 3, obții o sincopă.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce este sincopa?',
          options: [
            ExerciseOption(text: 'O notă foarte lungă', isCorrect: false),
            ExerciseOption(text: 'Un accent pe un timp neașteptat', isCorrect: true),
            ExerciseOption(text: 'O pauză lungă', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'În ce gen muzical este sincopa foarte des folosită?',
          options: [
            ExerciseOption(text: 'Jazz', isCorrect: true),
            ExerciseOption(text: 'Nu se folosește niciodată', isCorrect: false),
            ExerciseOption(text: 'Doar în muzica de cameră barocă', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-ritm-1',
      level: LessonLevel.hobby,
      module: LessonModule.ritm,
      title: 'Recapitulare: ritm și măsură',
      summary: 'Puls, măsuri și sincopă, pe scurt.',
      content: [
        'Ritmul e pulsul care se repetă; măsura grupează bătăile (2, 3 sau 4 timpi de obicei, ori 6/9/12 în măsuri compuse).',
        'Sincopa mută accentul pe un timp neașteptat, dând senzația de surpriză ritmică - specifică jazz-ului și muzicii pop.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce diferență e între o măsură simplă și una compusă?',
          options: [
            ExerciseOption(text: 'Nu există diferență', isCorrect: false),
            ExerciseOption(text: 'Compusă împarte timpul în 3, simplă în 2', isCorrect: true),
            ExerciseOption(text: 'Simplă are mai mulți timpi', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce efect dă o sincopă?',
          options: [
            ExerciseOption(text: 'Liniște completă', isCorrect: false),
            ExerciseOption(text: 'Senzație de surpriză ritmică', isCorrect: true),
            ExerciseOption(text: 'O notă mai gravă', isCorrect: false),
          ],
        ),
      ],
    ),

    // ==================================================================
    // MODUL: INSTRUMENTE
    // ==================================================================
    LessonModel(
      id: 'copii-instrumente-1',
      level: LessonLevel.copii,
      module: LessonModule.instrumente,
      title: 'Familii de instrumente',
      summary: 'Coarde, suflat, percuție și claviaturi.',
      content: [
        'Instrumentele muzicale se împart în familii, după cum produc sunetul: instrumente cu coarde (vioara, chitara), instrumente de suflat (flautul, trompeta), instrumente de percuție (toba, xilofonul) și claviaturi (pianul).',
        'Instrumentele cu coarde sună când o coardă vibrează - fie ciupită (chitară), fie frecată cu arcușul (vioară).',
        'Instrumentele de suflat sună când sufli aer prin ele, iar cele de percuție sună când sunt lovite.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Din ce familie face parte vioara?',
          options: [
            ExerciseOption(text: 'Suflat', isCorrect: false),
            ExerciseOption(text: 'Coarde', isCorrect: true),
            ExerciseOption(text: 'Percuție', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Cum produce sunet un instrument de percuție?',
          options: [
            ExerciseOption(text: 'Este lovit', isCorrect: true),
            ExerciseOption(text: 'Este suflat', isCorrect: false),
            ExerciseOption(text: 'Este ciupit', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce fel de instrument este pianul?',
          options: [
            ExerciseOption(text: 'Claviatură', isCorrect: true),
            ExerciseOption(text: 'Percuție', isCorrect: false),
            ExerciseOption(text: 'Suflat', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'copii-instrumente-2',
      level: LessonLevel.copii,
      module: LessonModule.instrumente,
      title: 'Ghicește instrumentul',
      summary: 'Fiecare instrument are propria "culoare" de sunet.',
      content: [
        'Fiecare instrument are un "timbru" - o culoare a sunetului unică, prin care îl poți recunoaște chiar dacă cântă aceeași notă ca altul.',
        'Trompeta sună strălucitor și puternic, vioara sună caldă și cântată, toba sună percutant și ritmic.',
        'Cu puțin exercițiu, poți recunoaște instrumentele după ureche, chiar și fără să le vezi.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Cum se numește culoarea specifică a sunetului unui instrument?',
          options: [
            ExerciseOption(text: 'Ritm', isCorrect: false),
            ExerciseOption(text: 'Timbru', isCorrect: true),
            ExerciseOption(text: 'Portativ', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce instrument sună, de obicei, "strălucitor și puternic"?',
          options: [
            ExerciseOption(text: 'Trompeta', isCorrect: true),
            ExerciseOption(text: 'Vioara', isCorrect: false),
            ExerciseOption(text: 'Toba', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-instrumente-1',
      level: LessonLevel.elevi,
      module: LessonModule.instrumente,
      title: 'Clasificarea instrumentelor (organologie)',
      summary: 'Cordofone, aerofone, membranofone și idiofone.',
      content: [
        'Organologia este știința care clasifică instrumentele muzicale. O clasificare clasică le împarte în: cordofone (coarde), aerofone (suflat), membranofone (percuție cu membrană) și idiofone (percuție fără membrană, ex. xilofon, triunghi).',
        'Orchestra simfonică grupează instrumentele în patru secțiuni: coarde, suflători de lemn, suflători de alamă și percuție.',
        'Fiecare secțiune are un rol: coardele cântă adesea melodia principală, alama aduce forță, lemnele culoare, iar percuția susține ritmul.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Cum se numesc instrumentele cu coarde, în organologie?',
          options: [
            ExerciseOption(text: 'Aerofone', isCorrect: false),
            ExerciseOption(text: 'Cordofone', isCorrect: true),
            ExerciseOption(text: 'Idiofone', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Din ce secțiune a orchestrei face parte trompeta?',
          options: [
            ExerciseOption(text: 'Coarde', isCorrect: false),
            ExerciseOption(text: 'Suflători de alamă', isCorrect: true),
            ExerciseOption(text: 'Percuție', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce fel de instrument este xilofonul?',
          options: [
            ExerciseOption(text: 'Idiofon', isCorrect: true),
            ExerciseOption(text: 'Cordofon', isCorrect: false),
            ExerciseOption(text: 'Aerofon', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-instrumente-2',
      level: LessonLevel.elevi,
      module: LessonModule.instrumente,
      title: 'Instrumentele orchestrei simfonice',
      summary: 'Cum sunt organizate secțiunile unei orchestre.',
      content: [
        'O orchestră simfonică modernă poate avea peste 80 de muzicieni, împărțiți pe secțiuni: viori I și II, viole, violoncele, contrabași (coarde); flaute, oboaie, clarinete, fagoturi (lemne); corni, trompete, tromboane, tubă (alamă); tobe, timpane, cinele (percuție).',
        'Dirijorul coordonează toate secțiunile, ținând tempoul și echilibrul între instrumente.',
        'Poziția instrumentelor pe scenă nu e întâmplătoare: coardele stau în față, suflătorii în mijloc, percuția în spate - pentru un sunet echilibrat în sală.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Aproximativ câți muzicieni poate avea o orchestră simfonică mare?',
          options: [
            ExerciseOption(text: '10', isCorrect: false),
            ExerciseOption(text: 'Peste 80', isCorrect: true),
            ExerciseOption(text: '3', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Cine coordonează toate secțiunile orchestrei?',
          options: [
            ExerciseOption(text: 'Solistul', isCorrect: false),
            ExerciseOption(text: 'Dirijorul', isCorrect: true),
            ExerciseOption(text: 'Publicul', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-instrumente-1',
      level: LessonLevel.hobby,
      module: LessonModule.instrumente,
      title: 'Recapitulare: familii de instrumente',
      summary: 'Coarde, suflat, percuție - pe scurt.',
      content: [
        'Instrumentele se împart, simplu, în coarde, suflat, percuție și claviaturi - sau, mai tehnic, în cordofone, aerofone, membranofone și idiofone.',
        'Orchestra le grupează pe secțiuni: coarde, lemne, alamă, percuție - fiecare cu rolul ei în sunetul de ansamblu.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce fel de instrument e vioara?',
          options: [
            ExerciseOption(text: 'Cordofon', isCorrect: true),
            ExerciseOption(text: 'Aerofon', isCorrect: false),
            ExerciseOption(text: 'Idiofon', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce secțiune aduce, de obicei, forța sonoră într-o orchestră?',
          options: [
            ExerciseOption(text: 'Alama', isCorrect: true),
            ExerciseOption(text: 'Coardele', isCorrect: false),
            ExerciseOption(text: 'Percuția ușoară', isCorrect: false),
          ],
        ),
      ],
    ),

    // ==================================================================
    // MODUL: URECHE MUZICALĂ
    // ==================================================================
    LessonModel(
      id: 'copii-ureche-1',
      level: LessonLevel.copii,
      module: LessonModule.urecheMuzicala,
      title: 'Sunete înalte și joase',
      summary: 'Cum "citești" înălțimea unui sunet cu urechea.',
      content: [
        'Sunetele pot fi înalte (subțiri, ca ciripitul unei păsări) sau joase (groase, ca vuietul unui camion).',
        'Pe pian, notele din dreapta sună tot mai înalt, iar cele din stânga tot mai jos.',
        'Antrenează-ți urechea: încearcă să ghicești dacă un sunet e mai înalt sau mai jos decât cel dinainte.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Cum sună notele din dreapta pianului?',
          options: [
            ExerciseOption(text: 'Tot mai joase', isCorrect: false),
            ExerciseOption(text: 'Tot mai înalte', isCorrect: true),
            ExerciseOption(text: 'La fel', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Un sunet "gros", ca vuietul unui camion, este...?',
          options: [
            ExerciseOption(text: 'Înalt', isCorrect: false),
            ExerciseOption(text: 'Jos', isCorrect: true),
            ExerciseOption(text: 'Niciuna', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ascultă cele două sunete. Al doilea sunet e mai înalt sau mai jos decât primul?',
          soundCue: SoundCue([CuedNote(-2), CuedNote(8)]),
          options: [
            ExerciseOption(text: 'Mai înalt', isCorrect: true),
            ExerciseOption(text: 'Mai jos', isCorrect: false),
            ExerciseOption(text: 'La fel', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'copii-ureche-2',
      level: LessonLevel.copii,
      module: LessonModule.urecheMuzicala,
      title: 'Tare sau încet?',
      summary: 'Forte și piano - cele două fețe ale volumului.',
      content: [
        'Muzica poate fi cântată tare (forte) sau încet (piano) - în italiană, aceste cuvinte chiar înseamnă asta!',
        'Compozitorii scriu litere ca "f" (forte, tare) și "p" (piano, încet) pe partitură, ca indicații pentru interpreți.',
        'Schimbările de volum dau viață unei piese - o melodie care crește treptat (crescendo) poate crea multă emoție.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce înseamnă "piano" într-o partitură?',
          options: [
            ExerciseOption(text: 'Tare', isCorrect: false),
            ExerciseOption(text: 'Încet', isCorrect: true),
            ExerciseOption(text: 'Rapid', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Cum se numește creșterea treptată a volumului?',
          options: [
            ExerciseOption(text: 'Crescendo', isCorrect: true),
            ExerciseOption(text: 'Portativ', isCorrect: false),
            ExerciseOption(text: 'Sincopă', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ascultă. Al doilea sunet e cântat mai tare sau mai încet decât primul?',
          soundCue: SoundCue([CuedNote(0), CuedNote(0, volume: 0.22)]),
          options: [
            ExerciseOption(text: 'Mai tare', isCorrect: false),
            ExerciseOption(text: 'Mai încet', isCorrect: true),
            ExerciseOption(text: 'La fel', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-ureche-1',
      level: LessonLevel.elevi,
      module: LessonModule.urecheMuzicala,
      title: 'Intervale muzicale simple',
      summary: 'Distanța dintre două note, pe nume.',
      content: [
        'Un interval este distanța dintre două note. Cel mai mic interval din muzica occidentală este semitonul (ex. de la Do la Do#).',
        'Intervalele au nume: secundă (2 note vecine, ex. Do-Re), terță (Do-Mi), cvartă (Do-Fa), cvintă (Do-Sol), octavă (Do-Do, dar mai sus).',
        'Terța este intervalul care dă culoarea unui acord: terța mare sună "vesel", terța mică sună "trist".',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce interval este de la Do la Sol?',
          options: [
            ExerciseOption(text: 'Cvintă', isCorrect: true),
            ExerciseOption(text: 'Terță', isCorrect: false),
            ExerciseOption(text: 'Octavă', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Care este cel mai mic interval din muzica occidentală?',
          options: [
            ExerciseOption(text: 'Octava', isCorrect: false),
            ExerciseOption(text: 'Semitonul', isCorrect: true),
            ExerciseOption(text: 'Cvinta', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce tip de terță dă un sunet "trist" unui acord?',
          options: [
            ExerciseOption(text: 'Mare', isCorrect: false),
            ExerciseOption(text: 'Mică', isCorrect: true),
            ExerciseOption(text: 'Nu contează', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ascultă intervalul. Ce interval tocmai ai auzit?',
          soundCue: SoundCue([CuedNote(-2), CuedNote(2)]),
          options: [
            ExerciseOption(text: 'Cvintă', isCorrect: true),
            ExerciseOption(text: 'Secundă', isCorrect: false),
            ExerciseOption(text: 'Octavă', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-ureche-2',
      level: LessonLevel.elevi,
      module: LessonModule.urecheMuzicala,
      title: 'Gamă majoră vs. gamă minoră, la ureche',
      summary: 'Cum deosebești major de minor doar ascultând.',
      content: [
        'Gama majoră sună, de obicei, veselă și luminoasă, în timp ce gama minoră sună mai tristă sau misterioasă.',
        'Diferența stă în treapta a treia: în major e mai "înaltă" (terță mare), în minor mai "joasă" (terță mică) față de prima notă.',
        'Cu puțin exercițiu, poți ghici doar din ascultare dacă o melodie e în gamă majoră sau minoră.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Cum sună, de obicei, o melodie în gamă majoră?',
          options: [
            ExerciseOption(text: 'Tristă', isCorrect: false),
            ExerciseOption(text: 'Veselă/luminoasă', isCorrect: true),
            ExerciseOption(text: 'Fără sunet', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce treaptă face diferența dintre major și minor?',
          options: [
            ExerciseOption(text: 'A treia', isCorrect: true),
            ExerciseOption(text: 'A cincea', isCorrect: false),
            ExerciseOption(text: 'Prima', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ascultă gama. Sună majoră sau minoră?',
          soundCue: SoundCue(
            [CuedNote(-2), CuedNote(-1), CuedNote(0), CuedNote(1), CuedNote(2), CuedNote(3), CuedNote(4), CuedNote(5)],
            gapMs: 260,
          ),
          options: [
            ExerciseOption(text: 'Majoră', isCorrect: true),
            ExerciseOption(text: 'Minoră', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-ureche-1',
      level: LessonLevel.hobby,
      module: LessonModule.urecheMuzicala,
      title: 'Recapitulare: intervale și game la ureche',
      summary: 'Intervale și diferența major/minor, pe scurt.',
      content: [
        'Un interval e distanța dintre 2 note (secundă, terță, cvartă, cvintă, octavă etc.) - terța dă culoarea unui acord: mare = vesel, mică = trist.',
        'Gama majoră sună, în general, veselă; cea minoră, mai tristă sau misterioasă - diferența stă în treapta a treia.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce interval e de la Do la Mi?',
          options: [
            ExerciseOption(text: 'Terță', isCorrect: true),
            ExerciseOption(text: 'Cvintă', isCorrect: false),
            ExerciseOption(text: 'Secundă', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce fel de terță dă un sunet vesel unui acord?',
          options: [
            ExerciseOption(text: 'Mică', isCorrect: false),
            ExerciseOption(text: 'Mare', isCorrect: true),
            ExerciseOption(text: 'Nu contează', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ascultă gama. Sună majoră sau minoră?',
          soundCue: SoundCue(
            [CuedNote(-4), CuedNote(-3), CuedNote(-2), CuedNote(-1), CuedNote(0), CuedNote(1), CuedNote(2), CuedNote(3)],
            gapMs: 260,
          ),
          options: [
            ExerciseOption(text: 'Majoră', isCorrect: false),
            ExerciseOption(text: 'Minoră', isCorrect: true),
          ],
        ),
      ],
    ),

    // ==================================================================
    // MODUL: ARMONIE & ACORDURI AVANSAT (Elevi și Hobby)
    // ==================================================================
    LessonModel(
      id: 'elevi-armonie-1',
      level: LessonLevel.elevi,
      module: LessonModule.armonie,
      title: 'Triada minoră și cadențe simple',
      summary: 'Acordul minor și "formula" unui final muzical.',
      content: [
        'O triadă minoră se construiește la fel ca una majoră (treptele 1-3-5), dar cu terță mică - de exemplu, La-Do-Mi este acordul La minor.',
        'O cadență este o "formulă" de final: cea mai comună este cadența perfectă, V-I (de exemplu Sol major - Do major), care dă senzația de încheiere.',
        'Progresia I-IV-V-I este poate cea mai folosită succesiune de acorduri din muzica populară, regăsită în mii de cântece.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Din ce note e format acordul La minor?',
          options: [
            ExerciseOption(text: 'La-Do-Mi', isCorrect: true),
            ExerciseOption(text: 'La-Do#-Mi', isCorrect: false),
            ExerciseOption(text: 'La-Re-Fa', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce cadență dă senzația cea mai puternică de final?',
          options: [
            ExerciseOption(text: 'I-V', isCorrect: false),
            ExerciseOption(text: 'V-I', isCorrect: true),
            ExerciseOption(text: 'II-III', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce progresie de acorduri este extrem de folosită în muzica populară?',
          options: [
            ExerciseOption(text: 'I-IV-V-I', isCorrect: true),
            ExerciseOption(text: 'III-VII-II', isCorrect: false),
            ExerciseOption(text: 'Doar acorduri diminuate', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'elevi-armonie-2',
      level: LessonLevel.elevi,
      module: LessonModule.armonie,
      title: 'Acordul de septimă dominantă',
      summary: 'Acordul cu tensiune care "cere" rezolvare.',
      content: [
        'Acordul de septimă dominantă se construiește adăugând o septimă mică peste o triadă majoră (ex. Sol-Si-Re-Fa, pornind din Sol major).',
        'El creează o tensiune puternică ce "cere" rezolvare spre acordul de tonică (ex. Sol7 rezolvă natural spre Do major).',
        'Este unul dintre cele mai importante acorduri din armonia clasică și din blues/jazz.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce se adaugă unei triade majore pentru a forma un acord de septimă dominantă?',
          options: [
            ExerciseOption(text: 'O septimă mare', isCorrect: false),
            ExerciseOption(text: 'O septimă mică', isCorrect: true),
            ExerciseOption(text: 'O cvintă mărită', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Spre ce acord "cere" să rezolve, de obicei, un Sol7?',
          options: [
            ExerciseOption(text: 'Do major', isCorrect: true),
            ExerciseOption(text: 'Re minor', isCorrect: false),
            ExerciseOption(text: 'Fa# diminuat', isCorrect: false),
          ],
        ),
      ],
    ),
    LessonModel(
      id: 'hobby-armonie-1',
      level: LessonLevel.hobby,
      module: LessonModule.armonie,
      title: 'Recapitulare: acorduri și cadențe',
      summary: 'Major vs. minor și cadența cea mai comună.',
      content: [
        'Triada majoră (1-3-5, terță mare) sună vesel; triada minoră (terță mică) sună mai trist.',
        'Cadența V-I dă cea mai puternică senzație de final, iar progresia I-IV-V-I e nucleul a mii de cântece populare.',
      ],
      exercises: [
        ExerciseModel(
          question: 'Ce diferențiază un acord minor de unul major?',
          options: [
            ExerciseOption(text: 'Terța', isCorrect: true),
            ExerciseOption(text: 'Cvinta', isCorrect: false),
            ExerciseOption(text: 'Octava', isCorrect: false),
          ],
        ),
        ExerciseModel(
          question: 'Ce progresie e extrem de comună în muzica populară?',
          options: [
            ExerciseOption(text: 'I-IV-V-I', isCorrect: true),
            ExerciseOption(text: 'Doar acorduri diminuate', isCorrect: false),
            ExerciseOption(text: 'Nu există progresii comune', isCorrect: false),
          ],
        ),
      ],
    ),
  ];

  static List<LessonModel> byLevel(LessonLevel level) => all.where((l) => l.level == level).toList();

  static LessonModel byId(String id) => all.firstWhere((l) => l.id == id);
}
