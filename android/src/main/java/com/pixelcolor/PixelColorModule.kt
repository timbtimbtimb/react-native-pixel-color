package com.pixelcolor

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import android.graphics.BitmapFactory
import android.util.Base64
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.WritableMap

@ReactModule(name = PixelColorModule.NAME)
class PixelColorModule(reactContext: ReactApplicationContext) :
    NativePixelColorSpec(reactContext) {

    override fun getName(): String = NAME

    override fun getPixelColor(base64Png: String, x: Double, y: Double, promise: Promise) {
        try {
            val decodedBytes = Base64.decode(base64Png, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
                ?: throw IllegalArgumentException("Failed to decode base64 image")

            val ix = x.toInt()
            val iy = y.toInt()

            if (ix < 0 || iy < 0 || ix >= bitmap.width || iy >= bitmap.height) {
                throw IllegalArgumentException("Coordinates outside image bounds")
            }

            val pixel = bitmap.getPixel(ix, iy)
            val alpha = (pixel shr 24) and 0xff
            val red = (pixel shr 16) and 0xff
            val green = (pixel shr 8) and 0xff
            val blue = pixel and 0xff

            val map: WritableMap = Arguments.createMap().apply {
                putInt("red", red)
                putInt("green", green)
                putInt("blue", blue)
                putInt("alpha", alpha)
            }

            promise.resolve(map)
        } catch (e: Exception) {
            promise.reject("PixelColorError", e)
        }
    }

    companion object {
        const val NAME = "PixelColor"
    }
}
