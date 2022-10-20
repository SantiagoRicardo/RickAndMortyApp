import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage ({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {

  //Permite envolver los valores booleanos en una lista, para poder iterarlos 
  //y darles valores false iniciales
  List<bool> click =[];
  //Query
  final String getCharacters = """
    query getCharacters{
      characters (page:1) {
        results {
          name	
          status
          episode{
            name
          }
          location {
            name
          }
          image
        }
      },
  }
  """;

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
          appBar: AppBar(
            title: const Text('Rick and Morty App'),
            backgroundColor: Colors.black,
      ),
      body: Query( options: QueryOptions(
        document: gql(getCharacters)
        ), builder: (QueryResult result, { fetchMore, refetch }) {

          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
          }
          List characters = result.data!["characters"]["results"];
          print(characters);
          return ListView.builder(
            itemCount: characters.length, 
            itemBuilder: (context, int index) {

              final characterName = characters[index]["name"];
              final characterStatus = characters[index]["status"];
              final characterImage = characters[index]["image"];
              final characterEpisodes = characters[index]["episodes"];
              click.add(false);

              return ListTile(
                leading: Image.network(characterImage),
                title: Text(characterName),
                subtitle: Text(characterStatus, ),
                trailing: Icon( click[index] ? Icons.favorite : Icons.favorite_border),
                onTap: () { 
                 getPreferences(index);
                 });
                },
              );
        })
    );
    
  }

  //Funcion que permite iterar en cada valor booleano
  //En su defecto cambiar su estado

  Future<void> getPreferences (int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.get("_click") ?? true;
    setState(() {
      click[id] = !click[id];
    });
  } 
  
}