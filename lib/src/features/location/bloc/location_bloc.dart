import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_mobile/src/features/location/model/geo_model.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<RequestLocationPermission>(_onRequestLocationPermission);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    
    try {
      // Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit( LocationError('Serviço de localização desativado'));
        return;
      }

      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit( LocationPermissionDenied(isPermanentlyDenied: false));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit( LocationPermissionDenied(isPermanentlyDenied: true));
        return;
      }

      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(LocationLoaded(
        location: GeoModel(
          latitude: position.latitude,
          longitude: position.longitude,
  
          erro: '',
        ),
      ));
    } catch (e) {
      emit(LocationError('Erro ao obter localização: ${e.toString()}'));
    }
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      add(GetCurrentLocation());
    } else {
      emit(LocationPermissionDenied(
        isPermanentlyDenied: status.isPermanentlyDenied,
      ));
    }
  }
}