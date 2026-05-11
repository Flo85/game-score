import { defineStore } from "pinia";
import { nanoid } from "nanoid";
import type { Player, Round, Score } from "~/types/game.type";

export const useGameStore = defineStore("game", {
  state: () => ({
    count: 2,
    id: nanoid(),
    players: [
      { id: nanoid(), name: "Joueur 1" },
      { id: nanoid(), name: "Joueur 2" },
    ] as Array<Player>,
    rounds: [
      { id: nanoid(), index: 1 },
      { id: nanoid(), index: 2 },
    ] as Array<Round>,
    scores: [] as Array<Score>,
  }),

  getters: {
    totalByPlayer: (state) => {
      return state.players.map((p) => ({
        playerId: p.id,
        total: state.scores
          .filter((s) => s.playerId === p.id)
          .reduce((sum, s) => sum + s.value, 0),
      }));
    },
  },

  actions: {
    addPlayer(name: string) {
      this.players.push({ id: nanoid(), name });
    },

    addRound() {
      this.rounds.push({
        id: nanoid(),
        index: this.rounds.length + 1,
      });
    },

    setCount(n: number) {
      this.count = n;
    },

    setScore(playerId: string, roundId: string, value: number) {
      const existing = this.scores.find(
        (s) => s.playerId === playerId && s.roundId === roundId,
      );

      if (existing) existing.value = value;
      else this.scores.push({ playerId, roundId, value });
    },
  },
});
