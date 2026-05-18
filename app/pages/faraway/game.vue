<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">Feuille de score</h1>
    </IonLabel>
  </IonItem>

  <IonGrid class="score-grid">
    <IonRow class="header-row">
      <IonCol size="1" class="icon">
        <IonImg :src="IconeJeuUrl"></IonImg>
      </IonCol>

      <IonCol
        v-for="player in farawayGameStore.players"
        :key="player.id"
        class="player-header"
      >
        <IonInput
          v-model="player.name"
          :disabled="!farawayGameStore.writable"
        />
      </IonCol>
    </IonRow>

    <IonRow
      v-for="row in farawayGameStore.numberOfRows"
      :key="row"
      class="score-row"
    >
      <IonCol
        v-if="row !== farawayGameStore.numberOfRows"
        size="1"
        class="line-number"
      >
        {{ row }}
      </IonCol>
      <IonCol v-else size="1" class="line-number icon">
        <IonImg :src="IconeSantcuaireUrl"></IonImg>
      </IonCol>

      <IonCol
        v-for="player in farawayGameStore.players"
        :key="player.id"
        class="score-col"
      >
        <IonInput
          type="number"
          :value="getScore(player.id, row)"
          @ionInput="onScoreInput(player.id, row, $event.target?.value)"
          @keyup.enter="focusNext(`${player.id}-${row}`)"
          :ref="(el) => registerInput(`${player.id}-${row}`, el)"
          inputmode="numeric"
          :disabled="!farawayGameStore.writable"
          class="score-input"
        />
      </IonCol>
    </IonRow>

    <IonRow class="total-row">
      <IonCol size="1" class="total-label">T</IonCol>
      <IonCol
        v-for="player in farawayGameStore.players"
        :key="player.id"
        class="total-score"
      >
        {{ farawayGameStore.playerTotal(player.id) }}
      </IonCol>
    </IonRow>
  </IonGrid>

  <IonButton
    color="primary"
    :disabled="!farawayGameStore.writable"
    expand="block"
    @click="endGame"
  >
    Partie terminée
  </IonButton>
</template>

<script setup lang="ts">
import { ImpactStyle } from "@capacitor/haptics";
import {
  IonButton,
  IonCol,
  IonGrid,
  IonImg,
  IonInput,
  IonRow,
} from "@ionic/vue";
import IconeJeuUrl from "~/assets/images/icone-jeu.png";
import IconeSantcuaireUrl from "~/assets/images/icone-sanctuaire.png";

const farawayGameStore = useFarawayGameStore();

const inputs = ref<Record<string, HTMLInputElement | null>>({});

function registerInput(
  key: string,
  el: Element | ComponentPublicInstance | null,
) {
  if (!el || !("$el" in el)) {
    inputs.value[key] = null;
    return;
  }

  const element = el.$el?.querySelector("input") ?? null;
  inputs.value[key] = element;
}

function getScore(playerId: string, row: number) {
  return farawayGameStore.scores[playerId]?.[row] ?? "";
}

async function onScoreInput(
  playerId: string,
  row: number,
  value: string | number | null | undefined,
) {
  const num = Number(value);
  if (!isNaN(num)) {
    farawayGameStore.setScore(playerId, row, num);

    if (import.meta.client) {
      await vibrate(ImpactStyle.Light);
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

function endGame() {
  farawayGameStore.endGame();
}
</script>

<style scoped lang="scss">
.header-row {
  align-items: center;
  background: $faraway-color-background-1;
  border-bottom: 2px solid $faraway-color-border-1;
  position: sticky;
  text-align: center;
  top: 0;
  z-index: 10;
}

.icon {
  --ion-grid-column-padding: 0;
}

.line-number {
  color: $faraway-color-font-1;
  font-weight: 700;
  text-align: center;
}

.player-header {
  align-items: center;
  display: flex;
  flex-direction: column;
  padding: 8px 0;
}

.score-col {
  align-items: center;
  border-left: 1px dashed #b8a98f;
  display: flex;
  justify-content: center;
}

.score-grid {
  background: #f7f3e9;
  border: 2px solid $faraway-color-border-1;
  border-radius: 6px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.score-input {
  text-align: center;
  width: 100%;
}

.score-input input {
  background: $faraway-color-background-2;
  border: 2px solid $faraway-color-border-1;
  border-radius: 4px;
  color: $faraway-color-font-1;
  font-size: 18px;
  font-weight: 600;
  padding: 4px;
  text-align: center;
}

.score-row {
  align-items: center;
  border-bottom: 1px solid #d6c9b3;
}

.title {
  color: $faraway-color-font-1;
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
  text-align: center;
}

.total-label {
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  height: 100%;
}

.total-row {
  align-items: center;
  background: $faraway-color-background-3;
  border-top: 2px solid $faraway-color-border-2;
  color: $faraway-color-font-2;
  height: 55px;
}

.total-row .total-score {
  align-items: center;
  border-left: 1px dashed rgba(255, 255, 255, 0.6);
  display: flex;
  font-size: 18px;
  font-weight: 700;
  height: 100%;
  justify-content: center;
}

.score-row .score-col:first-of-type {
  border-left: none;
}

.total-row .total-score:first-of-type {
  border-left: none;
}
</style>
