import 'package:audioplayers/audioplayers.dart';

import '../models/exercise_model.dart';
import '../models/staff_note.dart';

/// Serviciu simplu (singleton) pentru redarea sunetelor de note - folosit atât
/// la exercițiile de citire a notelor de pe portativ (un singur sunet), cât și
/// la exercițiile de "ureche muzicală" (secvențe de note - [SoundCue]).
///
/// Sunetele sunt clipuri scurte, pre-generate (sinteză de pian, La3-La5),
/// aflate în `assets/sounds/notes/<Literă><Octavă>.wav` (ex. `A4.wav`).
class NoteSoundService {
  NoteSoundService._();

  static final NoteSoundService instance = NoteSoundService._();

  final AudioPlayer _player = AudioPlayer();

  /// Redă o singură notă, după poziția ei pe portativ (vezi [TrebleClefNotes]).
  Future<void> playPosition(int position, {double volume = 1.0}) async {
    final file = TrebleClefNotes.audioFileFor(position);
    if (file == null) return;
    try {
      await _player.stop();
      await _player.setVolume(volume.clamp(0.0, 1.0));
      await _player.play(AssetSource('sounds/notes/$file.wav'));
    } catch (_) {
      // Redarea audio nu trebuie să blocheze niciodată un exercițiu - dacă
      // eșuează (ex. platformă neobișnuită), exercițiul rămâne folosibil
      // vizual, doar fără sunet.
    }
  }

  /// Redă o secvență de note, una după alta, cu pauza specificată în [cue].
  Future<void> playCue(SoundCue cue) async {
    for (final note in cue.notes) {
      await playPosition(note.position, volume: note.volume);
      await Future.delayed(Duration(milliseconds: cue.gapMs));
    }
  }

  Future<void> stop() => _player.stop();

  void dispose() => _player.dispose();
}
