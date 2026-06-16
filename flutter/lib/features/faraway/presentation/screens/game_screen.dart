import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';

const _colFixedWidth = 48.0;
const _colPlayerMinWidth = 88.0;
const _rowHeight = 56.0;

const _colorBackground = Color(0xFFFAF8F5);
const _colorBorder = Color(0xFFBBBBBB);
const _colorSanctuary = Color(0xFFEEE8DC);
const _colorTotal = Color(0xFFD0360A);
const _colorHeader = Color(0xFFF0EBE0);

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late final ScrollController _leftScroll;
  late final ScrollController _rightScroll;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _leftScroll = ScrollController();
    _rightScroll = ScrollController();
    _leftScroll.addListener(() => _sync(_leftScroll, _rightScroll));
    _rightScroll.addListener(() => _sync(_rightScroll, _leftScroll));
  }

  void _sync(ScrollController source, ScrollController target) {
    if (_syncing) return;
    _syncing = true;
    if (target.hasClients) target.jumpTo(source.offset);
    _syncing = false;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _leftScroll.dispose();
    _rightScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(currentGameProvider);
    if (game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final notifier = ref.read(currentGameProvider.notifier);
    final players = game.players;
    final writable = !game.finished;

    return Scaffold(
      appBar: AppBar(title: const Text('Feuille de score')),
      backgroundColor: _colorBackground,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colPlayerWidth = ((constraints.maxWidth - _colFixedWidth) / players.length)
                    .clamp(_colPlayerMinWidth, double.infinity);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Colonne sticky gauche ──────────────────────────────
                    SizedBox(
                      width: _colFixedWidth,
                      child: Column(
                        children: [
                          // Header — hauteur calquée sur la ligne joueurs
                          _FixedHeaderCell(
                            color: _colorHeader,
                            child: Image.asset('assets/images/icone-jeu.png', width: 32, height: 32),
                          ),
                          // Lignes numérotées
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _leftScroll,
                              child: Column(
                                children: [
                                  ...List.generate(farawayNumberOfRows - 1, (i) => _FixedCell(
                                    borderTop: true,
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                                    ),
                                  )),
                                  // Sanctuaire
                                  _FixedCell(
                                    color: _colorSanctuary,
                                    borderTop: true,
                                    borderTopWidth: 1,
                                    child: Image.asset('assets/images/icone-sanctuaire.png', width: 32, height: 32),
                                  ),
                                  // Total
                                  _FixedCell(
                                    color: _colorTotal,
                                    child: const Text(
                                      'T',
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ── Séparateur ─────────────────────────────────────────
                    Container(width: 0.5, color: _colorBorder),
                    // ── Colonnes joueurs (scrollables) ─────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: colPlayerWidth * players.length,
                          child: Column(
                            children: [
                              // Header noms
                              _PlayerHeaderRow(
                                players: players,
                                colPlayerWidth: colPlayerWidth,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _rightScroll,
                                  child: Column(
                                    children: [
                                      ...List.generate(farawayNumberOfRows, (i) {
                                        final isLast = i == farawayNumberOfRows - 1;
                                        return _ScoreRow(
                                          row: i,
                                          players: players,
                                          game: game,
                                          writable: writable,
                                          notifier: notifier,
                                          colPlayerWidth: colPlayerWidth,
                                          isSanctuary: isLast,
                                        );
                                      }),
                                      _TotalRow(
                                        players: players,
                                        game: game,
                                        colPlayerWidth: colPlayerWidth,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: writable
                  ? () async {
                      await notifier.endGame();
                      if (context.mounted) Navigator.pop(context);
                    }
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: _colorTotal,
              ),
              child: const Text('Partie terminée'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cellule fixe header (hauteur flexible) ────────────────────────────────────

class _FixedHeaderCell extends StatelessWidget {
  final Widget child;
  final Color? color;

  const _FixedHeaderCell({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _colFixedWidth,
      constraints: const BoxConstraints(minHeight: _rowHeight),
      decoration: BoxDecoration(
        color: color,
        border: const Border(bottom: BorderSide(color: _colorBorder, width: 0.5)),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Cellule fixe gauche ───────────────────────────────────────────────────────

class _FixedCell extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool borderTop;
  final double borderTopWidth;

  const _FixedCell({
    required this.child,
    this.color,
    this.borderTop = false,
    this.borderTopWidth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _colFixedWidth,
      height: _rowHeight,
      decoration: BoxDecoration(
        color: color,
        border: Border(
          top: borderTop ? BorderSide(color: _colorBorder, width: borderTopWidth) : BorderSide.none,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Header noms joueurs ───────────────────────────────────────────────────────

class _PlayerHeaderRow extends StatelessWidget {
  final List<Player> players;
  final double colPlayerWidth;

  const _PlayerHeaderRow({
    required this.players,
    required this.colPlayerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        color: _colorHeader,
        constraints: const BoxConstraints(minHeight: _rowHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: players.map(
            (p) => _Cell(
              width: colPlayerWidth,
              borderRight: p != players.last,
              borderBottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  p.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}

// ── Ligne de score ────────────────────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  final int row;
  final List<Player> players;
  final FarawayGame game;
  final bool writable;
  final CurrentGame notifier;
  final double colPlayerWidth;
  final bool isSanctuary;

  const _ScoreRow({
    required this.row,
    required this.players,
    required this.game,
    required this.writable,
    required this.notifier,
    required this.colPlayerWidth,
    required this.isSanctuary,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSanctuary ? _colorSanctuary : _colorBackground;
    return Container(
      height: _rowHeight,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: _colorBorder, width: isSanctuary ? 1 : 0.5),
        ),
      ),
      child: Row(
        children: players.map(
          (p) => _Cell(
            width: colPlayerWidth,
            borderRight: p != players.last,
            color: bg,
            child: _ScoreInput(
              key: ValueKey('${p.id}-$row'),
              playerId: p.id,
              row: row,
              score: game.scores[p.id]?[row],
              writable: writable,
              notifier: notifier,
            ),
          ),
        ).toList(),
      ),
    );
  }
}

// ── Ligne total ───────────────────────────────────────────────────────────────

class _TotalRow extends StatelessWidget {
  final List<Player> players;
  final FarawayGame game;
  final double colPlayerWidth;

  const _TotalRow({required this.players, required this.game, required this.colPlayerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _colorTotal,
      height: _rowHeight,
      child: Row(
        children: players.map(
          (p) => _Cell(
            width: colPlayerWidth,
            borderRight: p != players.last,
            borderColor: Colors.white38,
            child: Text(
              game.playerTotal(p.id)?.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
            ),
          ),
        ).toList(),
      ),
    );
  }
}

// ── Input score ───────────────────────────────────────────────────────────────

class _ScoreInput extends StatefulWidget {
  final String playerId;
  final int row;
  final int? score;
  final bool writable;
  final CurrentGame notifier;

  const _ScoreInput({
    super.key,
    required this.playerId,
    required this.row,
    required this.score,
    required this.writable,
    required this.notifier,
  });

  @override
  State<_ScoreInput> createState() => _ScoreInputState();
}

class _ScoreInputState extends State<_ScoreInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.score?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_ScoreInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.score?.toString() ?? '';
    if (_controller.text != newText) {
      _controller.value = _controller.value.copyWith(text: newText);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.writable,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (v) => widget.notifier.setScore(widget.playerId, widget.row, int.tryParse(v)),
    );
  }
}

// ── Cellule générique ─────────────────────────────────────────────────────────

class _Cell extends StatelessWidget {
  final double width;
  final Widget child;
  final bool borderRight;
  final bool borderBottom;
  final Color? color;
  final Color borderColor;

  const _Cell({
    required this.width,
    required this.child,
    this.borderRight = false,
    this.borderBottom = false,
    this.color,
    this.borderColor = _colorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _rowHeight,
      decoration: BoxDecoration(
        color: color,
        border: Border(
          right: borderRight ? BorderSide(color: borderColor, width: 0.5) : BorderSide.none,
          bottom: borderBottom ? BorderSide(color: borderColor, width: 0.5) : BorderSide.none,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
