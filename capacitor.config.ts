import type { CapacitorConfig } from "@capacitor/cli";

const isDev = process.env.NODE_ENV === "development";

const config: CapacitorConfig = {
  appId: "com.florian.gamescore",
  appName: "game-score",
  webDir: "dist",
  ...(isDev && {
    server: { cleartext: true, url: "http://192.168.1.13:3000" },
  }),
};

export default config;
