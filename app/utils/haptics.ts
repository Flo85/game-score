import { Capacitor } from "@capacitor/core";
import { Haptics, ImpactStyle } from "@capacitor/haptics";

export async function vibrate(style = ImpactStyle.Light) {
  if (!Capacitor.isNativePlatform()) return;

  try {
    await Haptics.impact({ style });
  } catch (e) {
    console.error("Haptics error:", e);
  }
}
