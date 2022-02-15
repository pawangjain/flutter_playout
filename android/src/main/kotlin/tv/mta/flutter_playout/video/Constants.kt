package tv.mta.flutter_playout.video

const val AES_ALGORITHM = "AES"
const val AES_TRANSFORMATION = "AES/CBC/PKCS7Padding"

class Constants {
    val secretKey = "85BE62F9AC34D107".map { it.toByte() }.toByteArray()

    companion object {
        lateinit var secretKey: ByteArray
    }
}