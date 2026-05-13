<template>
  <IonApp>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </IonApp>
</template>

<script setup>
import { IonApp } from "@ionic/vue";

const farawayGameStore = useFarawayGameStore();

onMounted(() => {
  farawayGameStore.init();
});
</script>
