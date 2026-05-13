<template>
  <IonItem>
    <IonLabel>
      <h1 class="title">
        Bienvenue dans l'application de score de vos jeux préférés
      </h1>
    </IonLabel>
  </IonItem>

  <IonButton color="primary" expand="block" @click="goToFaraway">
    Faraway
  </IonButton>
</template>

<script setup lang="ts">
import { IonButton, IonItem, IonLabel } from "@ionic/vue";

const router = useRouter();

const goToFaraway = () => {
  router.push("/faraway");
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
