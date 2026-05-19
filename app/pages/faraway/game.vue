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
        minWidth: `calc(3rem + ${farawayGameStore.players.length} * 5rem)`,
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
            class="player-name"
            :disabled="!farawayGameStore.writable"
            :rows="1"
          />
        </IonCol>
      </IonRow>

      <IonRow
        v-for="row in farawayGameStore.numberOfRows"
        :key="row"
        class="score-row"
        :class="{
          'score-row--last': row === farawayGameStore.numberOfRows,
        }"
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
  farawayGameStore.reset();
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
// ── Colonne fixe (sticky horizontal) ─────────────────────────────────────────
.col-fixed {
  @include flex-center;

  background: inherit;
  left: 0;
  max-width: 3rem;
  position: sticky;
  z-index: 5;
}

// ── Header ────────────────────────────────────────────────────────────────────
.header-row {
  align-items: stretch;
  background: $faraway-color-background-default;
  min-height: 3.5rem;
  position: relative;
  text-align: center;
  z-index: 10;
}

.game-icon {
  background: $faraway-color-background-default;
  border-right: 1px dashed $faraway-color-border-default;
}

.player-header {
  @include flex-center(column);

  border-right: 1px dashed $faraway-color-border-default;

  &:last-of-type {
    border-right: none;
  }
}

.player-name {
  --padding-top: 0;
  --padding-bottom: 0;
  min-height: unset;
}

// ── Lignes de score ───────────────────────────────────────────────────────────
.score-row {
  align-items: stretch;
  background: $faraway-color-background-default;
  border-top: 1px dashed $faraway-color-border-default;
  min-height: 3.5rem;

  &--last {
    background: $faraway-color-background-sanctuary-score;
    border-top: 1px solid $faraway-color-border-default;
  }
}

.line-number {
  background: $faraway-color-background-default;
  border-right: 1px dashed $faraway-color-border-default;
  font-size: 2rem;
  font-weight: 900;
  text-align: center;
}

.sanctuary-icon {
  background: $faraway-color-background-sanctuary-score;
}

.score-col {
  @include flex-center;

  border-right: 1px dashed $faraway-color-border-default;

  &:last-of-type {
    border-right: none;
  }
}

.score-input {
  text-align: center;
  width: 100%;
}

// ── Ligne total ───────────────────────────────────────────────────────────────
.total-row {
  align-items: stretch;
  color: $faraway-color-font-total-score;
  min-height: 3.5rem;
}

.total-label,
.total-score {
  @include flex-center;

  background: $faraway-color-background-total-score;
  border-right: 1px dashed white;

  &:last-of-type {
    border-right: none;
  }
}

.total-label {
  font-size: 2rem;
  font-weight: 900;
}

.total-score {
  font-size: 1.125rem;
  font-weight: 700;
}

// ── Grille ────────────────────────────────────────────────────────────────────
.score-grid {
  --ion-grid-padding: 0;
  color: $faraway-color-font-default;
}

.score-scroll-wrapper {
  -webkit-overflow-scrolling: touch;
  overflow-x: auto;
  width: 100%;
}

// ── Titre ─────────────────────────────────────────────────────────────────────
.title {
  color: $faraway-color-font-default;
  font-size: 1.625rem;
  font-weight: 700;
  margin-bottom: 1.25rem;
  text-align: center;
}
</style>
