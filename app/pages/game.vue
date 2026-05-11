<template>
  <div>Page des scores</div>
</template>

<script setup lang="ts">
const route = useRoute();
const players = JSON.parse((route.query.players as string | undefined) || "[]");
</script>
