import 'package:virtual_gaming_app/models/bet/bet_model.dart';
import 'package:virtual_gaming_app/services/storage_service.dart';
import 'package:virtual_gaming_app/utils/app_logger.dart';


class HistoryController {
  final StorageService _storageService;

  HistoryController(this._storageService);

  List<BetModel> getHistory(String userId) {
    AppLogger.info(
      'Loading bet history for current user',
    );

    return _storageService.getBets(userId);
  }

  Future<void> saveBet(BetModel bet) async {
    await _storageService.saveBet(bet);

    AppLogger.info(
      'Bet history updated',
    );
  }
}