<template>
  <IonPage>
    <IonContent class="page-content">
      <NuxtPage />
    </IonContent>

    <IonFooter class="footer">
      <IonToolbar>
        <div class="tab-buttons">
          <IonButton fill="clear" @click="go('/')">
            <IonIcon :icon="home" />
            <IonLabel>Accueil</IonLabel>
          </IonButton>

          <IonButton fill="clear" @click="go('/faraway')">
            <IonIcon :icon="gameController" />
            <IonLabel>Faraway</IonLabel>
          </IonButton>
        </div>
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
  IonLabel,
  IonPage,
  IonToolbar,
} from "@ionic/vue";

import { home, gameController } from "ionicons/icons";

const router = useRouter();
const go = (path) => router.push(path);
</script>

<style scoped>
.footer {
  bottom: 0;
  position: fixed;
  width: 100%;
}

.page-content {
  padding-bottom: 70px;
}

.tab-buttons {
  display: flex;
  justify-content: space-around;
  width: 100%;
}
</style>
