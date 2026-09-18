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
const _colorWinner = Color(0xFFFFF8DC);
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

  Widget _buildRightZone(BuildContext context, dynamic game, double colW, int rounds, bool writable, dynamic notifier) {
    if (game.hasTeams as bool) {
      return _buildTeamZone(context, game, colW, rounds, writable, notifier);
    }
    final players = game.players as List;
    final totalWidth = colW * players.length;
    return SizedBox(
      width: totalWidth,
      child: Column(
        children: [
          Row(
            children: players.map<Widget>((p) => _HeaderCell(
              label: p.name as String,
              width: colW,
              height: _rowHeight,
              isWinner: (game.winnerIds as List).contains(p.id),
            )).toList(),
          ),
          Expanded(
            child: ListView.builder(
              controller: _rightScroll,
              itemCount: rounds + 1,
              itemBuilder: (_, i) {
                if (i < rounds) {
                  return Row(
                    children: players.map<Widget>((p) {
                      final isWinner = (game.winnerIds as List).contains(p.id);
                      return _ScoreInput(
                        key: ValueKey('${p.id}-$i'),
                        value: (game.scores as Map)[p.id]?[i] as int?,
                        width: colW,
                        enabled: writable,
                        bgColor: isWinner ? _colorWinner : _colorBackground,
                        onChanged: (v) => notifier.setScore(p.id as String, i, v),
                      );
                    }).toList(),
                  );
                }
                return Row(
                  children: players.map<Widget>((p) {
                    final total = game.playerTotal(p.id as String) as int?;
                    final isWinner = (game.winnerIds as List).contains(p.id);
                    return _Cell(
                      label: total?.toString() ?? '—',
                      width: colW,
                      textColor: isWinner ? const Color(0xFFDAA520) : _colorTotal,
                      bold: true,
                      bgColor: isWinner ? _colorWinner : null,
                      accentBorder: isWinner,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamZone(BuildContext context, dynamic game, double colW, int rounds, bool writable, dynamic notifier) {
    final teams = game.teams as List;
    final orderedPlayers = teams.expand<dynamic>((t) => game.playersForTeam(t.id as String) as List).toList();
    final totalWidth = colW * orderedPlayers.length;

    List<Widget> buildScoreRow(int i) => teams.expand<Widget>((team) {
      final teamPlayers = game.playersForTeam(team.id as String) as List;
      return teamPlayers.map((p) {
        final isWinner = (game.winnerIds as List).contains(p.id);
        return _ScoreInput(
          key: ValueKey('${p.id}-$i'),
          value: (game.scores as Map)[p.id]?[i] as int?,
          width: colW,
          enabled: writable,
          bgColor: isWinner ? _colorWinner : _colorBackground,
          onChanged: (v) => notifier.setScore(p.id as String, i, v),
        );
      });
    }).toList();

    List<Widget> buildPlayerTotalRow() => teams.expand<Widget>((team) {
      final teamPlayers = game.playersForTeam(team.id as String) as List;
      return teamPlayers.map((p) {
        final total = game.playerTotal(p.id as String) as int?;
        final isWinner = (game.winnerIds as List).contains(p.id);
        return _Cell(
          label: total?.toString() ?? '—',
          width: colW,
          textColor: isWinner ? const Color(0xFFDAA520) : _colorTotal,
          bold: true,
          bgColor: isWinner ? _colorWinner : null,
          accentBorder: isWinner,
        );
      });
    }).toList();

    List<Widget> buildTeamTotalRow() => teams.map<Widget>((team) {
      final teamPlayers = game.playersForTeam(team.id as String) as List;
      final isTeamWinner = teamPlayers.any((p) => (game.winnerIds as List).contains(p.id));
      final teamTot = game.teamTotal(team.id as String) as int?;
      return _Cell(
        label: teamTot?.toString() ?? '—',
        width: colW * teamPlayers.length,
        textColor: isTeamWinner ? const Color(0xFFDAA520) : _colorTotal,
        bold: true,
        bgColor: isTeamWinner ? _colorWinner : _colorHeader,
        accentBorder: isTeamWinner,
      );
    }).toList();

    return SizedBox(
      width: totalWidth,
      child: Column(
        children: [
          // En-tête équipes
          Row(
            children: teams.map<Widget>((t) {
              final teamPlayers = game.playersForTeam(t.id as String) as List;
              final isTeamWinner = teamPlayers.any((p) => (game.winnerIds as List).contains(p.id));
              return _TeamHeaderCell(
                label: t.name as String,
                width: colW * teamPlayers.length,
                isWinner: isTeamWinner,
              );
            }).toList(),
          ),
          // En-tête joueurs
          Row(
            children: teams.expand<Widget>((t) {
              final teamPlayers = game.playersForTeam(t.id as String) as List;
              return teamPlayers.map((p) => _HeaderCell(
                label: p.name as String,
                width: colW,
                height: _rowHeight * 0.75,
                isWinner: (game.winnerIds as List).contains(p.id),
              ));
            }).toList(),
          ),
          // Lignes scores + totaux joueurs + totaux équipes
          Expanded(
            child: ListView.builder(
              controller: _rightScroll,
              itemCount: rounds + 2,
              itemBuilder: (_, i) {
                if (i < rounds) return Row(children: buildScoreRow(i));
                if (i == rounds) return Row(children: buildPlayerTotalRow());
                return Row(children: buildTeamTotalRow());
              },
            ),
          ),
        ],
      ),
    );
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

                final hasTeams = game.hasTeams as bool;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Colonne sticky gauche ──────────────────────────────
                    SizedBox(
                      width: _colFixedWidth,
                      child: Column(
                        children: [
                          _HeaderCell(
                            label: AppLocalizations.of(context).roundAbbrev,
                            width: _colFixedWidth,
                            height: hasTeams ? _rowHeight * 1.35 : _rowHeight,
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _leftScroll,
                              itemCount: rounds + (hasTeams ? 2 : 1),
                              itemBuilder: (_, i) {
                                if (i < rounds) {
                                  return _Cell(label: '${i + 1}', width: _colFixedWidth);
                                }
                                if (i == rounds) {
                                  return _Cell(
                                    label: AppLocalizations.of(context).totalLabel,
                                    width: _colFixedWidth,
                                    textColor: _colorTotal,
                                    bold: true,
                                  );
                                }
                                return _Cell(
                                  label: AppLocalizations.of(context).teamTotal,
                                  width: _colFixedWidth,
                                  textColor: _colorTotal,
                                  bold: true,
                                  bgColor: _colorHeader,
                                  softWrap: true,
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
                        child: _buildRightZone(context, game, colPlayerWidth, rounds, writable, notifier),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // ── Boutons bas ────────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (writable) ...[
                  Expanded(
                    child: _RoundStepper(
                      label: AppLocalizations.of(context).roundLabel,
                      canRemove: rounds > 0,
                      onAdd: notifier.addRound,
                      onRemove: () async {
                        if (notifier.lastRoundHasScores) {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) {
                              final ll = AppLocalizations.of(ctx);
                              return AlertDialog(
                                title: Text(ll.deleteRoundQuestion),
                                content: Text(ll.deleteRoundWarning),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ll.cancel)),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    child: Text(ll.delete),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmed != true) return;
                        }
                        notifier.removeLastRound();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
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
          ),
        ],
      ),
    );
  }
}

// ── Team header cell ──────────────────────────────────────────────────────────

class _TeamHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool isWinner;

  const _TeamHeaderCell({required this.label, required this.width, this.isWinner = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _rowHeight * 0.6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isWinner ? _colorWinner : _colorHeader,
        border: isWinner
            ? const Border(
                top: BorderSide(color: Color(0xFFDAA520), width: 2),
                left: BorderSide(color: Color(0xFFDAA520), width: 2),
                right: BorderSide(color: Color(0xFFDAA520), width: 2),
                bottom: BorderSide(color: _colorBorder, width: 0.5),
              )
            : Border.all(color: _colorBorder, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isWinner) const Icon(Icons.emoji_events, size: 13, color: Color(0xFFDAA520)),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: isWinner ? const Color(0xFFDAA520) : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Round stepper ─────────────────────────────────────────────────────────────

class _RoundStepper extends StatelessWidget {
  final String label;
  final bool canRemove;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _RoundStepper({
    required this.label,
    required this.canRemove,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final outline = Theme.of(context).colorScheme.outline;
    final borderRadius = BorderRadius.circular(100);
    return SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: outline),
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Row(
            children: [
              _StepperButton(icon: Icons.remove, enabled: canRemove, onTap: onRemove, color: primary),
              VerticalDivider(width: 1, thickness: 1, color: outline),
              Expanded(
                child: Center(
                  child: Text(label, style: TextStyle(fontSize: 14, color: primary)),
                ),
              ),
              VerticalDivider(width: 1, thickness: 1, color: outline),
              _StepperButton(icon: Icons.add, enabled: true, onTap: onAdd, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color color;

  const _StepperButton({required this.icon, required this.enabled, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: SizedBox(
        width: 40,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? color : Theme.of(context).disabledColor,
        ),
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
        color: isWinner ? _colorWinner : _colorHeader,
        border: isWinner
            ? const Border(
                top: BorderSide(color: Color(0xFFDAA520), width: 2),
                left: BorderSide(color: Color(0xFFDAA520), width: 2),
                right: BorderSide(color: Color(0xFFDAA520), width: 2),
                bottom: BorderSide(color: _colorBorder, width: 0.5),
              )
            : Border.all(color: _colorBorder, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isWinner)
            const Icon(Icons.emoji_events, size: 16, color: Color(0xFFDAA520)),
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
  final Color? bgColor;
  final bool bold;
  final bool accentBorder;
  final bool softWrap;

  const _Cell({
    required this.label,
    required this.width,
    this.textColor,
    this.bgColor,
    this.bold = false,
    this.accentBorder = false,
    this.softWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _rowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: accentBorder
            ? const Border(
                left: BorderSide(color: Color(0xFFDAA520), width: 2),
                right: BorderSide(color: Color(0xFFDAA520), width: 2),
                bottom: BorderSide(color: Color(0xFFDAA520), width: 2),
                top: BorderSide(color: _colorBorder, width: 0.5),
              )
            : Border.all(color: _colorBorder, width: 0.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        softWrap: softWrap,
        overflow: softWrap ? TextOverflow.visible : TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          fontSize: softWrap ? 11 : null,
        ),
      ),
    );
  }
}

class _ScoreInput extends StatefulWidget {
  final int? value;
  final double width;
  final bool enabled;
  final Color bgColor;
  final ValueChanged<int?> onChanged;

  const _ScoreInput({
    super.key,
    required this.value,
    required this.width,
    required this.enabled,
    this.bgColor = _colorBackground,
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
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: widget.bgColor == _colorWinner
            ? const Border(
                left: BorderSide(color: Color(0xFFDAA520), width: 2),
                right: BorderSide(color: Color(0xFFDAA520), width: 2),
                top: BorderSide(color: _colorBorder, width: 0.5),
                bottom: BorderSide(color: _colorBorder, width: 0.5),
              )
            : Border.all(color: _colorBorder, width: 0.5),
      ),
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
