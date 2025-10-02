import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/currency_repository.dart';
import '../data/models/models.dart';
import 'chart_range.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit({required CurrencyRepository repository, required CurrencyPair pair, required DataSource source})
      : _repository = repository,
        super(ChartState.initial(pair).copyWith(dataSource: source));

  final CurrencyRepository _repository;

  Future<void> load({bool force = false}) async {
    emit(state.copyWith(status: ChartStatus.loading));
    try {
      final series = await _repository.loadSeries(
        state.pair,
        state.range,
        state.dataSource,
      );
      if (series.isEmpty) {
        emit(state.copyWith(status: ChartStatus.empty, series: const []));
        return;
      }
      final stats = await _repository.computeStats(series);
      emit(state.copyWith(
        series: series,
        stats: stats,
        status: ChartStatus.loaded,
      ));
    } catch (error) {
      emit(state.copyWith(status: ChartStatus.error, error: error.toString()));
    }
  }

  void changeRange(ChartRange range) {
    emit(state.copyWith(range: range));
    load();
  }

  void changeMode(ChartMode mode) {
    emit(state.copyWith(mode: mode));
  }

  void updatePair(CurrencyPair pair, DataSource source) {
    emit(state.copyWith(pair: pair, dataSource: source));
    load();
  }
}
