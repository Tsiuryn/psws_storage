import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/gateway/import_export_gateway.dart';

class ExportDatabaseUseCase {
  final ImportExportGateway _importExport;

  const ExportDatabaseUseCase(ImportExportGateway importExport)
      : _importExport = importExport;

  Future<void> call(ExportConfig config) =>
      _importExport.exportDataBase(config);
}
