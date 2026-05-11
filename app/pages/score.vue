<template>
  <IonPage>
    <IonContent>
      <h1 class="title">Feuille de score</h1>

      <!-- Grille principale -->
      <IonGrid class="score-grid">
        <!-- Ligne d'en-tête : noms des joueurs -->
        <IonRow class="header-row">
          <IonCol size="1"></IonCol>
          <!-- case vide -->
          <IonCol
            v-for="player in game.players"
            :key="player.id"
            class="player-header"
          >
            <div class="player-name">{{ player.name }}</div>
          </IonCol>
        </IonRow>

        <!-- Lignes des manches -->
        <IonRow v-for="round in game.rounds" :key="round.id" class="score-row">
          <!-- Numéro de manche -->
          <IonCol size="1" class="line-number">
            {{ round.index }}
          </IonCol>

          <!-- Score pour chaque joueur -->
          <IonCol
            v-for="player in game.players"
            :key="player.id"
            class="score-col"
          >
            <IonInput
              type="number"
              :value="getScore(player.id, round.id)"
              @ionInput="
                onScoreInput(player.id, round.id, $event.target?.value)
              "
              @keyup.enter="focusNext(`${player.id}-${round.id}`)"
              :ref="
                (el) =>
                  registerInput(
                    `${player.id}-${round.id}`,
                    el?.$el?.querySelector('input') ?? null,
                  )
              "
              inputmode="numeric"
              class="score-input"
            />
          </IonCol>
        </IonRow>

        <IonRow class="total-row">
          <IonCol size="1" class="total-label">T</IonCol>
          <IonCol
            v-for="player in game.players"
            :key="player.id"
            class="total-score"
          >
            {{ getPlayerTotal(player.id) }}
          </IonCol>
        </IonRow>
      </IonGrid>
    </IonContent>
  </IonPage>
</template>

<script setup lang="ts">
import {
  IonPage,
  IonContent,
  IonGrid,
  IonRow,
  IonCol,
  IonInput,
} from "@ionic/vue";

import { useGameStore } from "~/stores/game";
const game = useGameStore();

const inputs = ref<Record<string, HTMLInputElement | null>>({});

function registerInput(key: string, el: HTMLInputElement | null) {
  inputs.value[key] = el;
}

function getScore(playerId: string, roundId: string) {
  return (
    game.scores.find((s) => s.playerId === playerId && s.roundId === roundId)
      ?.value ?? ""
  );
}

function getPlayerTotal(playerId: string) {
  return game.scores
    .filter((s) => s.playerId === playerId)
    .reduce((sum, s) => sum + (s.value ?? 0), 0);
}

function onScoreInput(playerId: string, roundId: string, value: any) {
  const num = Number(value);
  if (!isNaN(num)) {
    game.setScore(playerId, roundId, num);

    // Haptics
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

onMounted(() => {
  game.initRounds();
});
</script>

<style scoped>
.title {
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
  text-align: center;
  color: #3a2f1b;
}

.score-grid {
  background: #f7f3e9;
  border: 2px solid #b8a98f;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.header-row {
  background: #e9dfc9;
  border-bottom: 2px solid #b8a98f;
  text-align: center;
}

.player-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8px 0;
}

.player-name {
  font-size: 15px;
  font-weight: 700;
  color: #3a2f1b;
}

.score-row {
  align-items: center;
  border-bottom: 1px solid #d6c9b3;
  height: 48px;
}

.line-number {
  font-weight: 700;
  text-align: center;
  color: #3a2f1b;
}

.score-col {
  display: flex;
  align-items: center;
  justify-content: center;
}

.score-input {
  width: 100%;
  text-align: center;
}

.score-input input {
  background: #fffdf8;
  border: 2px solid #b8a98f;
  border-radius: 4px;
  color: #3a2f1b;
  font-size: 18px;
  font-weight: 600;
  padding: 4px;
  text-align: center;
}

.total-label {
  font-weight: 700;
  text-align: center;
}

.total-row {
  background: #b22222;
  color: white;
  height: 55px;
  align-items: center;
  border-top: 2px solid #7a1616;
}

.total-score {
  font-weight: 700;
  font-size: 18px;
  text-align: center;
}

.score-col {
  border-left: 1px dashed #b8a98f;
}

.score-row .score-col:first-of-type {
  border-left: none;
}

.total-row .total-score {
  border-left: 1px dashed rgba(255, 255, 255, 0.6);
}

.total-row .total-score:first-of-type {
  border-left: none;
}
</style>
