part of '../imports_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocationBloc _locationBloc;

  @override
  void initState() {
    super.initState();
    _locationBloc = LocationBloc();
    _locationBloc.add(GetCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Localização')),
      body: BlocConsumer<LocationBloc, LocationState>(
        bloc: _locationBloc,
        listener: (context, state) {
          if (state is LocationPermissionDenied) {
            if (state.isPermanentlyDenied) {
              _showPermissionDeniedDialog(context);
            }
          } else if (state is LocationLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Localização obtida com sucesso!')),
            );
            print('Latitude: ${state.location.latitude}');
            print('Longitude: ${state.location.longitude}');
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
         
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is LocationLoaded)
                  Column(
                    children: [
                      Text('Latitude: ${state.location.latitude}', style: TextStyle(color: Colors.white),),
                      Text('Longitude: ${state.location.longitude}', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                if (state is LocationLoading)
                  const CircularProgressIndicator(),
                if (state is LocationError)
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (state is LocationInitial)
                  const Text('Obtendo localização...'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                  ),
                  onPressed: () {
                    _locationBloc.add(GetCurrentLocation());
                  },
                  child: const Text('Atualizar Localização', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão necessária'),
        content: const Text(
          'O aplicativo precisa da permissão de localização para funcionar corretamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); 
            },
            child: const Text('Abrir Configurações'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationBloc.close();
    super.dispose();
  }
}