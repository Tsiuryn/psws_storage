# PSWS Storage

[<img src="https://github.com/Tsiuryn/psws_storage/blob/master/assets/src/google-play.png">](https://play.google.com/store/apps/details?id=com.tsiuryn.psws_storage)

- [Release app](https://docs.flutter.dev/deployment/android)

## Write shaders

- [Shader compilation jank](https://docs.flutter.dev/perf/shader)

```bash
fvm flutter run --profile --cache-sksl
```
```bash
fvm flutter run --profile --cache-sksl --purge-persistent-cache
```

## Release apk with shaders
```bash
fvm flutter build apk --flavor=prod  --obfuscate --split-debug-info=build/debug-info
```

## Release bundle with shaders
```bash
fvm flutter build appbundle --release --flavor=prod --obfuscate --split-debug-info=build/debug-info
```
