import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/carrinho_provider.dart';
import 'screens/catalogo_screen.dart';
import 'screens/carrinho_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provider que gerencia o estado global do carrinho
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoProvider()),
      ],
      child: MaterialApp(
        title: 'Carrinho de Compras',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const CatalogoScreen(),
          '/carrinho': (context) => const CarrinhoScreen(),
        },
      ),
    );
  }
}
