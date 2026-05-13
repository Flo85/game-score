import { defineStore } from "pinia";
import { nanoid } from "nanoid";
import type { GameStoreType, ScoresType } from "~/types/game.type";

const NUMBER_OF_ROWS = 9;
const MAX_PLAYERS = 7;

export const useFarawayGameStore = defineStore("game", {
  state: (): GameStoreType => ({
    createdAt: new Date().toISOString(),
    id: nanoid(),
    numberOfRows: NUMBER_OF_ROWS,
    players: [
      { id: nanoid(), name: "Joueur 1" },
      { id: nanoid(), name: "Joueur 2" },
    ],
    scores: {},
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

    initGame(): void {
      this.createdAt = new Date().toISOString();
      this.id = nanoid();
      this.scores = this.players.reduce<ScoresType>((acc, player) => {
        acc[player.id] = Array(9).fill(null);
        return acc;
      }, {});
    },

    removePlayer(playerId: string): void {
      this.players = this.players.filter((p) => p.id !== playerId);
      delete this.scores[playerId];
    },

    setScore(playerId: string, row: number, value: number): void {
      if (this.scores[playerId]) {
        this.scores[playerId][row] = value;
      }
    },
  },
});
