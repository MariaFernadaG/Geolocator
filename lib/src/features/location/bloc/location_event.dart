// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class GetCurrentLocation extends LocationEvent {

}

class RequestLocationPermission extends LocationEvent {}
