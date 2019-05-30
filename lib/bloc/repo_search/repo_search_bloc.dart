import 'package:bloc/bloc.dart';
import 'package:flutter_github/bloc/repo_search/repo_search.dart';
import 'package:graphql_dart/graphql_dart.dart';
import 'package:flutter_github/github_api/github_api.dart';

class RepoSearchBloc extends Bloc<RepoSearchEvent, RepoSearchState> {
  final GQLClient client;

  RepoSearchBloc(this.client);

  @override
  RepoSearchState get initialState => RepoSearchState();

  @override
  Stream<RepoSearchState> mapEventToState(RepoSearchEvent event) async* {
    if (event is AddSearch) {
      final updated = currentState.rebuild((b) {
        b.searchMap.update((b) {
          b[event.searchTerm] = SearchQueryStateUnloaded();
        });
      });
      print(updated);
      yield updated;
    } else if (event is LoadSearch) {
      final inFlight = currentState.rebuild((b) {
        b.searchMap.update((b) {
          b[event.searchTerm] = SearchQueryStateLoading();
        });
      });
      yield inFlight;
      try {
        final searchResults = await searchRepos(client, SearchReposInput(queryString: event.searchTerm, first: 20, avatarSize: 250));
        final updated = currentState.rebuild((b) {
                b.searchMap.update((b) {
                  b[event.searchTerm] = SearchQueryStateLoaded(searchResults.search.nodes.cast<Repository>().toList());
                });
              });
        yield updated;
      } catch (e) {
        print("failed to load repos: $e");
        final failed = currentState.rebuild((b) {
          b.searchMap.update((b) {
            b[event.searchTerm] = SearchQueryStateLoadFailed();
          });
        });
        yield failed;
      }
    }
  }
}
