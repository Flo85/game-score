export type PlayerType = {
  id: string;
  name: string;
};

export type ScoresType = { [playerId: string]: Array<number | null> };

export type GameListItemType = {
  createdAt: string;
  id: string | null;
  numberOfRows: number;
  players: Array<PlayerType>;
  scores: ScoresType;
  writable: boolean;
};

export type GameStoreType = GameListItemType & {
  autoSaveInitialized: boolean;
  history: Array<GameListItemType>;
  readyForAutoSave: boolean;
};
