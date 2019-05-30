abstract class RepoSearchEvent {
  final String searchTerm;

  RepoSearchEvent(this.searchTerm);
}

class AddSearch extends RepoSearchEvent {
  AddSearch(String searchTerm) : super(searchTerm);
}

class LoadSearch extends RepoSearchEvent {
  LoadSearch(String searchTerm) : super(searchTerm);
}