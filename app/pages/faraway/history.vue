<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">Historique des parties</h1>
    </IonLabel>
  </IonItem>

  <IonList>
    <IonItem
      v-for="game in farawayGameStore.history"
      :key="game.id"
      @click="open(game.id)"
    >
      <IonLabel>
        Partie du {{ new Date(game.createdAt).toLocaleString() }}
        <p>{{ game.players.length }} joueurs</p>
      </IonLabel>

      <IonButton fill="clear" color="danger" @click.stop="remove(game.id)">
        <IonIcon :icon="trash" />
      </IonButton>
    </IonItem>
  </IonList>
</template>

<script setup>
import { IonButton, IonIcon, IonItem, IonLabel, IonList } from "@ionic/vue";

import { trash } from "ionicons/icons";

const farawayGameStore = useFarawayGameStore();
const router = useRouter();

const open = async (id) => {
  await farawayGameStore.loadGame(id);
  router.push("/faraway/game");
};

const remove = async (id) => {
  await farawayGameStore.deleteGame(id);
};
</script>

<style scoped>
.title {
  color: #3a2f1b;
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
  text-align: center;
}
</style>
