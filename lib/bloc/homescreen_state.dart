part of 'homescreen_bloc.dart';

@immutable
sealed class HomescreenState {}

// final class HomescreenInitial extends HomescreenState {
//   final bool batter1isOnStrike = true;
//   final String batter1name = 'Batter1';
//   final int batter1runs = 0;
//   final double batter1strikeRate = 0;
//   final String batter2name = 'Batter2';
//   final int batter2runs = 0;
//   final double batter2strikeRate = 0;
// }

// final class CurrentBatter extends HomescreenState {
//   final bool batter1isOnStrike;
//   final String batter1name;
//   final int batter1runs;
//   late final double batter1strikeRate;
//   final String batter2name;
//   final int batter2runs;
//   late final double batter2strikeRate;

//   CurrentBatter(
//     this.batter1isOnStrike,
//     this.batter1name,
//     this.batter1runs,
//     int batter1ballsPlayed,
//     this.batter2name,
//     this.batter2runs,
//     int batter2ballsPlayed,
//   ) {
//     batter1strikeRate = batter1runs / batter1ballsPlayed * 100;
//     batter2strikeRate = batter2runs / batter2ballsPlayed * 100;
//   }
// }

// final class LoginWaitingState extends HomescreenState {}

final class LoginSuccessFul extends HomescreenState {
  final User user;
  LoginSuccessFul(this.user);
}

final class AccountNotCreated extends HomescreenState {}

final class LoginError extends HomescreenState {
  final String message;
  LoginError(this.message);
}

final class CreateAccountErrorState extends HomescreenState {
  final String message;
  CreateAccountErrorState(this.message);
}

final class CreateAccountSuccessfulState extends HomescreenState {}

final class SignOutSuccessState extends HomescreenState {}

// final class UserPageInitialState extends HomescreenState {
//   final UserCredential userCredential;
//   final List<String> matchName = [];
//   final List<DateTime> dateTime = [];
//   final List<bool> matchInProgress = [];
//   UserPageInitialState(this.userCredential);
// }

final class UserPageState extends HomescreenState {
  final User user;
  final List<String> matchName;
  final List<DateTime> dateTime;
  final List<bool> matchInProgress;
  final String? snackBarMessageOrNull;
  final bool disableButton;

  UserPageState(
    this.user,
    this.matchName,
    this.dateTime,
    this.matchInProgress, {
    this.snackBarMessageOrNull,
    this.disableButton = false,
  });
}

class MatchPageState extends HomescreenState {
  /// There can be maximum two batters on field.
  final String? snackBarMessage;
  final bool disableBackButton;

  final User user;
  final String matchName;
  final DateTime dateTime;
  final String matchId;
  final int maxOvers;
  final bool innings1isInProgress;
  final int innings1runs;
  final int innings1overs;
  final int innings1balls;
  final int innings1wickets;
  final int innings2runs;
  final int innings2overs;
  final int innings2balls;
  final int innings2wickets;
  final String? batterOnStrikeName;
  final String? batter1Name;
  final int batter1run;
  final int batter1ball;
  final String? batter2Name;
  final int batter2run;
  final int batter2ball;

  /// Each sub list consists of values in this order
  /// [Batter, Out ,Runs, Balls, 4, 6]
  // final List<List<String>> batterOnStrikeStats;

  final String? currentBowler;
  final List<String> thisOverStats;

  /// - false means button is unselected
  /// - true means button is selected
  final bool zero;
  final bool one;
  final bool two;
  final bool three;
  final bool four;
  final bool five;
  final bool six;
  final bool bowled;
  final bool catchOut;
  final bool runOutBatter1;
  final bool runOutBatter2;
  final bool noBall;
  final bool wideBall;
  final bool updateScore;

  final bool disableButton;

  MatchPageState({
    required this.snackBarMessage,
    required this.user,
    required this.matchName,
    required this.dateTime,
    required this.matchId,
    required this.maxOvers,
    required this.innings1isInProgress,
    required this.innings1runs,
    required this.innings1overs,
    required this.innings1balls,
    required this.innings1wickets,
    required this.innings2runs,
    required this.innings2overs,
    required this.innings2balls,
    required this.innings2wickets,
    required this.batterOnStrikeName,
    required this.batter1Name,
    required this.batter1run,
    required this.batter1ball,
    required this.batter2Name,
    required this.batter2run,
    required this.batter2ball,
    required this.currentBowler,
    required this.thisOverStats,
    required this.zero,
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.six,
    required this.bowled,
    required this.catchOut,
    required this.runOutBatter1,
    required this.runOutBatter2,
    required this.noBall,
    required this.wideBall,
    required this.updateScore,
    this.disableBackButton = false,
    this.disableButton = false,
  });
}

// class

class BowlerNameListState extends HomescreenState {
  final MatchPageState previousMatchPageState;
  final List<String> bowlerNames;
  final bool disableButton;
  final String? errorMessage;
  BowlerNameListState(
    this.previousMatchPageState,
    this.bowlerNames, {
    this.errorMessage,
    this.disableButton = false,
  });
}

