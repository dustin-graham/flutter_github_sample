// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_search_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RepoSearchState extends RepoSearchState {
  @override
  final BuiltMap<String, SearchQueryState> searchMap;

  factory _$RepoSearchState([void Function(RepoSearchStateBuilder) updates]) =>
      (new RepoSearchStateBuilder()..update(updates)).build();

  _$RepoSearchState._({this.searchMap}) : super._() {
    if (searchMap == null) {
      throw new BuiltValueNullFieldError('RepoSearchState', 'searchMap');
    }
  }

  @override
  RepoSearchState rebuild(void Function(RepoSearchStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RepoSearchStateBuilder toBuilder() =>
      new RepoSearchStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RepoSearchState && searchMap == other.searchMap;
  }

  @override
  int get hashCode {
    return $jf($jc(0, searchMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RepoSearchState')
          ..add('searchMap', searchMap))
        .toString();
  }
}

class RepoSearchStateBuilder
    implements Builder<RepoSearchState, RepoSearchStateBuilder> {
  _$RepoSearchState _$v;

  MapBuilder<String, SearchQueryState> _searchMap;
  MapBuilder<String, SearchQueryState> get searchMap =>
      _$this._searchMap ??= new MapBuilder<String, SearchQueryState>();
  set searchMap(MapBuilder<String, SearchQueryState> searchMap) =>
      _$this._searchMap = searchMap;

  RepoSearchStateBuilder();

  RepoSearchStateBuilder get _$this {
    if (_$v != null) {
      _searchMap = _$v.searchMap?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RepoSearchState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RepoSearchState;
  }

  @override
  void update(void Function(RepoSearchStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RepoSearchState build() {
    _$RepoSearchState _$result;
    try {
      _$result = _$v ?? new _$RepoSearchState._(searchMap: searchMap.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'searchMap';
        searchMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RepoSearchState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
