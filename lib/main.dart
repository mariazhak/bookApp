import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tab_bloc/cubit.dart';
import 'tab_bloc/state.dart';
import 'darkTheme/darkThemeCubit.dart';
import 'data/themes.dart';
import 'darkTheme/darkThemeState.dart';

void main() {
  runApp(MultiBlocProvider(providers:[
    BlocProvider<TabCubit>(create: (context) => TabCubit()),
    BlocProvider<DarkCubit>(create: (context) => DarkCubit()),
  ],
    child: const MyApp(),));
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkCubit, DarkState>(builder: (context, state)=>
      MaterialApp(
        title: 'Flutter Demo',
        theme: state.darkTheme ? darkTheme : lightTheme,
        home: const MyHomePage(title: 'Book search app'),
      ),);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  void _changeTab(int index, BuildContext context) {
    context.read<TabCubit>().changeTab(index);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _changeTab(_tabController.index, context);
    });
  }

  bool _darkThemeGet(BuildContext context) {
    return context.read<DarkCubit>().state.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        actions: [
          IconButton(
            icon: _darkThemeGet(context)? const Icon(Icons.brightness_4): Icon(Icons.nightlight, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              context.read<DarkCubit>().changeTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<TabCubit, TabState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: state.tabs,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<TabCubit, TabState>(
        builder:(context, state)=> BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  _changeTab(index, context);
                  _tabController.animateTo(index);
                },
                items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.saved_search),
                  label: 'Saved',
                ),
                ],
            ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