class OpenAddNewBatterPageState extends HomescreenState {
  final bool addingBatter1;
  final MatchPageState previousMatchPageState;
  OpenAddNewBatterPageState(this.addingBatter1, this.previousMatchPageState);
}

class NewBatterAddedSuccessfulState extends HomescreenState {
  final bool addingBatter1;
  final String newBatterName;
  final MatchPageState matchPageState;
  final String? errorOrNullOnSuccess;
  NewBatterAddedSuccessfulState(
    this.addingBatter1,
    this.newBatterName,
    this.matchPageState, {
    this.errorOrNullOnSuccess,
  });
}

class MatchCompletedPageState extends HomescreenState {
  final User user;
  final String matchName;
  final DateTime dateTime;
  final String matchId;
  final int maxOvers;
  final int innings1runs;
  final int innings1overs;
  final int innings1balls;
  final int innings1wickets;
  final int innings2runs;
  final int innings2overs;
  final int innings2balls;
  final int innings2wickets;
  final bool matchAbandoned;
  final String? snackBarMessageOrNull;
  final bool disableButton;

  MatchCompletedPageState({
    required this.user,
    required this.matchName,
    required this.dateTime,
    required this.matchId,
    required this.maxOvers,
    required this.innings1runs,
    required this.innings1overs,
    required this.innings1balls,
    required this.innings1wickets,
    required this.innings2runs,
    required this.innings2overs,
    required this.innings2balls,
    required this.innings2wickets,
    required this.matchAbandoned,
    this.snackBarMessageOrNull,
    this.disableButton = false,
  });
}

///This object contains data to show scorecard of a match
class ScoreCardDataState extends HomescreenState {
  final User user;
  final String matchId;
  final String matchName;
  final DateTime dateTime;

  /// - if innings1inProgress TRUE
  ///   - show scorecard of innings1 only
  /// - else if innings2inProgress TRUE
  ///   - show scorecard of innings1 and innings2 both
  /// - else if innings1inProgress FALSE and innings2inProgress FALSE
  ///   - show scorecard of innings1 and innings2 both
  final bool innings1inProgress;

  /// - if innings1inProgress TRUE
  ///   - show scorecard of innings1 only
  /// - else if innings2inProgress TRUE
  ///   - show scorecard of innings1 and innings2 both
  /// - else if innings1inProgress FALSE and innings2inProgress FALSE
  ///   - show scorecard of innings1 and innings2 both
  final bool innings2inProgress;

  final int maxOvers;

  final int innings1score;
  final int innings1over;
  final int innings1ball;
  final int innings1wicket;
  final int innings1extra;
  final int innings1noBall;
  final int innings1wideBall;

  /// [
  ///   [batterName, catch/runOut/bowled, Runs, Balls, 4s, 6s, Strike Rate]
  /// ]
  final List<List<String>> innings1batterScore;

  /// [
  ///   [bowlerName, Over, Maiden, Runs, Wicket, NoBall, WideBall, Economy]
  /// ]
  final List<List<String>> innings1bowlerScore;

  final int innings2score;
  final int innings2over;
  final int innings2ball;
  final int innings2wicket;
  final int innings2extra;
  final int innings2noBall;
  final int innings2wideBall;

  /// [
  ///   [batterName, catch/runOut/bowled, Runs, Balls, 4s, 6s, Strike Rate]
  /// ]
  final List<List<String>> innings2batterScore;

  /// [
  ///   [bowlerName, Over, Maiden, Runs, Wicket, NoBall, WideBall, Economy]
  /// ]
  final List<List<String>> innings2bowlerScore;

  final bool disableButton;
  final String? errorMessage;

  ScoreCardDataState({
    this.disableButton = false,
    this.errorMessage,
    required this.user,
    required this.matchId,
    required this.matchName,
    required this.dateTime,
    required this.maxOvers,
    required this.innings1inProgress,
    required this.innings2inProgress,
    required this.innings1batterScore,
    required this.innings1score,
    required this.innings1over,
    required this.innings1ball,
    required this.innings1wicket,
    required this.innings1extra,
    required this.innings1noBall,
    required this.innings1wideBall,
    required this.innings1bowlerScore,
    required this.innings2batterScore,
    required this.innings2score,
    required this.innings2over,
    required this.innings2ball,
    required this.innings2wicket,
    required this.innings2extra,
    required this.innings2noBall,
    required this.innings2wideBall,
    required this.innings2bowlerScore,
  });
}

class WaitingForOtpPageState extends HomescreenState {
  final ConfirmationResult? confirmationResult;
  final String? errorMessage;
  final bool disableButton;
  WaitingForOtpPageState({
    required this.confirmationResult,
    this.errorMessage,
    this.disableButton = false,
  });
}

class CreatePasswordForAuthPageState extends HomescreenState {
  final UserCredential userCredential;
  final bool enableCreatePasswordButton;
  final String? errorMessage;
  CreatePasswordForAuthPageState(
    this.userCredential,
    this.enableCreatePasswordButton, {
    this.errorMessage,
  });
}
