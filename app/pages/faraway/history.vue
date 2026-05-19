<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">Historique des parties</h1>
    </IonLabel>
  </IonItem>

  <IonButton
    color="primary"
    expand="block"
    @click="farawayGameStore.exportHistory"
  >
    Exporter l'historique en JSON
  </IonButton>

  <IonList>
    <IonItem
      v-for="game in farawayGameStore.history"
      :key="game.id || undefined"
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

<script setup lang="ts">
import { IonButton, IonIcon, IonItem, IonLabel, IonList } from "@ionic/vue";

import { trash } from "ionicons/icons";

const farawayGameStore = useFarawayGameStore();
const router = useRouter();

const open = async (id: string | null): Promise<void> => {
  if (!id) return;

  await farawayGameStore.loadGame(id);
  router.push("/faraway/game");
};

const remove = async (id: string | null): Promise<void> =>
  id ? farawayGameStore.deleteGame(id) : undefined;
</script>

<style scoped lang="scss">
.title {
  color: $default-font-color;
  font-size: 1.625rem;
  font-weight: 700;
  margin-bottom: 1.25rem;
  text-align: center;
}
</style>
