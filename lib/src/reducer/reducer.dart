import 'package:flutter/foundation.dart';
import 'package:movielistwithflutter/src/actions/index.dart';
import 'package:movielistwithflutter/src/models/index.dart';
import 'package:redux/redux.dart';

AppState reducer(AppState state, dynamic action) {
  if (action is! AppAction) {
    throw ArgumentError('All actions should implement AppAction');
  }

  //if(action is ErrorAction)

  if (kDebugMode) {
    print(action);
  }
  final AppState newState = _reducer(state, action);
  if (kDebugMode) {
    print(newState);
  }
  return newState;
}

Reducer<AppState> _reducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, GetMoviesSuccessful>(_getMovieSuccessful),
  TypedReducer<AppState, GetMoviesError>(_getMovieError),
  TypedReducer<AppState, GetMovies>(_getMovie),
  TypedReducer<AppState, UserAction>(_userAction),
  TypedReducer<AppState, UpdateFavoriteStart>(_updateFavoriteStart),
  TypedReducer<AppState, UpdateFavoriteError>(_updateFavoriteError),
]);

AppState _getMovieSuccessful(AppState state, GetMoviesSuccessful action) {
  return state
      .copyWith(movies: <Movie>[...state.movies, ...action.movies], isLoading: false, pageNumber: state.pageNumber + 1);
}

AppState _getMovieError(AppState state, GetMoviesError action) {
  return state.copyWith(isLoading: false);
}

AppState _getMovie(AppState state, GetMovies action) {
  return state.copyWith(isLoading: true);
}

AppState _userAction(AppState state, UserAction action) {
  return state.copyWith(user: action.user);
}

AppState _updateFavoriteStart(AppState state, UpdateFavoriteStart action) {
  final List<int> favoriteMovies = <int>[...state.user!.favoriteMovies];
  if (action.add) {
    favoriteMovies.add(action.id);
  } else {
    favoriteMovies.remove(action.id);
  }
  final AppUser user = state.user!.copyWith(favoriteMovies: favoriteMovies);
  return state.copyWith(user: user);
}

AppState _updateFavoriteError(AppState state, UpdateFavoriteError action) {
  final List<int> favoriteMovies = <int>[...state.user!.favoriteMovies];
  if (action.add) {
    favoriteMovies.remove(action.id);
  } else {
    favoriteMovies.add(action.id);
  }
  final AppUser user = state.user!.copyWith(favoriteMovies: favoriteMovies);
  return state.copyWith(user: user);
}
