import 'package:flutter_github/material.dart';
import 'package:flutter_github/bloc/repo_search/repo_search.dart';

class RepoSearchProvider extends InheritedWidget {
  final RepoSearchBloc searchBloc;

  const RepoSearchProvider(
    this.searchBloc, {
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static RepoSearchProvider of(BuildContext context) {
    return context.ancestorInheritedElementForWidgetOfExactType(RepoSearchProvider).widget as RepoSearchProvider;
  }

  @override
  bool updateShouldNotify(RepoSearchProvider old) {
    return this != old;
  }
}
