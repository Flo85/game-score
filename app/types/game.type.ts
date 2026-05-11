export type Player = {
  id: string;
  name: string;
};

export type Round = {
  id: string;
  index: number;
};

export type Score = {
  playerId: string;
  roundId: string;
  value: number;
};

export type Game = {
  createdAt: string;
  id: string;
  players: Array<Player>;
  rounds: Array<Round>;
  scores: Array<Score>;
};
