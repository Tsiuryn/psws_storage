import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';

abstract class ImportExportGateway {
  Future<void> exportDataBase(ExportConfig config);

  Future<void> importDataBase(ImportConfig config);
}
