import 'package:new_chess/firebase_options.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/utils/routes/routes.dart';
import 'package:new_chess/view_model/services/game_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/routes/routes_name.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
double height = 0.0;
double width = 0.0;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (ctx)=> GameController()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chess',
          initialRoute: RoutesName.splash,
          onGenerateRoute: (settings) {
            if (settings.name != null) {
              return MaterialPageRoute(
                builder: Routers.generateRoute(settings.name!),
                settings: settings,
              );
            }
            return null;
          },
        ),
    );
  }
}

