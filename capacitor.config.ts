import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.florian.gamescore",
  appName: "game-score",
  server: { cleartext: true, url: "http://192.168.1.13:3000" },
  webDir: "dist",
};

export default config;
