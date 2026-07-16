import 'failures.dart';

class GlobalErrorHandler {
  GlobalErrorHandler._();

  static String getUserFriendlyMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => 'A server error occurred. Please try again later.',
      NetworkFailure() => 'No internet connection. Please check your network.',
      DatabaseFailure() => 'A database error occurred.',
      CacheFailure() => 'Something went wrong with local storage.',
      ValidationFailure() => failure.message,
      AuthFailure() => 'Authentication failed. Please sign in again.',
      UnknownFailure() => 'Something went wrong. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}
