import { defineStore } from "pinia";

export const usePlayersStore = defineStore("players", {
  state: () => ({
    count: 2,
    names: ["Joueur 1", "Joueur 2"],
  }),

  actions: {
    setCount(n: number) {
      this.count = n;
      this.names = Array.from(
        { length: n },
        (_, i) => this.names[i] || `Joueur ${i + 1}`,
      );
    },

    setName(index: number, value: string) {
      this.names[index] = value;
    },
  },
});
