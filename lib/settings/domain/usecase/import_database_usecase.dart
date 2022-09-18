import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/domain/gateway/import_export_gateway.dart';

class ImportDatabaseUseCase {
  final ImportExportGateway _importExport;

  const ImportDatabaseUseCase(ImportExportGateway importExport)
      : _importExport = importExport;

  Future<void> call(ImportConfig config) =>
      _importExport.importDataBase(config);
}
