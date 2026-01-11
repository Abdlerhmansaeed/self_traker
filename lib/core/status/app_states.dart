import 'package:equatable/equatable.dart';

/// Sealed class ensures all states are handled in switch cases.
/// We implement Equatable to ensure Bloc/Cubit only emits distinct states.
sealed class AppStates<T> extends Equatable {
  const AppStates();

  @override
  List<Object?> get props => [];
}

/// Initial State
class AppStatesInitial<T> extends AppStates<T> {}

/// Loading State
/// Enhanced: Now accepts optional [previousData] to support 
/// "Pull to Refresh" patterns without hiding the UI.
class AppStatesLoading<T> extends AppStates<T> {
  final T? previousData;

  const AppStatesLoading([this.previousData]);

  @override
  List<Object?> get props => [previousData];
}

/// Success State
class AppStatesSuccess<T> extends AppStates<T> {
  final T data;

  const AppStatesSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error State
/// Enhanced: Accepts optional [data] if you want to show the 
/// old data alongside a snackbar error.
class AppStatesError<T> extends AppStates<T> {
  final String message;
  final T? data;

  const AppStatesError(this.message, {this.data});

  @override
  List<Object?> get props => [message, data];
}

/// Powerful Extensions for UI Logic
extension AppStatesExtension<T> on AppStates<T> {
  
  // --- Boolean Checks ---
  bool get isInitial => this is AppStatesInitial<T>;
  bool get isLoading => this is AppStatesLoading<T>;
  bool get isSuccess => this is AppStatesSuccess<T>;
  bool get isError => this is AppStatesError<T>;

  // --- Safe Data Access ---
  /// Returns data if Success, or the carried data if Loading/Error.
  /// Useful for preserving UI during refreshes.
  T? get dataOrNull {
    return switch (this) {
      AppStatesSuccess(data: final d) => d,
      AppStatesLoading(previousData: final d) => d,
      AppStatesError(data: final d) => d,
      _ => null,
    };
  }

  /// Returns the error message if present, otherwise null.
  String? get errorOrNull {
    return switch (this) {
      AppStatesError(message: final msg) => msg,
      _ => null,
    };
  }

  // --- Pattern Matching (The "Freezed" Style) ---
  
  /// Forces you to handle all states. returns [R].
  R when<R>({
    required R Function() initial,
    required R Function(T? data) loading,
    required R Function(T data) success,
    required R Function(String error, T? data) error,
  }) {
    return switch (this) {
      AppStatesInitial() => initial(),
      AppStatesLoading(previousData: final d) => loading(d),
      AppStatesSuccess(data: final d) => success(d),
      AppStatesError(message: final m, data: final d) => error(m, d),
    };
  }

  /// Handles only the states you care about, defaults to [orElse].
  R maybeWhen<R>({
    R Function()? initial,
    R Function(T? data)? loading,
    R Function(T data)? success,
    R Function(String error, T? data)? error,
    required R Function() orElse,
  }) {
    return switch (this) {
      AppStatesInitial() => initial != null ? initial() : orElse(),
      AppStatesLoading(previousData: final d) => loading != null ? loading(d) : orElse(),
      AppStatesSuccess(data: final d) => success != null ? success(d) : orElse(),
      AppStatesError(message: final m, data: final d) => error != null ? error(m, d) : orElse(),
    };
  }
}