import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'soil_reading_event.dart';
import 'soil_reading_state.dart';
import '../../repositories/soil_reading_repository.dart';
import '../../models/soil_reading.dart';

class SoilReadingBloc extends Bloc<SoilReadingEvent, SoilReadingState> {
  final SoilReadingRepository _repository;
  final String userId;
  final bool useRealData; // ✅ get from SettingsBloc
  static const int _pageSize = 10;

  List<SoilReading> _readings = [];
  bool _hasMore = true;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  SoilReadingBloc({
    required this.userId,
    required this.useRealData,
  })  : _repository = SoilReadingRepository(),
        super(SoilReadingInitial()) {
    on<FetchNewReading>(_onFetchNewReading);
    on<LoadMoreReadings>(_onLoadMoreReadings);
    on<ListenToReadings>(_onListenToReadings);
  }

  Future<void> _onFetchNewReading(
      FetchNewReading event, Emitter<SoilReadingState> emit) async {
    emit(SoilReadingLoading());
    try {
      final newReading = await _repository.fetchLatestReading(
        userId: userId,
        useRealData: useRealData, // ✅ fixed
      );
      _readings.insert(0, newReading);
      emit(SoilReadingLoaded(List.from(_readings), _hasMore));
    } catch (e) {
      emit(SoilReadingError("Failed to fetch new reading: $e"));
    }
  }

  Future<void> _onLoadMoreReadings(
      LoadMoreReadings event, Emitter<SoilReadingState> emit) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      final result = await _repository.loadMoreReadings(
        userId: userId,
        limit: _pageSize,
        lastDocument: _lastDocument,
      );

      final List<SoilReading> moreReadings = result['readings'];
      _lastDocument = result['lastDoc'];
      _readings.addAll(moreReadings);

      if (moreReadings.length < _pageSize) {
        _hasMore = false;
      }

      emit(SoilReadingLoaded(List.from(_readings), _hasMore));
    } catch (e) {
      emit(SoilReadingError("Failed to load more readings: $e"));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _onListenToReadings(
      ListenToReadings event, Emitter<SoilReadingState> emit) async {
    try {
      await emit.forEach<List<SoilReading>>(
        _repository.readingStream(userId: userId),
        onData: (readings) {
          _readings = readings;
          _hasMore = true;
          _lastDocument = null;
          return SoilReadingLoaded(List.from(_readings), _hasMore);
        },
        onError: (error, stackTrace) =>
            SoilReadingError("Listening error: $error"),
      );
    } catch (e) {
      emit(SoilReadingError("Failed to listen to readings: $e"));
    }
  }
}
