<template>
  <IonImg :src="LogoUrl"></IonImg>

  <IonItem>
    <IonLabel>
      <h1 class="title">Nouvelle partie</h1>
      <p>Maximum de 7 joueurs</p>
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

  <IonButton color="secondary" expand="block" @click="showHistory">
    Historique
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
  IonImg,
  IonInput,
  IonItem,
  IonLabel,
  IonList,
  IonReorder,
  IonReorderGroup,
  type ItemReorderEventDetail,
} from "@ionic/vue";

import { add, trash } from "ionicons/icons";
import { ImpactStyle } from "@capacitor/haptics";

import LogoUrl from "~/assets/images/logo-faraway.png";

const farawayGameStore = useFarawayGameStore();
const router = useRouter();

const addPlayer = async () => {
  await vibrate(ImpactStyle.Light);
  farawayGameStore.addPlayer(`Joueur ${farawayGameStore.players.length + 1}`);
};

const reorderPlayers = (event: CustomEvent<ItemReorderEventDetail>) => {
  const from = event.detail.from;
  const to = event.detail.to;

  const moved = farawayGameStore.players.splice(from, 1)[0];

  if (moved) {
    farawayGameStore.players.splice(to, 0, moved);
  }

  event.detail.complete();
};

const startGame = () => {
  farawayGameStore.newGame();
  router.push("/faraway/game");
};

const showHistory = () => {
  router.push("/faraway/history");
};
</script>

<style scoped lang="scss">
.title {
  color: $default-font-color;
  font-size: 1.625rem;
  font-weight: 700;
  margin-bottom: 1.25rem;
  text-align: center;
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
