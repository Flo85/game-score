// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: { baseURL: "/", buildAssetsDir: "assets" },

  devtools: { enabled: false },

  modules: ["@pinia/nuxt"],

  nitro: {
    preset: "static",
    prerender: { routes: ["/"] },
    output: { publicDir: "dist" },
  },

  ssr: false,

  vite: {
    optimizeDeps: {
      include: [
        "@capacitor/core",
        "@capacitor/haptics",
        "@capacitor/preferences",
        "@ionic/vue",
        "ionicons/icons",
        "nanoid",
      ],
    },
  },
});
