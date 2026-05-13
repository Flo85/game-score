<template>
  <h1 class="title">Nouvelle partie</h1>

  <IonList>
    <IonReorderGroup :disabled="false" @ionItemReorder="reorderPlayers">
      <template v-for="(player, i) in gameStore.players" :key="player.id">
        <IonItem>
          <IonInput
            :label="`Joueur ${i + 1}`"
            label-placement="stacked"
            v-model="player.name"
            placeholder="Nom du joueur"
          />

          <IonButton
            fill="clear"
            color="danger"
            @click="removePlayer(player.id)"
          >
            <IonIcon :icon="trash" />
          </IonButton>

          <IonReorder slot="end"></IonReorder>
        </IonItem>
      </template>
    </IonReorderGroup>
  </IonList>

  <IonButton expand="block" color="primary" @click="startGame">
    Commencer la partie
  </IonButton>

  <IonFab vertical="bottom" horizontal="end" slot="fixed">
    <IonFabButton @click="addPlayer">
      <IonIcon :icon="add" />
    </IonFabButton>
  </IonFab>
</template>

<script setup lang="ts">
import {
  IonList,
  IonItem,
  IonInput,
  IonButton,
  IonFab,
  IonFabButton,
  IonIcon,
  IonReorderGroup,
  IonReorder,
} from "@ionic/vue";

import { add, trash } from "ionicons/icons";
import { ImpactStyle } from "@capacitor/haptics";

const gameStore = useGameStore();
const router = useRouter();

const addPlayer = async () => {
  await vibrate(ImpactStyle.Light);
  gameStore.addPlayer(`Joueur ${gameStore.players.length + 1}`);
};

const removePlayer = async (id: string) => {
  await vibrate(ImpactStyle.Medium);
  gameStore.players = gameStore.players.filter((p) => p.id !== id);
};

const reorderPlayers = (event: any) => {
  const from = event.detail.from;
  const to = event.detail.to;

  const moved = gameStore.players.splice(from, 1)[0];

  if (moved) {
    gameStore.players.splice(to, 0, moved);
  }

  event.detail.complete();
};

const startGame = () => {
  router.push("/faraway/game");
};
</script>

<style scoped>
.title {
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
}

.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.25s ease;
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
