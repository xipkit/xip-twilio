# Twilio SMS and Whatsapp Xip Kit Component

The [Xip Kit](https://github.com/xipkit/xip) Twilio SMS and Whatsapp component adds the ability to connect your bot to the Whatsapp and SMS platforms.

[![Gem Version](https://badge.fury.io/rb/xip-twilio.svg)](https://badge.fury.io/rb/xip-twilio)

## Supported Reply Types

* Text
* Image
* Audio
* Video
* File
* Delay

Image, Audio, Video, and File reply types will leverage the MMS protocol. It is recommended by Twilio that
the content is limited to images, however, this is the full list of supported content types: https://www.twilio.com/docs/api/messaging/accepted-mime-types.

If you store your files on S3, please make sure you have set the `content-type` appropriately or Twilio might reject your media.
