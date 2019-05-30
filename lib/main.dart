import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/repo_search_provider.dart';
import 'package:graphql_dart/graphql_dart.dart';
import 'package:http/http.dart';

import 'bloc/repo_search/repo_search.dart';
import 'github_api/github_api.dart';
import 'github_api_extensions/discriminator.dart' as Discriminator;

void main() async {
  BlocSupervisor.delegate = BasicBlocDelegate();
  Discriminator.setupDiscriminator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RepoSearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    _initializeClient();
  }

  @override
  void dispose() {
    searchBloc.dispose();
    super.dispose();
  }

  void _initializeClient() async {
    final client = Client();
    final url = "https://api.github.com/graphql";
    final token = await DefaultAssetBundle.of(context).loadString("assets/.github_key.txt");
    setState(() {
      final gqlClient = GQLClient(client, url, "Bearer $token");
      searchBloc = RepoSearchBloc(gqlClient);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (searchBloc == null) {
      return MaterialApp(
        title: 'GitHub Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return RepoSearchProvider(
        searchBloc,
        child: MaterialApp(
          title: 'GitHub Search',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(
            title: 'GitHub Search',
          ),
        ),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _newRepoSearch() {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              String searchTerm;
              return AlertDialog(
                title: Text("New Repo Search"),
                content: TextField(
                  onChanged: (text) {
                    searchTerm = text;
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(searchTerm);
                      },
                      child: Text("Search")),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = RepoSearchProvider.of(context).searchBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RepoSearchList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final term = await _newRepoSearch();
          searchBloc.dispatch(AddSearch(term));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class RepoSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchBloc = RepoSearchProvider.of(context).searchBloc;
    return StreamBuilder<RepoSearchState>(
      stream: searchBloc.state,
      initialData: searchBloc.currentState,
      builder: (context, searchState) {
        final searchTerms = searchState.data.searchMap.keys.toList();
        return ListView.separated(
            itemBuilder: (context, i) {
              final term = searchTerms[i];
              return ListTile(
                key: Key(term),
                title: Text(term),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return RepoResultsList(
                      searchTerm: term,
                    );
                  }));
                },
              );
            },
            separatorBuilder: (context, i) {
              return Divider();
            },
            itemCount: searchTerms.length);
      },
    );
  }
}

class RepoResultsList extends StatefulWidget {
  final String searchTerm;

  const RepoResultsList({Key key, this.searchTerm}) : super(key: key);

  @override
  _RepoResultsListState createState() => _RepoResultsListState();
}

class _RepoResultsListState extends State<RepoResultsList> {
  RepoSearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    searchBloc = RepoSearchProvider.of(context).searchBloc;
    if (searchBloc.currentState.searchMap[widget.searchTerm] is SearchQueryStateUnloaded) {
      searchBloc.dispatch(LoadSearch(widget.searchTerm));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchTerm),
      ),
      body: StreamBuilder<RepoSearchState>(
          stream: searchBloc.state,
          initialData: searchBloc.currentState,
          builder: (context, searchStateSnapshot) {
            final searchState = searchStateSnapshot.data.searchMap[widget.searchTerm];
            if (searchState is SearchQueryStateUnloaded || searchState is SearchQueryStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (searchState is SearchQueryStateLoadFailed) {
              return Center(
                child: RaisedButton(
                  onPressed: () {
                    searchBloc.dispatch(LoadSearch(widget.searchTerm));
                  },
                  child: Text("Retry"),
                ),
              );
            } else {
              final SearchQueryStateLoaded loaded = searchState;
              final repos = loaded.repositories;
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final repo = repos[index];
                    return ListTile(
                      key: Key(repo.sshUrl),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(repo.owner.avatarUrl),
                      ),
                      title: Text(repo.name),
                      subtitle: Text(repo.sshUrl),
                      trailing: RepoStars(repo),
                      onTap: () {
//                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                          return RepositoryDetails(
//                            repo: repo,
//                          );
//                        }));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: repos.length);
            }
          }),
    );
  }
}

class RepoStars extends StatelessWidget {
  final Repository repo;

  const RepoStars(
    this.repo, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(constraints.biggest.height),
            border: Border.all(color: Colors.black54),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(repo.viewerHasStarred ? Icons.star : Icons.star_border),
                Text(
                  repo.stargazers.totalCount.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BasicBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }
}
