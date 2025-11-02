import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum _GameState { playing, over }

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // ===== 튜닝 =====
  static const double MONSTER_START_GAP   = 520.0; // 시작 간격
  static const double MONSTER_BASE_SPEED  = 170.0; // 괴물 기본 속도(시작)
  static const double MONSTER_ACCEL_PER_SEC = 0.35; // 초당 가속(+px/s)
  static const double MONSTER_SPEED_MAX   = 280.0; // 괴물 최대 속도(캡)
  static const double MONSTER_GRACE_SEC   = 1.0;   // 시작 직후 충돌 무시 시간

  // 발판/갭 판정
  static const double EDGE_MARGIN         = 1.0;   // 발판 가장자리 여유(접지/갭 판정)

  // 아이템(기호) 드랍/픽업 튜닝
  static const double SPAWN_Y = 460.0;             // 생성 높이(지면 기준)
  static const double AHEAD_MIN = 180.0;           // 예측 스폰: 최소 앞쪽 거리
  static const double AHEAD_MAX = 340.0;           // 예측 스폰: 최대 앞쪽 거리
  static const double SCREEN_MARGIN = 28.0;        // 화면 가장자리 여유
  static const double DROP_GRAVITY_FACTOR = 0.55;  // 낙하 가속 비율
  static const double PICKUP_HITBOX_SCALE_X = 0.65;// 픽업 판정 가로 확대
  static const double PICKUP_HITBOX_SCALE_Y = 0.80;// 픽업 판정 세로 확대

  // 기호(아이템) 원형 뱃지 컬러 팔레트
  static const List<Color> FALLER_COLORS = <Color>[
    Color(0xFFFFD54F), // Amber 300 (노란)
    Color(0xFF81C784), // Green 300
    Color(0xFF64B5F6), // Blue 300
    Color(0xFFFF8A65), // Deep Orange 300
  ];

  // 세션/배너
  late DateTime _sessionStart;
  Timer? _sessionTimer;
  Duration _elapsed = Duration.zero;
  int _lastTenMinuteNotified = 0;
  bool _bannerShowing = false;

  // 플레이어/물리
  double px = 80, py = 0;
  double vx = 0, vy = 0;
  double playerW = 36, playerH = 48;
  double leftSpeed  = 240; // 살짝 상향
  double rightSpeed = 260; // 살짝 상향
  double gravity = 1500, jumpPower = 720;
  bool _grounded = true;

  // 입력
  bool movingLeft = false, movingRight = false;

  // 카메라
  double camX = 0, viewW = 360;

  // 괴물
  double monsterX = -140;
  double monsterW = 40, monsterH = 50;
  double _monsterGrace = MONSTER_GRACE_SEC;
  double _monsterSpeed = MONSTER_BASE_SPEED; // 시간 경과에 따라 증가

  // 지형/아이템
  final List<_Seg> ground = [];
  final List<_Faller> fallers = [];
  late Random _rand;

  // 루프
  late final Ticker _ticker;
  DateTime _last = DateTime.now();

  // 상태/점수
  _GameState _state = _GameState.playing;
  int _startupFrames = 6;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _rand = Random(DateTime.now().microsecondsSinceEpoch);
    _buildStage();

    _sessionStart = DateTime.now();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed = DateTime.now().difference(_sessionStart));
      _maybeShowTenMinuteBanner();
    });

    _ticker = createTicker((_) {
      final now = DateTime.now();
      final dt = now.difference(_last).inMicroseconds / 1e6;
      _last = now;
      if (dt > 0) _step(dt);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  // ===== 10분 배너 =====
  void _maybeShowTenMinuteBanner() {
    final bucket = _elapsed.inMinutes ~/ 10;
    if (bucket >= 1 && bucket != _lastTenMinuteNotified && !_bannerShowing) {
      _lastTenMinuteNotified = bucket;
      _showTopBanner('게임 시작한 지 ${bucket * 10}분이 지났습니다');
    }
  }

  void _showTopBanner(String msg) async {
    if (!mounted) return;
    _bannerShowing = true;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFEFF6FF),
        leading: const Icon(Icons.info_outline),
        actions: const [],
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    messenger.clearMaterialBanners();
    _bannerShowing = false;
  }

  // ===== 스테이지 구성 =====
  void _buildStage() {
    _state = _GameState.playing;
    _startupFrames = 6;
    _monsterGrace = MONSTER_GRACE_SEC;

    ground.clear();
    fallers.clear();
    score = 0;
    vx = 0; vy = 0; px = 80; py = 0; _grounded = true;

    // 점프 최대 수평 도달거리(안전마진 0.8) - 좌/우 중 큰 값 사용
    final double maxHorizSpeed = max(leftSpeed, rightSpeed).toDouble();
    final double maxJumpReach = maxHorizSpeed * ((jumpPower * 2.0 / gravity)) * 0.8;

    // 발판/갭 생성(가변 폭 + 점프 가능 범위 내 갭)
    double x = -40;
    for (int i = 0; i < 90; i++) {
      final bool longPlat = _rand.nextDouble() < 0.2;
      final double segW = (longPlat ? 240 + _rand.nextInt(220)
          : 140 + _rand.nextInt(180)).toDouble();
      ground.add(_Seg(x: x, w: segW));
      x += segW;

      final double maxGap = max(90.0, min(maxJumpReach * 0.9, 170.0));
      final double minGap = 60.0;
      final double gapW = minGap + _rand.nextDouble() * (maxGap - minGap);
      x += gapW;
    }

    if (ground.isNotEmpty) {
      px = ground.first.x + min(ground.first.w * 0.6, 140.0);
      py = 0; vy = 0; _grounded = true;
    }
    camX = 0;

    monsterX = px - MONSTER_START_GAP;
    _monsterSpeed = MONSTER_BASE_SPEED; // 재시작 시 초기화
  }

  // ===== 접지/갭 판정 =====
  // 중심이 단일 발판 내부에 있어야 접지로 인정
  bool _hasCenterSupport(double xCenter) {
    for (final s in ground) {
      final double left  = s.x + EDGE_MARGIN;
      final double right = s.x + s.w - EDGE_MARGIN;
      if (xCenter >= left && xCenter <= right) return true;
    }
    return false;
  }

  // startX -> endX 이동 경로가 어떤 갭과 겹치면 첫 히트 위치 반환(없으면 null)
  double? _firstGapHitOnPath(double startX, double endX) {
    if (ground.length < 2) return null;
    final double a = min(startX, endX);
    final double b = max(startX, endX);

    for (int i = 0; i < ground.length - 1; i++) {
      final _Seg s  = ground[i];
      final _Seg s2 = ground[i + 1];
      final double gL = s.x + s.w + EDGE_MARGIN;
      final double gR = s2.x - EDGE_MARGIN;
      if (gR <= gL) continue; // 실제 갭 없음(붙거나 겹침)
      if (b >= gL && a <= gR) {
        final bool toRight = endX >= startX;
        return toRight ? max(a, gL) : min(b, gR);
      }
    }
    return null;
  }

  // ===== 입력 =====
  void _jump() {
    if (_state != _GameState.playing) return;
    if (_grounded) vy = jumpPower; // 접지일 때만
  }

  // ===== 루프 =====
  void _step(double dt) {
    if (!mounted || _state != _GameState.playing) return;

    // 좌우 이동
    vx = 0;
    if (movingLeft)  vx -= leftSpeed;
    if (movingRight) vx += rightSpeed;

    final double startX = px;
    px += vx * dt;

    // 수직
    vy -= gravity * dt;
    py += vy * dt;

    // 시작 스냅
    if (_startupFrames > 0) {
      _startupFrames--;
      if (_hasCenterSupport(px)) { py = 0; vy = 0; }
    }

    // 경로-갭 교차로 "그냥 통과" 금지
    if (py <= 0 && vy <= 0) {
      final hit = _firstGapHitOnPath(startX, px);
      if (hit != null) {
        px = hit;
        _grounded = false;
      }
    }

    // 최종 접지 판정 & 스냅
    if (py <= 0 && vy <= 0 && _hasCenterSupport(px)) {
      py = 0; vy = 0; _grounded = true;
    } else {
      _grounded = false;
    }

    // 카메라
    camX = max(0.0, px - viewW * 0.5);

    // 괴물 속도 점점 상승
    _monsterSpeed += MONSTER_ACCEL_PER_SEC * dt;
    if (_monsterSpeed > MONSTER_SPEED_MAX) _monsterSpeed = MONSTER_SPEED_MAX;

    // 괴물 이동(일정 방향 전진)
    if (_monsterGrace > 0) {
      _monsterGrace -= dt;
      final double want = px - MONSTER_START_GAP;
      if (monsterX < want) {
        monsterX += _monsterSpeed * dt;
        if (monsterX > want) monsterX = want;
      }
    } else {
      monsterX += _monsterSpeed * dt;
    }

    // 화면 왼쪽에서 안 사라지게
    final double leftClamp = camX - 10.0;
    if (monsterX < leftClamp) monsterX = leftClamp;

    // 아이템
    _tickFallers(dt);

    // 게임오버
    if (_monsterGrace <= 0) {
      if (py < -160) {
        _gameOver('구멍에 떨어졌어요!');
        return;
      }
      final double mRight = monsterX + monsterW;
      final double pLeft  = px - playerW / 2;
      if (mRight >= pLeft) {
        _gameOver('괴물에게 잡혔어요!');
        return;
      }
    }

    setState(() {});
  }

  void _tickFallers(double dt) {
    final double left = camX, right = camX + viewW;

    // === 예측 스폰: 플레이어가 도달할 자리 근처에 떨어뜨림 ===
    if (_rand.nextDouble() < 0.010) {
      // 낙하 시간 계산 (등가속도: v0=0, y=SPAWN_Y -> 0)
      final double a = gravity * DROP_GRAVITY_FACTOR; // >0
      final double tFall = sqrt((2.0 * SPAWN_Y) / a); // 대략 1초 안팎

      // 플레이어 진행 방향/속도 추정
      final double dirSpeed = movingRight
          ? rightSpeed
          : (movingLeft ? -leftSpeed : 0.0);

      // 플레이어가 tFall 동안 이동할 위치 근방 + 랜덤 오프셋으로 스폰
      double sx = px + (dirSpeed * tFall)
          + (dirSpeed >= 0
              ? (AHEAD_MIN + _rand.nextDouble() * (AHEAD_MAX - AHEAD_MIN))
              : -(AHEAD_MIN + _rand.nextDouble() * (AHEAD_MAX - AHEAD_MIN)));

      // 정지 상태면 화면 우측 60~85% 구간에 스폰(살짝 앞쪽 느낌)
      if (dirSpeed.abs() < 1e-3) {
        final double sxScreen = left + viewW * (0.60 + _rand.nextDouble() * 0.25);
        sx = sxScreen;
      }

      // 화면 안쪽으로 클램프
      final double sxClampLeft  = left + SCREEN_MARGIN;
      final double sxClampRight = right - SCREEN_MARGIN;
      if (sx < sxClampLeft)  sx = sxClampLeft;
      if (sx > sxClampRight) sx = sxClampRight;

      // 실제 생성(색상은 팔레트에서 랜덤)
      const symbols = ['π','Σ','∫','√','∞','∑','θ','±','≈','≡','÷','×','%','∂','λ','µ'];
      final color = FALLER_COLORS[_rand.nextInt(FALLER_COLORS.length)];
      fallers.add(_Faller(
        x: sx,
        y: SPAWN_Y,
        vy: 0,
        sym: symbols[_rand.nextInt(symbols.length)],
        color: color,
      ));
    }

    // === 낙하 업데이트 ===
    for (final f in fallers) {
      f.vy -= gravity * DROP_GRAVITY_FACTOR * dt;
      f.y  += f.vy * dt;
    }

    // === 픽업/소멸 ===
    fallers.removeWhere((f) {
      final double dx = (px - f.x).abs();
      final double dy = ((py + playerH * 0.6) - f.y).abs();
      final bool hit = dx <= (playerW * PICKUP_HITBOX_SCALE_X)
          && dy <= (playerH * PICKUP_HITBOX_SCALE_Y);
      if (hit) { score += 1; return true; }
      return f.y <= -40;
    });
  }

  void _gameOver(String reason) {
    if (_state == _GameState.over) return;
    _state = _GameState.over;

    String _fmt(Duration d) =>
        '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('게임오버'),
        content: Text('$reason\n점수: $score\n생존: ${_fmt(_elapsed)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _rand = Random(DateTime.now().microsecondsSinceEpoch);
              _sessionStart = DateTime.now();
              _elapsed = Duration.zero;
              _buildStage(); // (_monsterSpeed 초기화 포함)
              setState(() {});
            },
            child: const Text('다시 시작'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String mm = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String ss = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: Text('MathRun ⏱ $mm:$ss   ⭐$score')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, c) {
            viewW = c.maxWidth;
            return CustomPaint(
              painter: _WorldPainter(
                camX: camX,
                px: px, py: py, pw: playerW, ph: playerH,
                ground: ground,
                fallers: fallers,
                monsterX: monsterX, monsterW: monsterW, monsterH: monsterH,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 12, right: 12, bottom: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: _HoldButton(
                            icon: Icons.arrow_left, label: 'LEFT',
                            onHoldStart: () => movingLeft = true,
                            onHoldEnd:   () => movingLeft = false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _jump,
                              icon: const Icon(Icons.keyboard_arrow_up),
                              label: const Text('JUMP'),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _HoldButton(
                            icon: Icons.arrow_right, label: 'RIGHT',
                            onHoldStart: () => movingRight = true,
                            onHoldEnd:   () => movingRight = false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===== 데이터 =====
class _Seg { final double x, w; const _Seg({required this.x, required this.w}); }

class _Faller {
  double x, y, vy;
  final String sym;
  final Color color;
  _Faller({
    required this.x,
    required this.y,
    required this.vy,
    required this.sym,
    required this.color,
  });
}

// ===== 길게 누르는 버튼 =====
class _HoldButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onHoldStart, onHoldEnd;
  const _HoldButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onHoldStart,
    required this.onHoldEnd,
  });
  @override
  State<_HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<_HoldButton> {
  bool _pressed = false;
  void _start(){ if(_pressed) return; _pressed = true; widget.onHoldStart(); }
  void _end(){ if(!_pressed) return; _pressed = false; widget.onHoldEnd(); }
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _start(),
      onPointerUp: (_) => _end(),
      onPointerCancel: (_) => _end(),
      child: SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(widget.icon),
          label: Text(widget.label),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

// ===== 렌더러 =====
class _WorldPainter extends CustomPainter {
  final double camX;
  final double px, py, pw, ph;
  final List<_Seg> ground;
  final List<_Faller> fallers;
  final double monsterX, monsterW, monsterH;

  _WorldPainter({
    required this.camX,
    required this.px, required this.py, required this.pw, required this.ph,
    required this.ground, required this.fallers,
    required this.monsterX, required this.monsterW, required this.monsterH,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 배경
    final sky = Paint()..color = const Color(0xFFEFF3FF);
    final base = Paint()..color = const Color(0xFFDBEAFE);
    canvas.drawRect(Offset.zero & size, sky);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 80, size.width, 80), base);

    // 배경 별
    final rnd = Random(5);
    final star = Paint()..color = Colors.white70;
    for (int i = 0; i < 40; i++) {
      final sx = rnd.nextDouble() * size.width;
      final sy = rnd.nextDouble() * (size.height - 140);
      canvas.drawCircle(Offset(sx, sy), 1.4, star);
    }

    // 좌표 변환
    double wx(double worldX) => worldX - camX;
    double wy(double worldY) => size.height - 80 - worldY;

    // 발판
    final segPaint = Paint()..color = const Color(0xFF9EB8FF);
    for (final s in ground) {
      final rect = Rect.fromLTWH(wx(s.x), wy(0) - 16, s.w, 16);
      if (rect.right >= 0 && rect.left <= size.width) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          segPaint,
        );
      }
    }

    // 아이템(기호) - 노란(등) 원형 뱃지 + 글자
    for (final f in fallers) {
      final dx = wx(f.x), dy = wy(f.y);
      if (dx >= -40 && dx <= size.width + 40) {
        // 원형 배경
        final r = 16.0;
        final circlePaint = Paint()..color = f.color; // 팔레트에서 고른 컬러
        canvas.drawCircle(Offset(dx, dy), r, circlePaint);

        // 기호 텍스트
        final tp = TextPainter(
          text: TextSpan(
            text: f.sym,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(dx - tp.width / 2, dy - tp.height / 2));
      }
    }

    // 괴물
    final mx = wx(monsterX);
    final mr = Rect.fromLTWH(mx, wy(0) - monsterH, monsterW, monsterH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(mr, const Radius.circular(8)),
      Paint()..color = Colors.black87,
    );

    // 플레이어
    final pxLeft = wx(px) - pw / 2;
    final pr = Rect.fromLTWH(pxLeft, wy(py) - ph, pw, ph);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pr, const Radius.circular(8)),
      Paint()..color = const Color(0xFF22C55E),
    );
  }

  @override
  bool shouldRepaint(covariant _WorldPainter old) {
    return old.camX != camX ||
        old.px != px || old.py != py ||
        old.fallers.length != fallers.length ||
        old.monsterX != monsterX ||
        old.ground.length != ground.length;
  }
}
