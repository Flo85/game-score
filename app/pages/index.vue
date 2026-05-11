<template>
  <div class="home">
    <h1>Nouvelle partie</h1>

    <!-- Sélecteur du nombre de joueurs -->
    <label>Nombre de joueurs</label>
    <select
      v-model="gameStore.count"
      @change="gameStore.setCount(gameStore.count)"
    >
      <option v-for="n in 6" :key="n" :value="n">{{ n }}</option>
    </select>

    <!-- Champs des noms -->
    <div class="players">
      <div
        v-for="(player, i) in gameStore.players"
        :key="i"
        class="player-input"
      >
        <input
          type="text"
          :placeholder="`Joueur ${i + 1}`"
          v-model="player.name"
        />
      </div>
    </div>

    <button class="start" @click="startGame">Commencer la partie</button>
  </div>
</template>

<script setup lang="ts">
const gameStore = useGameStore();
const router = useRouter();

const startGame = () => {
  console.log("Joueurs :", gameStore.players);
  router.push("/score");
};
</script>

<style scoped>
.home {
  padding: 20px;
  max-width: 400px;
  margin: auto;
}

label {
  font-weight: 600;
  margin-bottom: 8px;
  display: block;
}

select {
  width: 100%;
  padding: 10px;
  margin-bottom: 20px;
}

.players {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.player-input input {
  width: 100%;
  padding: 10px;
  font-size: 16px;
}

.start {
  margin-top: 30px;
  width: 100%;
  padding: 14px;
  background: #007aff;
  color: white;
  border-radius: 8px;
  font-size: 18px;
}
</style>
