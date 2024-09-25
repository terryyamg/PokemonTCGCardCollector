import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pokemon_tcg_card_collector/main/repositories/main_repository.dart';

import '../card/card_page.dart';
import '../colors.dart';
import 'animated_card.dart';
import 'bloc/main_bloc.dart';
import 'bloc/main_event.dart';
import 'bloc/main_state.dart';
import 'language/bloc/language_bloc.dart';
import 'language/bloc/language_state.dart';
import 'settings_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ja', 'zh'],
  );

  runApp(
    Phoenix(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc()..loadSavedLanguage(),
          ),
        ],
        child: LocalizedApp(delegate, const MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageBloc, LanguageState>(
      listenWhen: (previous, current) =>
          previous.languageCode != current.languageCode,
      listener: (context, state) {
        // 當語言改變時，我們可以在這裡執行一些操作
        changeLocale(context, state.languageCode);
      },
      builder: (context, languageState) {
        var localizationDelegate = LocalizedApp.of(context).delegate;

        return LocalizationProvider(
          state: LocalizationProvider.of(context).state,
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: translate('app_title'),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  localizationDelegate,
                ],
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('zh', ''),
                  Locale('ja', ''),
                ],
                locale: Locale(languageState.languageCode),
                theme: ThemeData(
                  primaryColor: appBarColor,
                  scaffoldBackgroundColor: backgroundColor,
                ),
                home: BlocProvider(
                  create: (context) =>
                      MainBloc(MainRepository())..add(LoadMainPokemon()),
                  child: const HomePage(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: iconColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MainBloc>().add(LoadMainPokemon());
            },
            tooltip: translate('refresh'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SettingsDialog(),
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var curve = Curves.easeInOut;
                  var tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                barrierDismissible: true,
                // 允許點擊外部關閉對話框
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black54, // 設置背景遮罩顏色
              );
            },
            tooltip: translate('settings'),
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoading) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: iconColor),
                const SizedBox(height: 16),
                Text(translate('loading'),
                    style: const TextStyle(color: textColor)),
              ],
            ));
          } else if (state is MainLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: state.mainPokemon.length,
              itemBuilder: (context, index) {
                final pokemonList = state.mainPokemon[index];

                return AnimatedCard(
                  imageUrl: pokemonList.imageUrl ?? '',
                  name: translate(pokemonList.name),
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardPage(name: pokemonList.name),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is MainError) {
            return Center(
                child: Text(translate('error_message'),
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: textColor)));
          } else {
            return Center(
                child: Text(translate('initial_message'),
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: textColor)));
          }
        },
      ),
    );
  }
}
