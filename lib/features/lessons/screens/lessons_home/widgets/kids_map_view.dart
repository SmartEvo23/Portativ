import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/music/mascot_widget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../controllers/progress_controller.dart';
import '../../../data/lesson_worlds.dart';
import '../../../data/lessons_data.dart';
import '../../../models/lesson_level.dart';
import '../../../models/lesson_model.dart';
import '../../../models/lesson_module.dart';
import '../../../utils/lesson_unlock.dart';
import '../../lesson_detail/lesson_detail_screen.dart';
import 'world_intro_dialog.dart';

/// Harta de lecții pentru "Copii": o hartă de lume, împărțită pe tărâmuri
/// tematice (câte unul per modul de lecții), fiecare locuit de mascote-
/// companion care cântă sau dansează într-o buclă continuă. Personajul
/// principal (exploratorul) pășește de la un nod la următorul de fiecare
/// dată când copilul termină o lecție, ducând un steguleț pe care îl
/// "plantează" la sosire.
class KidsMapView extends StatefulWidget {
  const KidsMapView({super.key});

  @override
  State<KidsMapView> createState() => _KidsMapViewState();
}

class _KidsMapViewState extends State<KidsMapView> with TickerProviderStateMixin {
  late final AnimationController _walkController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  final ScrollController _scrollController = ScrollController();

  static const double _nodeSpacing = 170;
  static const double _topPadding = 150;
  static const double _bottomPadding = 120;
  static const double _nodeDiameter = 80;
  static const double _labelWidth = 130;

  final List<LessonModel> _lessons = LessonsData.byLevel(LessonLevel.copii);
  late final List<_ModuleBand> _bands = _computeBands(_lessons);
  List<Offset> _positions = [];

  int _explorerIndex = -1;
  bool _walking = false;
  int _walkFrom = 0;
  int _walkTo = 0;
  bool _celebrate = false;
  String? _bubbleText;

