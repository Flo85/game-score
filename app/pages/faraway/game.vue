<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">Feuille de score</h1>
    </IonLabel>
  </IonItem>

  <div class="score-scroll-wrapper">
    <IonGrid
      class="score-grid"
      ref="gridRef"
      :style="{
        minWidth: `calc(48px + ${farawayGameStore.players.length} * 80px)`,
      }"
    >
      <IonRow class="header-row" ref="headerRowRef">
        <IonCol class="game-icon col-fixed">
          <IonImg :src="IconeJeuUrl"></IonImg>
        </IonCol>

        <IonCol
          v-for="player in farawayGameStore.players"
          :key="player.id"
          class="player-header"
        >
          <IonTextarea
            v-model="player.name"
            :auto-grow="true"
            :disabled="!farawayGameStore.writable"
            :rows="1"
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
          class="line-number col-fixed"
        >
          {{ row }}
        </IonCol>
        <IonCol v-else class="line-number sanctuary-icon col-fixed">
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
        <IonCol class="total-label col-fixed">T</IonCol>
        <IonCol
          v-for="player in farawayGameStore.players"
          :key="player.id"
          class="total-score"
        >
          {{ farawayGameStore.playerTotal(player.id) }}
        </IonCol>
      </IonRow>
    </IonGrid>
  </div>

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
  IonTextarea,
} from "@ionic/vue";
import IconeJeuUrl from "~/assets/images/icone-jeu.png";
import IconeSantcuaireUrl from "~/assets/images/icone-sanctuaire.png";

const farawayGameStore = useFarawayGameStore();

const gridRef = ref<ComponentPublicInstance | null>(null);
const headerRowRef = ref<ComponentPublicInstance | null>(null);
const inputs = ref<Record<string, HTMLInputElement | null>>({});

let scrollEl: HTMLElement | null = null;

function onScroll() {
  const headerEl = headerRowRef.value?.$el as HTMLElement | null;
  const gridEl = gridRef.value?.$el as HTMLElement | null;

  if (!headerEl || !gridEl || !scrollEl) return;

  // Position du haut de Kla grille par rapport au viewport
  const gridTop = gridEl.getBoundingClientRect().top;

  if (gridTop < 0) {
    headerEl.style.transform = `translateY(${-gridTop}px)`;
  } else {
    headerEl.style.transform = "translateY(0)";
  }
}

onMounted(() => {
  const content = document.querySelector("ion-content");
  content?.getScrollElement().then((el) => {
    scrollEl = el;
    scrollEl.addEventListener("scroll", onScroll, { passive: true });
  });
});

onUnmounted(() => {
  scrollEl?.removeEventListener("scroll", onScroll);
});

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
.col-fixed {
  align-items: center;
  align-self: stretch;
  display: flex;
  justify-content: center;
  left: 0;
  max-width: 48px;
  position: sticky;
  z-index: 5;
}

.header-row {
  align-items: center;
  background: $faraway-color-background-1;
  border-bottom: 2px solid $faraway-color-border-1;
  border-top: 2px solid $faraway-color-border-1;
  position: sticky;
  text-align: center;
  top: 0;
  z-index: 10;
}

.game-icon {
  background: $faraway-color-background-1;
  border-right: 1px dashed $faraway-color-border-1;
}

.sanctuary-icon {
  --ion-grid-column-padding: 0;
}

.line-number {
  background: #f7f3e9;
  border-right: 1px dashed $faraway-color-border-1;
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
  border-right: 1px dashed $faraway-color-border-1;
  display: flex;
  justify-content: center;
}

.score-grid {
  --ion-grid-padding: 0;
  background: #f7f3e9;
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
  border-bottom: 1px solid $faraway-color-border-1;
}

.score-scroll-wrapper {
  -webkit-overflow-scrolling: touch;
  overflow-x: auto;
  width: 100%;
}

.title {
  color: $faraway-color-font-1;
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
  text-align: center;
}

.total-label {
  align-items: center;
  background: $faraway-color-background-3;
  border-right: 1px dashed white;
  display: flex;
  font-weight: 700;
  height: 100%;
  justify-content: center;
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
  border-right: 1px dashed white;
  display: flex;
  font-size: 18px;
  font-weight: 700;
  height: 100%;
  justify-content: center;
}

.score-row .score-col:last-of-type {
  border-right: none;
}

.total-row .total-score:last-of-type {
  border-right: none;
}
</style>
