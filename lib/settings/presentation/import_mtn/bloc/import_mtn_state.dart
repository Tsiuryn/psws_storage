part of 'import_mtn_bloc.dart';

class ImportMtnState {
  final ImportMtnStateType type;

  const ImportMtnState({required this.type});

  ImportMtnState.empty() : type = ImportMtnStateType.initial;

  ImportMtnState copyWith({
    ImportMtnStateType? type,
  }) =>
      ImportMtnState(
        type: type ?? this.type,
      );
}

enum ImportMtnStateType {
  initial,
  loading,
  importSuccess,
  error,
}