  @override
  void dispose() {
    _walkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeAdvance(int frontierIndex) {
    if (!mounted || _positions.isEmpty) return;
    if (_explorerIndex == -1) {
      setState(() {
        _explorerIndex = frontierIndex.clamp(0, _positions.length - 1);
        _bubbleText = frontierIndex == 0 ? 'Hai să pornim în aventură!' : null;
      });
      return;
    }
    if (frontierIndex != _explorerIndex && !_walking) {
      _startWalk(_explorerIndex, frontierIndex.clamp(0, _positions.length - 1));
    }
  }

  Future<void> _startWalk(int from, int to) async {
    if (from == to) return;
    setState(() {
      _walking = true;
      _walkFrom = from;
      _walkTo = to;
      _celebrate = false;
      _bubbleText = 'Bravo! Un pas mai aproape!';
    });
    _scrollToIndex(to);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    await _walkController.forward(from: 0);
    _walkController.value = 0;
    if (!mounted) return;
    setState(() {
      _explorerIndex = to;
      _walking = false;
      _celebrate = true;
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) setState(() => _celebrate = false);
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _bubbleText = null);
    });
  }

  void _scrollToIndex(int index) {
    if (index >= _positions.length || !_scrollController.hasClients) return;
    final target = (_positions[index].dy - 220).clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(target, duration: const Duration(milliseconds: 550), curve: Curves.easeInOut);
  }

  Offset _explorerPos() {
    if (_positions.isEmpty || _explorerIndex == -1) return Offset.zero;
    final safe = _explorerIndex.clamp(0, _positions.length - 1);
    if (!_walking) return _positions[safe];
    final p0 = _positions[_walkFrom.clamp(0, _positions.length - 1)];
    final p1 = _positions[_walkTo.clamp(0, _positions.length - 1)];
    final t = Curves.easeInOut.transform(_walkController.value);
    final base = Offset.lerp(p0, p1, t)!;
    final hop = -22 * math.sin(t * math.pi);
    return base.translate(0, hop);
  }

  static double _bandTop(int index, List<Offset> positions) =>
      index == 0 ? 0 : (positions[index - 1].dy + positions[index].dy) / 2;

  static double _bandBottom(int index, List<Offset> positions, double mapHeight) =>
      index == positions.length - 1 ? mapHeight : (positions[index].dy + positions[index + 1].dy) / 2;

  @override
  Widget build(BuildContext context) {
    final progressController = Get.put(ProgressController());
    final mapHeight = _topPadding + _lessons.length * _nodeSpacing + _bottomPadding;

    return Obx(() {
      final progress = progressController.progress.value.of(LessonLevel.copii);
      final nextIndex = _lessons.indexWhere((l) => !progress.completedLessonIds.contains(l.id));
      final frontierIndex = nextIndex == -1 ? _lessons.length - 1 : nextIndex;

      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAdvance(frontierIndex));

      return Container(
        color: const Color(0xFFBFEAF5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final positions = <Offset>[
              for (var i = 0; i < _lessons.length; i++)
                Offset((i.isEven ? 0.30 : 0.70) * width, _topPadding + i * _nodeSpacing),
            ];
            _positions = positions;

            return SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                width: width,
                height: mapHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // --- Tărâmuri (benzi de teren colorate per modul) ---
                    for (final band in _bands)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: _bandTop(band.start, positions),
                        height: _bandBottom(band.end, positions, mapHeight) - _bandTop(band.start, positions),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: (worldForModule(band.module)?.gradient ?? const [Color(0xFFBFEAF5), Color(0xFFE3F8E1)])
                                  .map((c) => c.withOpacity(0.65))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(child: CustomPaint(painter: _CloudsPainter())),

                    // --- Mascote-companion, locuitorii fiecărui tărâm ---
                    for (final band in _bands) ...[
                      Positioned(
                        left: 12,
                        top: _bandTop(band.start, positions) +
                            (_bandBottom(band.end, positions, mapHeight) - _bandTop(band.start, positions)) * 0.30,
                        child: MascotWidget(
                          size: 44,
                          variant: worldForModule(band.module)?.companionVariant ?? MascotVariant.musician,
                          color: worldForModule(band.module)?.companionColor ?? TColors.secondary,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: _bandTop(band.start, positions) +
                            (_bandBottom(band.end, positions, mapHeight) - _bandTop(band.start, positions)) * 0.68,
                        child: MascotWidget(
                          size: 44,
                          variant: worldForModule(band.module)?.companionVariant ?? MascotVariant.musician,
                          color: worldForModule(band.module)?.companionColor ?? TColors.secondary,
                        ),
                      ),
                    ],

                    CustomPaint(size: Size(width, mapHeight), painter: _PathPainter(positions: positions)),

                    // --- Etichete de tărâm ---
                    for (final band in _bands)
                      Positioned(
                        top: _bandTop(band.start, positions) + 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.88),
                              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Text(
                              worldForModule(band.module)?.title ?? band.module.label,
                              style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.textPrimary),
                            ),
                          ),
                        ),
                      ),

                    // --- Noduri de lecții ---
                    for (var i = 0; i < _lessons.length; i++)
                      Positioned(
                        left: positions[i].dx - _labelWidth / 2,
                        top: positions[i].dy - _nodeDiameter / 2,
                        width: _labelWidth,
                        child: _MapNode(
                          lesson: _lessons[i],
                          index: i,
                          unlocked: isLessonUnlocked(_lessons, i, progress),
                          stars: starsForLesson(_lessons[i].id, progress),
                          diameter: _nodeDiameter,
                        ),
                      ),

                    // --- Exploratorul (mascota principală) ---
                    AnimatedBuilder(
                      animation: _walkController,
                      builder: (context, _) {
                        final pos = _explorerPos();
                        if (pos == Offset.zero && _explorerIndex == -1) return const SizedBox.shrink();
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            if (_bubbleText != null)
                              Positioned(
                                left: (pos.dx - 90).clamp(0.0, width - 180),
                                top: pos.dy - _nodeDiameter / 2 - 118,
                                width: 180,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.92),
                                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))],
                                  ),
                                  child: Text(
                                    _bubbleText!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.textPrimary),
                                  ),
                                ),
                              ),
                            Positioned(
                              left: pos.dx - 30,
                              top: pos.dy - _nodeDiameter / 2 - 66,
                              child: MascotWidget(
                                size: 60,
                                celebrate: _celebrate,
                                carryingFlag: _walking,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _ModuleBand {
  const _ModuleBand(this.module, this.start, this.end);
  final LessonModule module;
  final int start;
  final int end;
}

List<_ModuleBand> _computeBands(List<LessonModel> lessons) {
  if (lessons.isEmpty) return const [];
  final bands = <_ModuleBand>[];
  var start = 0;
  for (var i = 1; i <= lessons.length; i++) {
    if (i == lessons.length || lessons[i].module != lessons[start].module) {
      bands.add(_ModuleBand(lessons[start].module, start, i - 1));
      start = i;
    }
  }
  return bands;
}

class _MapNode extends StatelessWidget {
  const _MapNode({
    required this.lesson,
    required this.index,
    required this.unlocked,
    required this.stars,
    required this.diameter,
  });

  final LessonModel lesson;
  final int index;
  final bool unlocked;
  final int stars;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final passed = stars > 0;
    final Color fillColor = !unlocked
        ? TColors.darkGrey.withOpacity(0.55)
        : passed
            ? TColors.success
            : TColors.primary;

    final circle = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      alignment: Alignment.center,
      child: unlocked
          ? Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))
          : const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: unlocked
              ? () => showWorldIntroIfNeeded(
                    context,
                    lesson.module,
                    () => Get.to(() => LessonDetailScreen(lessonId: lesson.id)),
                  )
              : () => TLoaders.warningSnackBar(title: 'Lecție blocată', message: 'Termină mai întâi lecția anterioară.'),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              circle,
              if (passed)
                const Positioned(
                  right: -6,
                  top: -8,
                  child: Icon(Icons.flag_rounded, color: Colors.redAccent, size: 22),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          lesson.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.textPrimary),
        ),
        if (unlocked) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 16,
                color: i < stars ? Colors.amber : Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Desenează cărarea șerpuită, punctată, care leagă lecțiile între ele.
