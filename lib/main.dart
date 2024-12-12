import 'package:church_service_planner/features/service_planning/presentation/cubit/service_planning_cubit.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/cubit/volunteer_coordination_cubit.dart';
import 'package:church_service_planner/features/volunteer_coordination/presentation/view_all_volunteer_assignment_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/injection_container.dart';
import 'features/service_planning/presentation/view_all_service_plan_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase initialization
  );

  await init();
  runApp(const MyApp()); // Run the app with MyApp as the root widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Roboto", // Custom font family
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'), // Home widget
      debugShowCheckedModeBanner: false, // Disables the debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) => serviceLocator<ServicePlanCubit>(),
            child: const ViewAllServicePlanPage(),
          ),
          const Center(
            child: Text('EUSEDIO III T. VILLATO & MARTIN LLORAG, BSCS 4A '),
          ),
          BlocProvider(
            create: (context) => serviceLocator<VolunteerAssignmentCubit>(),
            child: const ViewAllVolunteerAssignmentPage(),
          ),
          const Center(
            child: Text('Insert Profile Page here'),
          ),
        ],
      ), // Main content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Default to the first tab
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Church Service Plans",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: "Volunteer Assignment",
          ),
        ],
      ),
    );
  }
}
