import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/providers.dart';

const _colFixedWidth = 64.0;
const _colPlayerMinWidth = 88.0;
const _rowHeight = 56.0;
const _colorBackground = Color(0xFFFAF8F5);
const _colorBorder = Color(0xFFBBBBBB);
const _colorTotal = Color(0xFFD0360A);
const _colorHeader = Color(0xFFF0EBE0);

class GenericGameScreen extends ConsumerStatefulWidget {
  const GenericGameScreen({super.key});

  @override
  ConsumerState<GenericGameScreen> createState() => _GenericGameScreenState();
}

class _GenericGameScreenState extends ConsumerState<GenericGameScreen> {
  final _leftScroll = ScrollController();
  final _rightScroll = ScrollController();
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _leftScroll.addListener(_syncFromLeft);
    _rightScroll.addListener(_syncFromRight);
  }

  void _syncFromLeft() {
    if (_syncing) return;
    _syncing = true;
    _rightScroll.jumpTo(_leftScroll.offset);
    _syncing = false;
  }

  void _syncFromRight() {
    if (_syncing) return;
    _syncing = true;
    _leftScroll.jumpTo(_rightScroll.offset);
    _syncing = false;
  }

  @override
  void dispose() {
    _leftScroll.dispose();
    _rightScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(currentGenericGameProvider);
    if (game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final notifier = ref.read(currentGenericGameProvider.notifier);
    final players = game.players;
    final writable = !game.finished;
    final rounds = game.numberOfRounds;

    return Scaffold(
      appBar: AppBar(title: Text(game.name)),
      backgroundColor: _colorBackground,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colPlayerWidth =
                    ((constraints.maxWidth - _colFixedWidth) / players.length)
                        .clamp(_colPlayerMinWidth, double.infinity);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Colonne sticky gauche ──────────────────────────────
                    SizedBox(
                      width: _colFixedWidth,
                      child: Column(
                        children: [
                          _HeaderCell(label: AppLocalizations.of(context).roundAbbrev, width: _colFixedWidth, height: _rowHeight),
                          Expanded(
                            child: ListView.builder(
                              controller: _leftScroll,
                              itemCount: rounds + 1,
                              itemBuilder: (_, i) {
                                if (i < rounds) {
                                  return _Cell(
                                    label: '${i + 1}',
                                    width: _colFixedWidth,
                                  );
                                }
                                return _Cell(
                                  label: AppLocalizations.of(context).totalLabel,
                                  width: _colFixedWidth,
                                  textColor: _colorTotal,
                                  bold: true,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ── Zone scrollable horizontalement ───────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: colPlayerWidth * players.length,
                          child: Column(
                            children: [
                              // En-tête joueurs
                              Row(
                                children: players
                                    .map((p) => _HeaderCell(
                                          label: p.name,
                                          width: colPlayerWidth,
                                          height: _rowHeight,
                                          isWinner: game.winnerIds.contains(p.id),
                                        ))
                                    .toList(),
                              ),
                              // Lignes de scores
                              Expanded(
                                child: ListView.builder(
                                  controller: _rightScroll,
                                  itemCount: rounds + 1,
                                  itemBuilder: (_, i) {
                                    if (i < rounds) {
                                      return Row(
                                        children: players.map((p) {
                                          return _ScoreInput(
                                            key: ValueKey('${p.id}-$i'),
                                            value: game.scores[p.id]?[i],
                                            width: colPlayerWidth,
                                            enabled: writable,
                                            onChanged: (v) => notifier.setScore(p.id, i, v),
                                          );
                                        }).toList(),
                                      );
                                    }
                                    // Ligne total
                                    return Row(
                                      children: players.map((p) {
                                        final total = game.playerTotal(p.id);
                                        return _Cell(
                                          label: total?.toString() ?? '—',
                                          width: colPlayerWidth,
                                          textColor: _colorTotal,
                                          bold: true,
                                        );
                                      }).toList(),
                                    );
                                  },
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
          // ── Boutons bas ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (writable)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: notifier.addRound,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context).roundLabel),
                    ),
                  ),
                if (writable) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: writable ? _colorTotal : Colors.grey,
                    ),
                    onPressed: writable
                        ? () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) {
                                final ll = AppLocalizations.of(ctx);
                                return AlertDialog(
                                  title: Text(ll.endGameQuestion),
                                  content: Text(ll.scoresLocked),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text(ll.cancel)),
                                    TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: Text(ll.endGameAction)),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) await notifier.endGame();
                          }
                        : null,
                    child: Text(writable
                        ? AppLocalizations.of(context).endGame
                        : AppLocalizations.of(context).gameEnded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final bool isWinner;

  const _HeaderCell({
    required this.label,
    required this.width,
    required this.height,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colorHeader,
        border: Border.all(color: _colorBorder, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isWinner)
            const Icon(Icons.emoji_events, size: 16, color: Color(0xFFB8860B)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String label;
  final double width;
  final Color? textColor;
  final bool bold;

  const _Cell({
    required this.label,
    required this.width,
    this.textColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _rowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: _colorBorder, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ScoreInput extends StatefulWidget {
  final int? value;
  final double width;
  final bool enabled;
  final ValueChanged<int?> onChanged;

  const _ScoreInput({
    super.key,
    required this.value,
    required this.width,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<_ScoreInput> createState() => _ScoreInputState();
}

class _ScoreInputState extends State<_ScoreInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_ScoreInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && widget.value?.toString() != _controller.text) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: _rowHeight,
      decoration: BoxDecoration(border: Border.all(color: _colorBorder, width: 0.5)),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (v) => widget.onChanged(int.tryParse(v)),
      ),
    );
  }
}
