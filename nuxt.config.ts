// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: { baseURL: "/", buildAssetsDir: "assets" },

  devtools: { enabled: process.env.NODE_ENV === "development" },

  modules: ["@pinia/nuxt"],

  nitro:
    process.env.NODE_ENV === "development"
      ? {}
      : {
          preset: "static",
          prerender: { routes: ["/"] },
          output: { publicDir: "dist" },
        },

  ssr: process.env.NODE_ENV === "development" ? true : false,

  vite: {
    optimizeDeps: {
      include: [
        "@capacitor/haptics",
        "@vue/devtools-core",
        "@vue/devtools-kit",
        "nanoid",
      ],
    },
  },
});
