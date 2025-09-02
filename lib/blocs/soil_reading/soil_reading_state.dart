import '../../models/soil_reading.dart';

abstract class SoilReadingState {}

class SoilReadingInitial extends SoilReadingState {}

class SoilReadingLoading extends SoilReadingState {}

class SoilReadingLoaded extends SoilReadingState {
  final List<SoilReading> readings;
  final bool hasMore;

  SoilReadingLoaded(this.readings, this.hasMore);
}

class SoilReadingError extends SoilReadingState {
  final String message;
  SoilReadingError(this.message);
}
