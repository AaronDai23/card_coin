# image_crop_plus (card_coin fork)

Vendored from [image_crop_plus](https://pub.dev/packages/image_crop_plus) because the pub release still references Flutter’s removed Android V1 embedding (`PluginRegistry.Registrar`).

This is the **only** remaining `vendor/` package. Prefer deleting it once upstream publishes a V2-only Android plugin, or after migrating the crop UI to a maintained alternative (e.g. `image_cropper` / `croppy`).

## Fork changes

- Removed V1 `registerWith(Registrar)` from `ImageCropPlugin.java`.
