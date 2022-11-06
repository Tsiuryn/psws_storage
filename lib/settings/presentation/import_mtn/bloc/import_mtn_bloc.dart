import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/editor/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/settings/presentation/import_mtn/util/path_importer.dart';

part 'import_mtn_state.dart';

class ImportMtnBloc extends Cubit<ImportMtnState> {
  final AddFileUseCase addFileUseCase;

  ImportMtnBloc({required this.addFileUseCase}) : super(ImportMtnState.empty());

  Future<void> convertMtnText(String sourceText) async {
    try {
      emit(state.copyWith(type: ImportMtnStateType.loading));
      final importer = PathImporter(sourceText);
      final listDirectory = importer.convert();

      for (var element in listDirectory) {
        await addFileUseCase(element);
      }

      emit(state.copyWith(type: ImportMtnStateType.importSuccess));
    } catch (e) {
      emit(state.copyWith(type: ImportMtnStateType.error));
    }
  }
}

enum Process {
  error,
  success,
}
