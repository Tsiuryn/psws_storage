import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';

class ImportConfig {
  final String password;
  final String path;
  final ImportType type;

  const ImportConfig({
    required this.password,
    required this.path,
    required this.type,
  });
}
