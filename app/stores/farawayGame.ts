import { Capacitor } from "@capacitor/core";
import { Filesystem, Directory, Encoding } from "@capacitor/filesystem";
import { defineStore } from "pinia";
import { nanoid } from "nanoid";
import type {
  GameListItemType,
  GameStoreType,
  ScoresType,
} from "~/types/game.type";

const GAME_KEY = "faraway-game";
const MAX_PLAYERS = 7;
const NUMBER_OF_ROWS = 9;

export const useFarawayGameStore = defineStore("game", {
  state: (): GameStoreType => ({
    autoSaveInitialized: false,
    createdAt: new Date().toISOString(),
    history: [],
    id: null,
    numberOfRows: NUMBER_OF_ROWS,
    players: [
      { id: nanoid(), name: "Joueur 1" },
      { id: nanoid(), name: "Joueur 2" },
    ],
    readyForAutoSave: false,
    scores: {},
    writable: true,
  }),

  getters: {
    maxPlayersReached: (state): boolean => state.players.length >= MAX_PLAYERS,

    noPlayer: (state): boolean => state.players.length === 0,

    playerTotal:
      (state) =>
      (playerId: string): number | null =>
        state.scores[playerId]?.reduce<number>(
          (sum, value) => sum + (value ?? 0),
          0,
        ) || null,
  },

  actions: {
    addPlayer(name: string): void {
      this.players.push({ id: nanoid(), name });
    },

    async deleteGame(gameId: string): Promise<void> {
      const { deleteItem } = useGameStorage(GAME_KEY);
      await deleteItem(gameId);

      this.updateHistory();
    },

    endGame(): void {
      this.writable = false;
    },

    async exportHistory(): Promise<void> {
      const history = this.history;

      if (!history.length) return;

      const json = JSON.stringify(history, null, 2);
      const timestamp = new Date()
        .toISOString()
        .slice(0, 19)
        .replace(/:/g, "-");
      const fileName = `faraway-history-${timestamp}.json`;

      if (Capacitor.isNativePlatform()) {
        try {
          await Filesystem.writeFile({
            data: json,
            directory: Directory.ExternalStorage,
            encoding: Encoding.UTF8,
            path: `Download/${fileName}`,
          });

          return;
        } catch (error) {
          console.error("Export natif échoué:", error);
        }
      }

      if (typeof document !== "undefined") {
        const blob = new Blob([json], { type: "application/json" });
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
      }
    },

    async init(): Promise<void> {
      this.updateHistory();
      this.initAutoSave();
    },

    initAutoSave(): void {
      if (this.autoSaveInitialized) return;

      this.autoSaveInitialized = true;

      const { saveItem } = useGameStorage(GAME_KEY);

      watch(
        () => ({
          players: this.players,
          scores: this.scores,
          writable: this.writable,
        }),
        async () => {
          if (!this.id || !this.readyForAutoSave) return;

          await saveItem<GameListItemType>(
            {
              createdAt: this.createdAt,
              id: this.id,
              numberOfRows: this.numberOfRows,
              players: this.players,
              scores: this.scores,
              writable: this.writable,
            },
            this.id,
          );
        },
        { deep: true },
      );
    },

    async loadGame(gameId: string): Promise<void> {
      const { loadItem } = useGameStorage(GAME_KEY);
      const savedGame = await loadItem<GameListItemType>(gameId);

      if (!savedGame) return;

      this.createdAt = savedGame.createdAt;
      this.id = savedGame.id;
      this.numberOfRows = savedGame.numberOfRows;
      this.players = savedGame.players;
      this.scores = savedGame.scores;
      this.writable = savedGame.writable;
    },

    async newGame(): Promise<void> {
      const { saveItem } = useGameStorage("faraway-game");

      this.readyForAutoSave = false;

      this.createdAt = new Date().toISOString();
      this.id = nanoid();
      this.scores = this.players.reduce<ScoresType>((acc, player) => {
        acc[player.id] = Array(this.numberOfRows).fill(null);
        return acc;
      }, {});
      this.writable = true;

      await saveItem<GameListItemType>(
        {
          createdAt: this.createdAt,
          id: this.id,
          numberOfRows: this.numberOfRows,
          players: this.players,
          scores: this.scores,
          writable: this.writable,
        },
        this.id,
      );

      this.updateHistory();

      this.readyForAutoSave = true;
    },

    removePlayer(playerId: string): void {
      this.players = this.players.filter((p) => p.id !== playerId);
      delete this.scores[playerId];
    },

    reset(): void {
      this.readyForAutoSave = false;
      this.id = null;
      this.players = [
        { id: nanoid(), name: "Joueur 1" },
        { id: nanoid(), name: "Joueur 2" },
      ];
      this.scores = {};
    },

    setScore(playerId: string, row: number, value: number): void {
      if (this.scores[playerId]) {
        this.scores[playerId][row] = value;
      }
    },

    async updateHistory(): Promise<void> {
      const { getList, loadItem } = useGameStorage(GAME_KEY);

      const ids = await getList();
      this.history = (await Promise.all(ids.map((id) => loadItem(id))))
        .filter((item): item is GameListItemType => Boolean(item))
        .sort(
          (a, b) =>
            new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
        );
    },
  },
});
