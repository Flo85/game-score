<template>
  <div class="score-page">
    <h1>Saisie des scores</h1>

    <table class="score-table">
      <thead>
        <tr>
          <th>Joueur</th>
          <th v-for="round in game.rounds" :key="round.id">
            Manche {{ round.index }}
          </th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="player in game.players" :key="player.id">
          <td>{{ player.name }}</td>

          <td v-for="round in game.rounds" :key="round.id">
            <input
              type="number"
              :value="
                game.scores.find(
                  (s) => s.playerId === player.id && s.roundId === round.id,
                )?.value ?? ''
              "
              @input="
                onScoreInput(
                  player.id,
                  round.id,
                  ($event.target as HTMLInputElement | null)?.value ?? '',
                )
              "
              @keyup.enter="focusNext(`${player.id}-${round.id}`)"
              :ref="
                (el) =>
                  registerInput(
                    `${player.id}-${round.id}`,
                    el as HTMLInputElement | null,
                  )
              "
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
const game = useGameStore();

const inputs = ref<Record<string, HTMLInputElement | null>>({});

function registerInput(key: string, el: HTMLInputElement | null) {
  inputs.value[key] = el;
}

function onScoreInput(playerId: string, roundId: string, value: string) {
  const num = Number(value);
  if (!isNaN(num)) {
    game.setScore(playerId, roundId, num);
    if (import.meta.client) {
      import("@capacitor/haptics").then(({ Haptics, ImpactStyle }) => {
        Haptics.impact({ style: ImpactStyle.Light });
      });
    }
  }
}

function focusNext(currentKey: string) {
  const keys = Object.keys(inputs.value);
  const index = keys.indexOf(currentKey);
  const nextKey = keys[index + 1];
  if (nextKey) {
    nextTick(() => inputs.value[nextKey]?.focus());
  }
}
</script>

<style scoped>
.score-table {
  width: 100%;
  border-collapse: collapse;
}

.score-table th,
.score-table td {
  padding: 8px;
  text-align: center;
}

.score-table input {
  width: 60px;
  padding: 6px;
  font-size: 16px;
  text-align: center;
}
</style>
