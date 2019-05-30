import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter_github/github_api/github_api.dart';

part 'repo_search_state.g.dart';

abstract class RepoSearchState implements Built<RepoSearchState, RepoSearchStateBuilder> {
  RepoSearchState._();

  BuiltMap<String, SearchQueryState> get searchMap;

  factory RepoSearchState([updates(RepoSearchStateBuilder b)]) = _$RepoSearchState;
}

abstract class SearchQueryState {}

class SearchQueryStateUnloaded extends SearchQueryState {}

class SearchQueryStateLoading extends SearchQueryState {}

class SearchQueryStateLoaded extends SearchQueryState {
  final List<Repository> repositories;

  SearchQueryStateLoaded(this.repositories);
}

class SearchQueryStateLoadFailed extends SearchQueryState {}
