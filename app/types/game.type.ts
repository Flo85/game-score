export type PlayerType = {
  id: string;
  name: string;
};

export type ScoresType = { [playerId: string]: Array<number | null> };

export type GameStoreType = {
  createdAt: string;
  id: string;
  numberOfRows: number;
  players: Array<PlayerType>;
  scores: ScoresType;
};
