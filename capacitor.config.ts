/// <reference types="node" />
import type { CapacitorConfig } from "@capacitor/cli";

const isDev = process.env.NODE_ENV === "development";

const getDevServerUrl = () =>
  process.env.CAP_EMULATOR === "true"
    ? "http://10.0.2.2:3000"
    : "http://192.168.1.13:3000";

const config: CapacitorConfig = {
  appId: "com.florian.gamescore",
  appName: "game-score",
  webDir: "dist",
  ...(isDev && {
    server: { cleartext: true, url: getDevServerUrl() },
  }),
};

export default config;
