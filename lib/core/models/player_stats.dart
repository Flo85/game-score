class FarawayPlayerStats {
  final int gamesPlayed;
  final int wins;
  final double averageScore;
  final int bestScore;
  final int worstScore;

  const FarawayPlayerStats({
    required this.gamesPlayed,
    required this.wins,
    required this.averageScore,
    required this.bestScore,
    required this.worstScore,
  });
}

class GenericPlayerStats {
  final int gamesPlayed;
  final int wins;

  const GenericPlayerStats({
    required this.gamesPlayed,
    required this.wins,
  });
}
