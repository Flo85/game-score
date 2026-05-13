<template>
  <IonPage>
    <IonContent>
      <slot />
    </IonContent>

    <IonFooter>
      <IonToolbar>
        <IonButtons class="tab-buttons">
          <IonButton color="primary" fill="clear" @click="go('/')">
            <IonIcon :icon="home" slot="start" />
            Accueil
          </IonButton>
          <IonButton color="primary" fill="clear" @click="go('/faraway')">
            <IonIcon :icon="gameController" slot="start" />
            Faraway
          </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonFooter>
  </IonPage>
</template>

<script setup>
import {
  IonButton,
  IonContent,
  IonFooter,
  IonIcon,
  IonPage,
  IonToolbar,
  IonButtons,
} from "@ionic/vue";

import { home, gameController } from "ionicons/icons";

const router = useRouter();
const go = (path) => router.push(path);
</script>

<style scoped>
.tab-buttons {
  justify-content: space-around;
}
</style>
