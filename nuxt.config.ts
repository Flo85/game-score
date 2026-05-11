// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: {
    baseURL: "/",
    buildAssetsDir: "/assets/",
  },

  compatibilityDate: "2025-07-15",

  devtools: { enabled: true },

  modules: ["@pinia/nuxt"],

  nitro: {
    preset: "static",
    prerender: { crawlLinks: true, routes: ["/"] },
    output: { publicDir: "dist" },
  },

  ssr: false,

  vite: {
    optimizeDeps: {
      include: ["@vue/devtools-core", "@vue/devtools-kit"],
    },
  },
});
