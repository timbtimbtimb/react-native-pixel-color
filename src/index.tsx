import PixelColor from './NativePixelColor';

export async function getPixelColor(
  base64: string,
  x: number,
  y: number
): Promise<{ red: number; green: number; blue: number; alpha: number }> {
  return await PixelColor.getPixelColor(base64, x, y);
}
