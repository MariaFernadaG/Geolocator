// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final  GeoModel location;
  LocationLoaded({
    required this.location,
  });
  
}
class LocationError extends LocationState {
  final String message;

   LocationError(this.message);

  @override
  List<Object> get props => [message];
}

class LocationPermissionDenied extends LocationState {
  final bool isPermanentlyDenied;

 LocationPermissionDenied({required this.isPermanentlyDenied});

  @override
  List<Object> get props => [isPermanentlyDenied];
}
