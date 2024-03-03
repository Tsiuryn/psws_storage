# psws_storage

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
fvm flutter build apk --bundle-sksl-path flutter_01.sksl.json
```

## Release bundle with shaders
```bash
fvm flutter build appbundle --release --bundle-sksl-path flutter_01.sksl.json
```