class _PathPainter extends CustomPainter {
  _PathPainter({required this.positions});

  final List<Offset> positions;

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;

    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (var i = 1; i < positions.length; i++) {
      final p0 = positions[i - 1];
      final p1 = positions[i];
      final midY = (p0.dy + p1.dy) / 2;
      path.cubicTo(p0.dx, midY, p1.dx, midY, p1.dx, p1.dy);
    }

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(_dashPath(path), paint);
  }

  Path _dashPath(Path source, {double dashLength = 16, double gapLength = 12}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : gapLength;
        final next = math.min(distance + length, metric.length);
        if (draw) dashed.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next;
        draw = !draw;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) => oldDelegate.positions != positions;
}

/// Norișori decorativi, desenați simplu (fără imagini externe).
class _CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.4);
    final centers = [
      Offset(size.width * 0.5, 24),
      Offset(size.width * 0.18, 250),
      Offset(size.width * 0.82, 420),
      Offset(size.width * 0.15, 600),
      Offset(size.width * 0.85, 780),
      Offset(size.width * 0.20, 960),
      Offset(size.width * 0.80, 1140),
    ];
    for (final c in centers) {
      if (c.dy > size.height) continue;
      canvas.drawCircle(c, 22, paint);
      canvas.drawCircle(c + const Offset(18, 6), 15, paint);
      canvas.drawCircle(c + const Offset(-18, 6), 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CloudsPainter oldDelegate) => false;
}
