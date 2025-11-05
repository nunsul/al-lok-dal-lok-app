import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ★ NEW: Curves 등 사용

// ─────────────────────────────────────────────────────────────
// 파츠 스펙
class location_login {
  final String assets;
  final double x; // Figma px 기준 목표 X
  final double y; // Figma px 기준 목표 Y
  final double w; // 폭(px) - 높이는 비율로 맞춤

  // ▼▼▼ 애니메이션 옵션 추가 ▼▼▼
  final double fromX;                       // ★ NEW: 시작 오프셋 X(px)
  final double fromY;                       // ★ NEW: 시작 오프셋 Y(px)
  final Duration delay;                     // ★ NEW: 지연
  final Duration dur;                       // ★ NEW: 재생시간
  final Curve curve;                        // ★ NEW: 곡선

  const location_login(
      this.assets, {
        required this.x,
        required this.y,
        required this.w,
        this.fromX = 0,                          // ★ NEW: 기본 0
        this.fromY = 0,                          // ★ NEW: 기본 0
        this.delay = Duration.zero,              // ★ NEW
        this.dur = const Duration(milliseconds: 600), // ★ NEW
        this.curve = Curves.easeOutCubic,        // ★ NEW
      });
}

// ─────────────────────────────────────────────────────────────
// Figma 좌표 → 화면 매핑 + 등장 애니메이션
class Figma_main_body_screen extends StatefulWidget { // ★ CHANGED: Stateless → Stateful
  const Figma_main_body_screen({
    super.key,
    required this.FigmaW,
    required this.FigmaH,
    required this.cover,
    required this.checkFrame,
    required this.parts,
  });

  final double FigmaW;
  final double FigmaH;
  final bool cover;
  final bool checkFrame;
  final List<location_login> parts;

  @override
  State<Figma_main_body_screen> createState() => _Figma_main_body_screenState();
}

class _Figma_main_body_screenState extends State<Figma_main_body_screen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctls;

  @override
  void initState() {
    super.initState();
    _ctls = [
      for (final p in widget.parts)
        AnimationController(vsync: this, duration: p.dur)
    ];
    // 지연 후 재생 //
    for (int i = 0; i < widget.parts.length; i++) {
      final p = widget.parts[i];
      Future.delayed(p.delay, () {
        if (mounted) _ctls[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctls) {
      c.dispose(); // ★ NEW
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, index) {
      // 최대로할지 최소로할지 선택!
      final scale = widget.cover
          ? max(index.maxWidth / widget.FigmaW, index.maxHeight / widget.FigmaH)
          : min(index.maxHeight / widget.FigmaH, index.maxWidth / widget.FigmaW);
      // 캔버스 크기
      final canvasW = widget.FigmaW * scale;
      final canvasH = widget.FigmaH * scale;
      // 실제 중앙 찾기
      final offX = (index.maxWidth - canvasW) / 2;
      final offY = (index.maxHeight - canvasH) / 2;

      // 최종 positioned 사용할 결과
      final List<Widget> result = [];

      for (int i = 0; i < widget.parts.length; i++) {
        final p = widget.parts[i];

        final leftTarget = offX + p.x * scale;
        final topTarget = offY + p.y * scale;
        final w = p.w * scale;

        result.add(AnimatedBuilder(
          animation: _ctls[i],
            builder: (_, __) {
              final raw = _ctls[i].value;                // 0..1
              final posT = p.curve.transform(raw);       // 위치 보간은 커브 적용 (overshoot 허용)
              final fade = raw.clamp(0.0, 1.0);          // ★ NEW: opacity는 항상 0..1로 고정

              final curLeft = leftTarget + (1 - posT) * p.fromX * scale;
              final curTop  = topTarget  + (1 - posT) * p.fromY * scale;

              return Positioned(
                left: curLeft,
                top: curTop,
                child: Opacity(
                  opacity: fade,
                  child: Image.asset(
                    p.assets.trim().replaceAll('"', '').replaceAll("'", ''),
                    width: w,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            }
        ));
      }

      // (선택) 프레임 확인선
      if (widget.checkFrame) {
        result.add(Positioned(
          left: offX,
          top: offY,
          child: IgnorePointer(
            child: Container(
              width: canvasW,
              height: canvasH,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent, width: 2),
              ),
            ),
          ),
        ));
      }

      return Stack(
        clipBehavior: Clip.none,
        children: result,
      );
    });
  }
}
