import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/models/unique_sections_model.dart';
import 'package:smart/services/services.dart';

part 'receipts_event.dart';
part 'receipts_state.dart';

class ReceiptsBloc extends Bloc<ReceiptsEvent, ReceiptsState> {
  ReceiptsBloc() : super(ReceiptsInitial());

  @override
  Stream<ReceiptsState> mapEventToState(ReceiptsEvent event) async* {
    ReceiptsListModel receiptsList;
    UniqueReceipts sectionsList;
    if (event is LoadReceiptsEvent) {
      yield ReceiptsLoadingState();
      try {
        receiptsList = await ReceiptsListProvider().getReceiptsList(event.page);
        sectionsList = await ReceiptsListProvider().getReceiptsUniqueSections();
        if (receiptsList.data.isNotEmpty) {
          yield ReceiptsLoadedState(receiptsList, sectionsList);
        } else {
          yield ReceiptsEmptyState();
        }
      } catch (e) {
        yield ReceiptsErrorState();
      }
    }
  }
}
