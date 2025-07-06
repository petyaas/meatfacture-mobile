import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class CatalogRebuildCubit extends Cubit<CatalogRebuildState> {
  CatalogRebuildCubit() : super(CatalogRebuildInitial());

  rebuild() {
    emit(CatalogRebuildInitial());
    emit(CatalogRebuildLoaded());
  }
}

@immutable
class CatalogRebuildState {}

class CatalogRebuildInitial extends CatalogRebuildState {}

class CatalogRebuildLoaded extends CatalogRebuildState {}
