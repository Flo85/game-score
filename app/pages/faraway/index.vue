<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">Nouvelle partie</h1>
      <p>Maximum de 6 joueurs</p>
    </IonLabel>
  </IonItem>

  <IonList>
    <IonReorderGroup :disabled="false" @ionItemReorder="reorderPlayers">
      <template
        v-for="(player, i) in farawayGameStore.players"
        :key="player.id"
      >
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
            @click="farawayGameStore.removePlayer(player.id)"
          >
            <IonIcon :icon="trash" />
          </IonButton>

          <IonReorder slot="end"></IonReorder>
        </IonItem>
      </template>
    </IonReorderGroup>
  </IonList>

  <IonButton
    color="primary"
    :disabled="farawayGameStore.noPlayer"
    expand="block"
    @click="startGame"
  >
    Commencer la partie
  </IonButton>

  <IonFab horizontal="end" slot="fixed" vertical="bottom">
    <IonFabButton
      :disabled="farawayGameStore.maxPlayersReached"
      @click="addPlayer"
    >
      <IonIcon :icon="add" />
    </IonFabButton>
  </IonFab>
</template>

<script setup lang="ts">
import {
  IonButton,
  IonFab,
  IonFabButton,
  IonIcon,
  IonInput,
  IonItem,
  IonLabel,
  IonList,
  IonReorder,
  IonReorderGroup,
} from "@ionic/vue";

import { add, trash } from "ionicons/icons";
import { ImpactStyle } from "@capacitor/haptics";

const farawayGameStore = useFarawayGameStore();
const router = useRouter();

const addPlayer = async () => {
  await vibrate(ImpactStyle.Light);
  farawayGameStore.addPlayer(`Joueur ${farawayGameStore.players.length + 1}`);
};

const reorderPlayers = (event: any) => {
  const from = event.detail.from;
  const to = event.detail.to;

  const moved = farawayGameStore.players.splice(from, 1)[0];

  if (moved) {
    farawayGameStore.players.splice(to, 0, moved);
  }

  event.detail.complete();
};

const startGame = () => {
  farawayGameStore.initGame();
  router.push("/faraway/game");
};
</script>

<style scoped>
.title {
  font-size: 26px;
  font-weight: 700;
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
