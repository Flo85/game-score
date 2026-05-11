<template>
  <IonPage>
    <IonContent class="ion-padding">
      <h1 class="title">Nouvelle partie</h1>

      <IonList>
        <IonItem v-for="(player, i) in gameStore.players" :key="player.id">
          <IonInput
            :label="`Joueur ${i + 1}`"
            label-placement="stacked"
            v-model="player.name"
            placeholder="Nom du joueur"
          />
        </IonItem>
      </IonList>

      <IonButton expand="block" color="medium" @click="addPlayer">
        Ajouter un joueur
      </IonButton>

      <IonButton expand="block" color="primary" @click="startGame">
        Commencer la partie
      </IonButton>
    </IonContent>
  </IonPage>
</template>

<script setup lang="ts">
import {
  IonPage,
  IonContent,
  IonList,
  IonItem,
  IonInput,
  IonButton,
} from "@ionic/vue";

const gameStore = useGameStore();

const router = useRouter();

const addPlayer = () =>
  gameStore.addPlayer(`Joueur ${gameStore.players.length + 1}`);

const startGame = () => {
  router.push("/score");
};
</script>

<style scoped>
.title {
  font-size: 26px;
  font-weight: 700;
  margin-bottom: 20px;
}
</style>
