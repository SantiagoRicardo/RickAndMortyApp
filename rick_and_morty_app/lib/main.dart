import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/pages/home_screen.dart';
 
void main() async {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  
  final HttpLink rickAndMorty =
        HttpLink('https://rickandmortyapi.com/graphql');

  @override
  Widget build(BuildContext context) {

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: rickAndMorty,
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: HomePage(),
        
      ),
    );
  }
}