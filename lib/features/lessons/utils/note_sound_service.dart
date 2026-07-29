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

  /// Player separat pentru efecte scurte de reacţie (corect/greşit/nivel nou),
  /// ca să poată suna chiar dacă o notă e deja în curs de redare pe player-ul
  /// principal (nu vrem ca un răspuns rapid să taie sunetul notei ascultate).
  final AudioPlayer _sfxPlayer = AudioPlayer();

  Future<void> _playSfx(String fileName, {double volume = 0.85}) async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(volume);
      await _sfxPlayer.play(AssetSource('sounds/sfx/$fileName.wav'));
    } catch (_) {
      // La fel ca la notele obişnuite - un eşec de redare nu blochează exerciţiul.
    }
  }

  /// Răspuns corect - clinchet vesel, ascendent.
  Future<void> playCorrect() => _playSfx('sfx_correct');

  /// Răspuns greşit - sunet scurt, blând, fără conotaţie de "eroare gravă"
  /// (copiii nu trebuie descurajaţi de un semnal dur).
  Future<void> playWrong() => _playSfx('sfx_wrong', volume: 0.7);

  /// Nivel nou / lecţie/tărâm finalizat - fanfară scurtă, cu puţină strălucire.
  Future<void> playLevelUp() => _playSfx('sfx_levelup');

  Future<void> stop() => _player.stop();

  void dispose() {
    _player.dispose();
    _sfxPlayer.dispose();
  }
}
