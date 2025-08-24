import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getPixelColor(
    base64Png: string,
    x: number,
    y: number
  ): Promise<{ red: number; green: number; blue: number; alpha: number }>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('PixelColor');
