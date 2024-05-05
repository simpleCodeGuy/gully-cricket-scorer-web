import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gully_cricket_scorer/data/data_repository.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:meta/meta.dart';

part 'homescreen_event.dart';
part 'homescreen_state.dart';

class HomescreenBloc extends Bloc<HomescreenEvent, HomescreenState> {
  User? get user => FirebaseAuth.instance.currentUser;
  final DataRepository _dataRepository;

  HomescreenBloc(this._dataRepository)
      : super(WaitingForOtpPageState(
          confirmationResult: null,
        )) {
    // on<HomescreenEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<SignOutEvent>(
      (event, emit) async {
        await FirebaseAuth.instance.signOut();
        // log.i('sign out success');
        emit(SignOutSuccessState());
      },
    );

    on<UserPageCreateEvent>((event, emit) async {
      if (state.runtimeType == MatchCompletedPageState) {
        final matchCompletedPageState = state as MatchCompletedPageState;

        emit(MatchCompletedPageState(
          disableButton: true,
          user: matchCompletedPageState.user,
          matchName: matchCompletedPageState.matchName,
          dateTime: matchCompletedPageState.dateTime,
          matchId: matchCompletedPageState.matchId,
          maxOvers: matchCompletedPageState.maxOvers,
          innings1runs: matchCompletedPageState.innings1runs,
          innings1overs: matchCompletedPageState.innings1overs,
          innings1balls: matchCompletedPageState.innings1balls,
          innings1wickets: matchCompletedPageState.innings1wickets,
          innings2runs: matchCompletedPageState.innings2runs,
          innings2overs: matchCompletedPageState.innings2overs,
          innings2balls: matchCompletedPageState.innings2balls,
          innings2wickets: matchCompletedPageState.innings2wickets,
          matchAbandoned: matchCompletedPageState.matchAbandoned,
        ));
      } else if (state.runtimeType == MatchPageState) {
        final matchPageState = state as MatchPageState;

        emit(MatchPageState(
          snackBarMessage: null,
          disableButton: true,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      }

      try {
        final db = FirebaseFirestore.instance;

        // final String uid = event.user.uid;

        final userPageState = await FireStoreData.fetchUserPageState(
            db: db,
            user: event.user,
            timeout: getRepository().getTimers().firebaseTransactionTimeout);

        // log.f(matchName);
        // log.f(dateTime);
        // log.f(matchInProgress);

        // emit(UserPageState(event.user, matchName, dateTime, matchInProgress));
        emit(UserPageState(
          userPageState.user,
          userPageState.matchName,
          userPageState.dateTime,
          userPageState.matchInProgress,
        ));
      } catch (e) {
        if (event.runtimeType == MatchCompletedPageState) {
          final matchPageCompletedState = state as MatchCompletedPageState;
          emit(MatchCompletedPageState(
            user: matchPageCompletedState.user,
            matchName: matchPageCompletedState.matchName,
            dateTime: matchPageCompletedState.dateTime,
            matchId: matchPageCompletedState.matchId,
            maxOvers: matchPageCompletedState.maxOvers,
            innings1runs: matchPageCompletedState.innings1runs,
            innings1overs: matchPageCompletedState.innings1overs,
            innings1balls: matchPageCompletedState.innings1balls,
            innings1wickets: matchPageCompletedState.innings1wickets,
            innings2runs: matchPageCompletedState.innings2runs,
            innings2overs: matchPageCompletedState.innings2overs,
            innings2balls: matchPageCompletedState.innings2balls,
            innings2wickets: matchPageCompletedState.innings2wickets,
            matchAbandoned: matchPageCompletedState.matchAbandoned,
            snackBarMessageOrNull: e.toString(),
          ));
        }
      }
    });

    on<OpenUserPageFromMatchPageEvent>((event, emit) {
      add(UserPageCreateEvent(_dataRepository.getUser()));
    });

    on<OpenUserPageFromMatchCompletedPageEvent>((event, emit) {
      add(UserPageCreateEvent(_dataRepository.getUser()));
    });

    on<CreateNewMatchEvent>((event, emit) async {
      try {
        final db = FirebaseFirestore.instance;

        if (state.runtimeType == UserPageState) {
          final userPageState = state as UserPageState;
          emit(UserPageState(
            userPageState.user,
            userPageState.matchName,
            userPageState.dateTime,
            userPageState.matchInProgress,
            disableButton: true,
          ));
        }

        final newMatchData = await FireStoreData.createNewMatch(
          db,
          event.user,
          event.teamBattingFirstName,
          event.teamBattingSecondName,
          event.maxOvers,
          timeout: getRepository().getTimers().firebaseTransactionTimeout,
        );

        emit(MatchPageState(
          snackBarMessage: null,
          user: newMatchData.user,
          matchName: newMatchData.matchName,
          dateTime: newMatchData.dateTime,
          matchId: newMatchData.matchId,
          maxOvers: newMatchData.maxOvers,
          innings1isInProgress: newMatchData.innings1isInProgress,
          innings1runs: newMatchData.innings1runs,
          innings1overs: newMatchData.innings1overs,
          innings1balls: newMatchData.innings1balls,
          innings1wickets: newMatchData.innings1wickets,
          innings2runs: newMatchData.innings2runs,
          innings2overs: newMatchData.innings2overs,
          innings2balls: newMatchData.innings2balls,
          innings2wickets: newMatchData.innings2wickets,
          batterOnStrikeName: newMatchData.batterOnStrikeName,
          batter1Name: newMatchData.batter1Name,
          batter1run: newMatchData.batter1run,
          batter1ball: newMatchData.batter1ball,
          batter2Name: newMatchData.batter2Name,
          batter2run: newMatchData.batter2run,
          batter2ball: newMatchData.batter2ball,
          currentBowler: newMatchData.currentBowler,
          thisOverStats: newMatchData.thisOverStats,
          zero: true,
          one: false,
          two: false,
          three: false,
          four: false,
          five: false,
          six: false,
          bowled: false,
          catchOut: false,
          runOutBatter1: false,
          runOutBatter2: false,
          noBall: false,
          wideBall: false,
          updateScore: false,
        ));
      } catch (e) {
        final userPageState = state as UserPageState;
        // emit(userPageState);

        emit(UserPageState(
          userPageState.user,
          userPageState.matchName,
          userPageState.dateTime,
          userPageState.matchInProgress,
          snackBarMessageOrNull: e.toString(),
        ));
      }
    });

    on<OpenExistingMatchEvent>((event, emit) async {
      final db = FirebaseFirestore.instance;

      if (state.runtimeType == UserPageState) {
        final userPageState = state as UserPageState;
        emit(UserPageState(
          userPageState.user,
          userPageState.matchName,
          userPageState.dateTime,
          userPageState.matchInProgress,
          disableButton: true,
        ));
      } else if (state.runtimeType == ScoreCardDataState) {
        final scoreCardDataState = state as ScoreCardDataState;
        emit(ScoreCardDataState(
          disableButton: true,
          user: scoreCardDataState.user,
          matchId: scoreCardDataState.matchId,
          matchName: scoreCardDataState.matchName,
          dateTime: scoreCardDataState.dateTime,
          maxOvers: scoreCardDataState.maxOvers,
          innings1inProgress: scoreCardDataState.innings1inProgress,
          innings2inProgress: scoreCardDataState.innings2inProgress,
          innings1batterScore: scoreCardDataState.innings1batterScore,
          innings1score: scoreCardDataState.innings1score,
          innings1over: scoreCardDataState.innings1over,
          innings1ball: scoreCardDataState.innings1ball,
          innings1wicket: scoreCardDataState.innings1wicket,
          innings1extra: scoreCardDataState.innings1extra,
          innings1noBall: scoreCardDataState.innings1noBall,
          innings1wideBall: scoreCardDataState.innings1wideBall,
          innings1bowlerScore: scoreCardDataState.innings1bowlerScore,
          innings2batterScore: scoreCardDataState.innings2batterScore,
          innings2score: scoreCardDataState.innings2score,
          innings2over: scoreCardDataState.innings2over,
          innings2ball: scoreCardDataState.innings2ball,
          innings2wicket: scoreCardDataState.innings2wicket,
          innings2extra: scoreCardDataState.innings2extra,
          innings2noBall: scoreCardDataState.innings2noBall,
          innings2wideBall: scoreCardDataState.innings2wideBall,
          innings2bowlerScore: scoreCardDataState.innings2bowlerScore,
        ));
      }

      if (event.matchInProgress) {
        final matchStats = await FireStoreData.getStatsOfExistingMatch(
          event.user,
          event.matchName,
          event.dateTime,
          getRepository().getTimers().firebaseTransactionTimeout,
        );

        if (matchStats.snackBarMessage == null) {
          emit(MatchPageState(
            snackBarMessage: matchStats.snackBarMessage,
            user: event.user,
            matchName: event.matchName,
            dateTime: event.dateTime,
            matchId: matchStats.matchId,
            maxOvers: matchStats.maxOvers,
            innings1isInProgress: matchStats.innings1inProgress,
            innings1runs: matchStats.innings1runs,
            innings1overs: matchStats.innings1overs,
            innings1balls: matchStats.innings1balls,
            innings1wickets: matchStats.innings1wickets,
            innings2runs: matchStats.innings2runs,
            innings2overs: matchStats.innings2overs,
            innings2balls: matchStats.innings2balls,
            innings2wickets: matchStats.innings2wickets,
            batterOnStrikeName: matchStats.batterOnStrikeName,
            batter1Name: matchStats.batter1Name,
            batter1run: matchStats.batter1run,
            batter1ball: matchStats.batter1ball,
            batter2Name: matchStats.batter2Name,
            batter2run: matchStats.batter2run,
            batter2ball: matchStats.batter2ball,
            currentBowler: matchStats.currentBowler,
            thisOverStats: matchStats.thisOverStats,
            zero: true,
            one: false,
            two: false,
            three: false,
            four: false,
            five: false,
            six: false,
            bowled: false,
            catchOut: false,
            runOutBatter1: false,
            runOutBatter2: false,
            noBall: false,
            wideBall: false,
            updateScore: false,
          ));
        } else {
          if (state.runtimeType == UserPageState) {
            final userPageState = state as UserPageState;
            emit(UserPageState(
              userPageState.user,
              userPageState.matchName,
              userPageState.dateTime,
              userPageState.matchInProgress,
              snackBarMessageOrNull: matchStats.snackBarMessage,
            ));
          } else if (state.runtimeType == ScoreCardDataState) {
            final scoreCardDataState = state as ScoreCardDataState;
            emit(ScoreCardDataState(
              errorMessage: matchStats.snackBarMessage,
              user: scoreCardDataState.user,
              matchId: scoreCardDataState.matchId,
              matchName: scoreCardDataState.matchName,
              dateTime: scoreCardDataState.dateTime,
              maxOvers: scoreCardDataState.maxOvers,
              innings1inProgress: scoreCardDataState.innings1inProgress,
              innings2inProgress: scoreCardDataState.innings2inProgress,
              innings1batterScore: scoreCardDataState.innings1batterScore,
              innings1score: scoreCardDataState.innings1score,
              innings1over: scoreCardDataState.innings1over,
              innings1ball: scoreCardDataState.innings1ball,
              innings1wicket: scoreCardDataState.innings1wicket,
              innings1extra: scoreCardDataState.innings1extra,
              innings1noBall: scoreCardDataState.innings1noBall,
              innings1wideBall: scoreCardDataState.innings1wideBall,
              innings1bowlerScore: scoreCardDataState.innings1bowlerScore,
              innings2batterScore: scoreCardDataState.innings2batterScore,
              innings2score: scoreCardDataState.innings2score,
              innings2over: scoreCardDataState.innings2over,
              innings2ball: scoreCardDataState.innings2ball,
              innings2wicket: scoreCardDataState.innings2wicket,
              innings2extra: scoreCardDataState.innings2extra,
              innings2noBall: scoreCardDataState.innings2noBall,
              innings2wideBall: scoreCardDataState.innings2wideBall,
              innings2bowlerScore: scoreCardDataState.innings2bowlerScore,
            ));
          }
        }
      } else {
        try {
          final matchId =
              await FireStoreData.getMatchId(db, event.user, event.matchName);

          final matchCompletedPageData =
              await FireStoreData.fetchMatchCompletedPageDataFromFirestore(
            db,
            event.user,
            matchId!,
            getRepository().getTimers().firebaseTransactionTimeout,
          );

          // emit match completed page state
          emit(MatchCompletedPageState(
            user: matchCompletedPageData.user,
            matchName: matchCompletedPageData.matchName,
            dateTime: matchCompletedPageData.dateTime,
            matchId: matchId,
            maxOvers: matchCompletedPageData.maxOvers,
            innings1runs: matchCompletedPageData.innings1runs,
            innings1overs: matchCompletedPageData.innings1overs,
            innings1balls: matchCompletedPageData.innings1balls,
            innings1wickets: matchCompletedPageData.innings1wickets,
            innings2runs: matchCompletedPageData.innings2runs,
            innings2overs: matchCompletedPageData.innings2overs,
            innings2balls: matchCompletedPageData.innings2balls,
            innings2wickets: matchCompletedPageData.innings2wickets,
            matchAbandoned: matchCompletedPageData.matchAbandoned,
          ));
        } catch (e) {
          if (state.runtimeType == UserPageState) {
            final userPageState = state as UserPageState;
            emit(UserPageState(
              userPageState.user,
              userPageState.matchName,
              userPageState.dateTime,
              userPageState.matchInProgress,
              snackBarMessageOrNull: e.toString(),
            ));
          }
        }
      }
    });

    on<Run0Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.zero == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall ? true : buttonState,
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run1Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.one == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall ? false : buttonState,
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run2Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.two == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall ? false : buttonState,
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run3Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.three == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall ? false : buttonState,
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run4Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.four == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall ? false : buttonState,
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run5Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.five == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall ? false : buttonState,
          six: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.six),
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<Run6Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.six == true ? false : true;
        final bowledOrCatchOutorWideBall = matchPageState.bowled == true ||
            matchPageState.catchOut == true ||
            matchPageState.wideBall == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: bowledOrCatchOutorWideBall
              ? true
              : (buttonState ? false : matchPageState.zero),
          one: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.one),
          two: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.two),
          three: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.three),
          four: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.four),
          five: bowledOrCatchOutorWideBall
              ? false
              : (buttonState ? false : matchPageState.five),
          six: bowledOrCatchOutorWideBall ? false : buttonState,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<OutBowledEvent>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.bowled == true ? false : true;
        // final bowledOrCatchOut =
        //     matchPageState.bowled == true || matchPageState.catchOut == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: buttonState ? false : matchPageState.one,
          two: buttonState ? false : matchPageState.two,
          three: buttonState ? false : matchPageState.three,
          four: buttonState ? false : matchPageState.four,
          five: buttonState ? false : matchPageState.five,
          six: buttonState ? false : matchPageState.six,
          bowled: buttonState,
          catchOut: buttonState ? false : matchPageState.catchOut,
          runOutBatter1: buttonState ? false : matchPageState.runOutBatter1,
          runOutBatter2: buttonState ? false : matchPageState.runOutBatter2,
          noBall: buttonState ? false : matchPageState.noBall,
          wideBall: buttonState ? false : matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<OutCatchEvent>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.catchOut == true ? false : true;
        // final bowledOrCatchOut =
        //     matchPageState.bowled == true || matchPageState.catchOut == true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: buttonState ? false : matchPageState.one,
          two: buttonState ? false : matchPageState.two,
          three: buttonState ? false : matchPageState.three,
          four: buttonState ? false : matchPageState.four,
          five: buttonState ? false : matchPageState.five,
          six: buttonState ? false : matchPageState.six,
          bowled: buttonState ? false : matchPageState.bowled,
          catchOut: buttonState,
          runOutBatter1: buttonState ? false : matchPageState.runOutBatter1,
          runOutBatter2: buttonState ? false : matchPageState.runOutBatter2,
          noBall: buttonState ? false : matchPageState.noBall,
          wideBall: buttonState ? false : matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<OutRunBatter1Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.runOutBatter1 ? false : true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: buttonState ? false : matchPageState.one,
          two: buttonState ? false : matchPageState.two,
          three: buttonState ? false : matchPageState.three,
          four: buttonState ? false : matchPageState.four,
          five: buttonState ? false : matchPageState.five,
          six: buttonState ? false : matchPageState.six,
          bowled: buttonState ? false : matchPageState.bowled,
          catchOut: buttonState ? false : matchPageState.catchOut,
          runOutBatter1: buttonState,
          runOutBatter2: buttonState ? false : matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: buttonState ? false : matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<OutRunBatter2Event>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.runOutBatter2 ? false : true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: buttonState ? false : matchPageState.one,
          two: buttonState ? false : matchPageState.two,
          three: buttonState ? false : matchPageState.three,
          four: buttonState ? false : matchPageState.four,
          five: buttonState ? false : matchPageState.five,
          six: buttonState ? false : matchPageState.six,
          bowled: buttonState ? false : matchPageState.bowled,
          catchOut: buttonState ? false : matchPageState.catchOut,
          runOutBatter1: buttonState ? false : matchPageState.runOutBatter1,
          runOutBatter2: buttonState,
          noBall: matchPageState.noBall,
          wideBall: buttonState ? false : matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<NoBallEvent>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.noBall == true ? false : true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: buttonState ? false : matchPageState.bowled,
          catchOut: buttonState ? false : matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: buttonState,
          wideBall: buttonState ? false : matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<WideBallEvent>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        final buttonState = matchPageState.wideBall == true ? false : true;
        emit(MatchPageState(
          snackBarMessage: matchPageState.snackBarMessage,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: buttonState ? true : matchPageState.zero,
          one: buttonState ? false : matchPageState.one,
          two: buttonState ? false : matchPageState.two,
          three: buttonState ? false : matchPageState.three,
          four: buttonState ? false : matchPageState.four,
          five: buttonState ? false : matchPageState.five,
          six: buttonState ? false : matchPageState.six,
          bowled: buttonState ? false : matchPageState.bowled,
          catchOut: buttonState ? false : matchPageState.catchOut,
          runOutBatter1: buttonState ? false : matchPageState.runOutBatter1,
          runOutBatter2: buttonState ? false : matchPageState.runOutBatter2,
          noBall: buttonState ? false : matchPageState.noBall,
          wideBall: buttonState,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    on<ChangeStrikeEvent>(
      (event, emit) {
        final matchPageState = state as MatchPageState;
        emit(MatchPageState(
          snackBarMessage: null,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batter2Name,
          batter1Name: matchPageState.batter2Name,
          batter1run: matchPageState.batter2run,
          batter1ball: matchPageState.batter2ball,
          batter2Name: matchPageState.batter1Name,
          batter2run: matchPageState.batter1run,
          batter2ball: matchPageState.batter1ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    // based on match page button press, and existing state
    // firestore is updated if necessary,
    // and new match page state event is emmited
    on<UpdateScoreEvent>(
      (event, emit) async {
        final db = FirebaseFirestore.instance;

        final matchPageState = state as MatchPageState;

        emit(MatchPageState(
          snackBarMessage: null,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
          disableButton: true,
        ));

        try {
          final newState = await FireStoreData.updateScoreToFirebase(
            db,
            matchPageState,
            getRepository().getTimers().firebaseTransactionTimeout,
          );

          emit(newState);
        } catch (e) {
          emit(MatchPageState(
            snackBarMessage: 'Score could not be updated to firestore',
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        }
      },
    );

    on<SelectNewBowlerEvent>(
      (event, emit) async {
        final db = FirebaseFirestore.instance;

        if (state.runtimeType == MatchPageState) {
          final matchPageState = state as MatchPageState;
          emit(MatchPageState(
            snackBarMessage: null,
            disableButton: true,
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        }

        try {
          final List<String> bowlerNames =
              await FireStoreData.fetchBowlerNamesFromFirestore(
            db,
            event.previousMatchPageState.user,
            event.previousMatchPageState.matchId,
            event.previousMatchPageState.innings1isInProgress,
          );

          emit(BowlerNameListState(event.previousMatchPageState, bowlerNames));
        } catch (e) {
          emit(MatchPageState(
            snackBarMessage: e.toString(),
            user: event.previousMatchPageState.user,
            matchName: event.previousMatchPageState.matchName,
            dateTime: event.previousMatchPageState.dateTime,
            matchId: event.previousMatchPageState.matchId,
            maxOvers: event.previousMatchPageState.maxOvers,
            innings1isInProgress:
                event.previousMatchPageState.innings1isInProgress,
            innings1runs: event.previousMatchPageState.innings1runs,
            innings1overs: event.previousMatchPageState.innings1overs,
            innings1balls: event.previousMatchPageState.innings1balls,
            innings1wickets: event.previousMatchPageState.innings1wickets,
            innings2runs: event.previousMatchPageState.innings2runs,
            innings2overs: event.previousMatchPageState.innings2overs,
            innings2balls: event.previousMatchPageState.innings2balls,
            innings2wickets: event.previousMatchPageState.innings2wickets,
            batterOnStrikeName: event.previousMatchPageState.batterOnStrikeName,
            batter1Name: event.previousMatchPageState.batter1Name,
            batter1run: event.previousMatchPageState.batter1run,
            batter1ball: event.previousMatchPageState.batter1ball,
            batter2Name: event.previousMatchPageState.batter2Name,
            batter2run: event.previousMatchPageState.batter2run,
            batter2ball: event.previousMatchPageState.batter2ball,
            currentBowler: event.previousMatchPageState.currentBowler,
            thisOverStats: event.previousMatchPageState.thisOverStats,
            zero: event.previousMatchPageState.zero,
            one: event.previousMatchPageState.one,
            two: event.previousMatchPageState.two,
            three: event.previousMatchPageState.three,
            four: event.previousMatchPageState.four,
            five: event.previousMatchPageState.five,
            six: event.previousMatchPageState.six,
            bowled: event.previousMatchPageState.bowled,
            catchOut: event.previousMatchPageState.catchOut,
            runOutBatter1: event.previousMatchPageState.runOutBatter1,
            runOutBatter2: event.previousMatchPageState.runOutBatter2,
            noBall: event.previousMatchPageState.noBall,
            wideBall: event.previousMatchPageState.wideBall,
            updateScore: event.previousMatchPageState.updateScore,
          ));
        }
      },
    );

    on<SelectFixedBowlerEvent>(
      (event, emit) {
        emit(MatchPageState(
          snackBarMessage: null,
          user: event.previousMatchPageState.user,
          matchName: event.previousMatchPageState.matchName,
          dateTime: event.previousMatchPageState.dateTime,
          matchId: event.previousMatchPageState.matchId,
          maxOvers: event.previousMatchPageState.maxOvers,
          innings1isInProgress:
              event.previousMatchPageState.innings1isInProgress,
          innings1runs: event.previousMatchPageState.innings1runs,
          innings1overs: event.previousMatchPageState.innings1overs,
          innings1balls: event.previousMatchPageState.innings1balls,
          innings1wickets: event.previousMatchPageState.innings1wickets,
          innings2runs: event.previousMatchPageState.innings2runs,
          innings2overs: event.previousMatchPageState.innings2overs,
          innings2balls: event.previousMatchPageState.innings2balls,
          innings2wickets: event.previousMatchPageState.innings2wickets,
          batterOnStrikeName: event.previousMatchPageState.batterOnStrikeName,
          batter1Name: event.previousMatchPageState.batter1Name,
          batter1run: event.previousMatchPageState.batter1run,
          batter1ball: event.previousMatchPageState.batter1ball,
          batter2Name: event.previousMatchPageState.batter2Name,
          batter2run: event.previousMatchPageState.batter2run,
          batter2ball: event.previousMatchPageState.batter2ball,
          currentBowler: event.selectedBowlerName,
          thisOverStats: event.previousMatchPageState.thisOverStats,
          zero: event.previousMatchPageState.zero,
          one: event.previousMatchPageState.one,
          two: event.previousMatchPageState.two,
          three: event.previousMatchPageState.three,
          four: event.previousMatchPageState.four,
          five: event.previousMatchPageState.five,
          six: event.previousMatchPageState.six,
          bowled: event.previousMatchPageState.bowled,
          catchOut: event.previousMatchPageState.catchOut,
          runOutBatter1: event.previousMatchPageState.runOutBatter1,
          runOutBatter2: event.previousMatchPageState.runOutBatter2,
          noBall: event.previousMatchPageState.noBall,
          wideBall: event.previousMatchPageState.wideBall,
          updateScore: event.previousMatchPageState.updateScore,
        ));
      },
    );

    on<AddNewBowlerEvent>(
      (event, emit) async {
        if (state.runtimeType == BowlerNameListState) {
          final bowlerNameListState = state as BowlerNameListState;
          emit(BowlerNameListState(
            bowlerNameListState.previousMatchPageState,
            bowlerNameListState.bowlerNames,
            disableButton: true,
          ));
        }

        final bowlerNameListState = state as BowlerNameListState;
        final db = FirebaseFirestore.instance;
        try {
          await FireStoreData.addNewBowlerNameToFirestore(
            db,
            bowlerNameListState.previousMatchPageState.user,
            bowlerNameListState.previousMatchPageState.matchId,
            event.innings1inProgress,
            event.newBowlerName,
          );

          final bowlerNames = await FireStoreData.fetchBowlerNamesFromFirestore(
            db,
            bowlerNameListState.previousMatchPageState.user,
            bowlerNameListState.previousMatchPageState.matchId,
            event.innings1inProgress,
          );

          emit(
            BowlerNameListState(
              event.previousMatchPageState,
              bowlerNames,
            ),
          );
        } catch (e) {
          emit(
            BowlerNameListState(
              event.previousMatchPageState,
              bowlerNameListState.bowlerNames,
              errorMessage: e.toString(),
            ),
          );
        }
      },
    );

    on<OpenAddNewBatterPageEvent>(
      (event, emit) {
        emit(OpenAddNewBatterPageState(
          event.addingBatter1,
          event.previousMatchPageState,
        ));
      },
    );

    on<AddNewBatterEvent>(
      (event, emit) async {
        final db = FirebaseFirestore.instance;
        // add batter to firestore
        if (await FireStoreData.addNewBatterNameToFirestore(
          db,
          event.previousMatchPageState.user,
          event.previousMatchPageState.matchId,
          event.previousMatchPageState.innings1isInProgress,
          event.newBatterName,
        )) {
          // emit AddNewBatterSuccessfulState
          final matchPageState = event.previousMatchPageState;

          var batterOnStrikeName =
              event.previousMatchPageState.batterOnStrikeName;
          var batter1Name = event.previousMatchPageState.batter1Name;
          var batter1run = event.previousMatchPageState.batter1run;
          var batter1ball = event.previousMatchPageState.batter1ball;
          var batter2Name = event.previousMatchPageState.batter2Name;
          var batter2run = event.previousMatchPageState.batter2run;
          var batter2ball = event.previousMatchPageState.batter2ball;

          if (event.addingBatter1) {
            batter1Name = event.newBatterName;
            batter1run = 0;
            batter1ball = 0;
            batterOnStrikeName = batter1Name;
          } else {
            batter2Name = event.newBatterName;
            batter2run = 0;
            batter2ball = 0;
          }

          emit(NewBatterAddedSuccessfulState(
            event.addingBatter1,
            event.newBatterName,
            MatchPageState(
              snackBarMessage: null,
              user: matchPageState.user,
              matchName: matchPageState.matchName,
              dateTime: matchPageState.dateTime,
              matchId: matchPageState.matchId,
              maxOvers: matchPageState.maxOvers,
              innings1isInProgress: matchPageState.innings1isInProgress,
              innings1runs: matchPageState.innings1runs,
              innings1overs: matchPageState.innings1overs,
              innings1balls: matchPageState.innings1balls,
              innings1wickets: matchPageState.innings1wickets,
              innings2runs: matchPageState.innings2runs,
              innings2overs: matchPageState.innings2overs,
              innings2balls: matchPageState.innings2balls,
              innings2wickets: matchPageState.innings2wickets,
              batterOnStrikeName: batterOnStrikeName,
              batter1Name: batter1Name,
              batter1run: batter1run,
              batter1ball: batter1ball,
              batter2Name: batter2Name,
              batter2run: batter2run,
              batter2ball: batter2ball,
              currentBowler: matchPageState.currentBowler,
              thisOverStats: matchPageState.thisOverStats,
              zero: matchPageState.zero,
              one: matchPageState.one,
              two: matchPageState.two,
              three: matchPageState.three,
              four: matchPageState.four,
              five: matchPageState.five,
              six: matchPageState.six,
              bowled: matchPageState.bowled,
              catchOut: matchPageState.catchOut,
              runOutBatter1: matchPageState.runOutBatter1,
              runOutBatter2: matchPageState.runOutBatter2,
              noBall: matchPageState.noBall,
              wideBall: matchPageState.wideBall,
              updateScore: matchPageState.updateScore,
            ),
          ));
        } else {
          // error in adding batter name
          emit(NewBatterAddedSuccessfulState(
            event.addingBatter1,
            event.newBatterName,
            event.previousMatchPageState,
            errorOrNullOnSuccess: 'Either firestore could not be connected'
                ' or \nbatter name has been repeated',
          ));
        }
      },
    );

    on<AddBatterEvent>(
      (event, emit) async {
        final matchPageState = state as MatchPageState;

        emit(MatchPageState(
          snackBarMessage: null,
          disableButton: true,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));

        final db = FirebaseFirestore.instance;

        if (await FireStoreData.addNewBatterNameToFirestore(
          db,
          matchPageState.user,
          matchPageState.matchId,
          matchPageState.innings1isInProgress,
          event.batterName,
        )) {
          String? batter1name = matchPageState.batter1Name;
          int batter1run = matchPageState.batter1run;
          int batter1ball = matchPageState.batter1ball;
          String? batter2name = matchPageState.batter2Name;
          int batter2run = matchPageState.batter2run;
          int batter2ball = matchPageState.batter2ball;
          String? batterOnStrikeName = matchPageState.batterOnStrikeName;

          if (matchPageState.batter1Name == null) {
            batter1name = event.batterName;
            batter1run = 0;
            batter1ball = 0;
            batter2name = null;
            batter2run = 0;
            batter2ball = 0;
            batterOnStrikeName = batter1name;
          } else if (matchPageState.batter2Name == null) {
            batterOnStrikeName = matchPageState.batter1Name;
            batter2name = event.batterName;
            batter2run = 0;
            batter2ball = 0;
          }

          emit(MatchPageState(
            snackBarMessage: null,
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: batterOnStrikeName,
            batter1Name: batter1name,
            batter1run: batter1run,
            batter1ball: batter1ball,
            batter2Name: batter2name,
            batter2run: batter2run,
            batter2ball: batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        } else {
          emit(MatchPageState(
            snackBarMessage:
                '${event.batterName} could not be added to firestore'
                '\nEither batter already exists, or could not connect to server',
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        }
      },
    );

    on<OpenMatchStatePageAfterBatterAddingEvent>(
      (event, emit) {
        final matchPageState = event.previousMatchPageState;

        // var batterOnStrikeName = matchPageState.batterOnStrikeName;
        // var batter1Name = matchPageState.batter1Name;
        // var batter1run = matchPageState.batter1run;
        // var batter1ball = matchPageState.batter1ball;
        // var batter2Name = matchPageState.batter2Name;
        // var batter2run = matchPageState.batter2run;
        // var batter2ball = matchPageState.batter2ball;
        // if (event.addingBatter1) {
        //   batter1Name = event.newBatterName;
        //   batter1run = 0;
        //   batter1ball = 0;
        //   batterOnStrikeName = batter1Name;
        // } else {
        //   batter2Name = event.newBatterName;
        //   batter2run = 0;
        //   batter2ball = 0;
        // }

        emit(MatchPageState(
          snackBarMessage: event.errorOrNullIfSuccess,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      },
    );

    ///  - If endInnings1 is true
    ///    - updates to firestore, innings1 has been completed
    ///    - updated to firestore, innings2 has started
    ///    - emit MatchPageState for Innings2
    ///  - If endInnings2 is true
    ///    - updates to firestore, innings 2 has been completed
    ///    - emit MatchCompletedPageState
    on<EndInningsEvent>(
      (event, emit) async {
        final matchPageState = state as MatchPageState;
        final db = FirebaseFirestore.instance;

        if (state.runtimeType == MatchPageState) {
          final matchPageState = state as MatchPageState;
          emit(MatchPageState(
            snackBarMessage: null,
            disableButton: true,
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        }

        try {
          if (event.endInnings1) {
            // update innings 1 completed
            await FireStoreData.updateInnings1HasCompletedToFirestore(
              db,
              matchPageState.user,
              matchPageState.matchId,
              timeout: getRepository().getTimers().firebaseTransactionTimeout,
            );

            // update innings 2 started
            await FireStoreData.updateInnings2HasStartedToFirestore(
              db,
              matchPageState.user,
              matchPageState.matchId,
              timeout: getRepository().getTimers().firebaseTransactionTimeout,
            );

            emit(MatchPageState(
              snackBarMessage: null,
              user: matchPageState.user,
              matchName: matchPageState.matchName,
              dateTime: matchPageState.dateTime,
              matchId: matchPageState.matchId,
              maxOvers: matchPageState.maxOvers,
              innings1isInProgress: false,
              innings1runs: matchPageState.innings1runs,
              innings1overs: matchPageState.innings1overs,
              innings1balls: matchPageState.innings1balls,
              innings1wickets: matchPageState.innings1wickets,
              innings2runs: 0,
              innings2overs: 0,
              innings2balls: 0,
              innings2wickets: 0,
              batterOnStrikeName: null,
              batter1Name: null,
              batter1run: 0,
              batter1ball: 0,
              batter2Name: null,
              batter2run: 0,
              batter2ball: 0,
              currentBowler: null,
              thisOverStats: const [],
              zero: false,
              one: false,
              two: false,
              three: false,
              four: false,
              five: false,
              six: false,
              bowled: false,
              catchOut: false,
              runOutBatter1: false,
              runOutBatter2: false,
              noBall: false,
              wideBall: false,
              updateScore: false,
            ));
          } else if (event.endInnings2) {
            // update innings 2 completed
            await FireStoreData.updateInnings2HasCompletedToFirestore(
              db,
              matchPageState.user,
              matchPageState.matchId,
              timeout: getRepository().getTimers().firebaseTransactionTimeout,
            );

            // emit MatchCompletedPageState()
            emit(MatchCompletedPageState(
              user: matchPageState.user,
              matchName: matchPageState.matchName,
              dateTime: matchPageState.dateTime,
              matchId: matchPageState.matchId,
              maxOvers: matchPageState.maxOvers,
              innings1runs: matchPageState.innings1runs,
              innings1overs: matchPageState.innings1overs,
              innings1balls: matchPageState.innings1balls,
              innings1wickets: matchPageState.innings1wickets,
              innings2runs: matchPageState.innings2runs,
              innings2overs: matchPageState.innings2overs,
              innings2balls: matchPageState.innings2balls,
              innings2wickets: matchPageState.innings2wickets,
              matchAbandoned: false,
            ));
          }
        } catch (_) {
          emit(MatchPageState(
            snackBarMessage: event.endInnings1
                ? 'End Innings 1 could not be updated to firestore'
                : 'End Match could not be updated to firestore',
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        }
      },
    );

    on<MatchAbandonedEvent>((event, emit) async {
      if (state.runtimeType == MatchPageState) {
        final matchPageState = state as MatchPageState;
        emit(MatchPageState(
          snackBarMessage: null,
          disableButton: true,
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      }

      final matchPageState = state as MatchPageState;
      final db = FirebaseFirestore.instance;

      try {
        await FireStoreData.updateMatchAbandonedToFirestore(
          db,
          matchPageState.user,
          matchPageState.matchId,
          timeout: getRepository().getTimers().firebaseTransactionTimeout,
        );

        emit(MatchCompletedPageState(
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          matchAbandoned: true,
        ));
      } catch (_) {
        emit(MatchPageState(
          snackBarMessage: 'Match abandoned could not be updated to firestore',
          user: matchPageState.user,
          matchName: matchPageState.matchName,
          dateTime: matchPageState.dateTime,
          matchId: matchPageState.matchId,
          maxOvers: matchPageState.maxOvers,
          innings1isInProgress: matchPageState.innings1isInProgress,
          innings1runs: matchPageState.innings1runs,
          innings1overs: matchPageState.innings1overs,
          innings1balls: matchPageState.innings1balls,
          innings1wickets: matchPageState.innings1wickets,
          innings2runs: matchPageState.innings2runs,
          innings2overs: matchPageState.innings2overs,
          innings2balls: matchPageState.innings2balls,
          innings2wickets: matchPageState.innings2wickets,
          batterOnStrikeName: matchPageState.batterOnStrikeName,
          batter1Name: matchPageState.batter1Name,
          batter1run: matchPageState.batter1run,
          batter1ball: matchPageState.batter1ball,
          batter2Name: matchPageState.batter2Name,
          batter2run: matchPageState.batter2run,
          batter2ball: matchPageState.batter2ball,
          currentBowler: matchPageState.currentBowler,
          thisOverStats: matchPageState.thisOverStats,
          zero: matchPageState.zero,
          one: matchPageState.one,
          two: matchPageState.two,
          three: matchPageState.three,
          four: matchPageState.four,
          five: matchPageState.five,
          six: matchPageState.six,
          bowled: matchPageState.bowled,
          catchOut: matchPageState.catchOut,
          runOutBatter1: matchPageState.runOutBatter1,
          runOutBatter2: matchPageState.runOutBatter2,
          noBall: matchPageState.noBall,
          wideBall: matchPageState.wideBall,
          updateScore: matchPageState.updateScore,
        ));
      }
    });

    on<ShowScoreCardEvent>(
      (event, emit) async {
        final db = FirebaseFirestore.instance;

        if (state.runtimeType == MatchPageState) {
          final matchPageState = state as MatchPageState;
          emit(MatchPageState(
            snackBarMessage: null,
            disableButton: true,
            user: matchPageState.user,
            matchName: matchPageState.matchName,
            dateTime: matchPageState.dateTime,
            matchId: matchPageState.matchId,
            maxOvers: matchPageState.maxOvers,
            innings1isInProgress: matchPageState.innings1isInProgress,
            innings1runs: matchPageState.innings1runs,
            innings1overs: matchPageState.innings1overs,
            innings1balls: matchPageState.innings1balls,
            innings1wickets: matchPageState.innings1wickets,
            innings2runs: matchPageState.innings2runs,
            innings2overs: matchPageState.innings2overs,
            innings2balls: matchPageState.innings2balls,
            innings2wickets: matchPageState.innings2wickets,
            batterOnStrikeName: matchPageState.batterOnStrikeName,
            batter1Name: matchPageState.batter1Name,
            batter1run: matchPageState.batter1run,
            batter1ball: matchPageState.batter1ball,
            batter2Name: matchPageState.batter2Name,
            batter2run: matchPageState.batter2run,
            batter2ball: matchPageState.batter2ball,
            currentBowler: matchPageState.currentBowler,
            thisOverStats: matchPageState.thisOverStats,
            zero: matchPageState.zero,
            one: matchPageState.one,
            two: matchPageState.two,
            three: matchPageState.three,
            four: matchPageState.four,
            five: matchPageState.five,
            six: matchPageState.six,
            bowled: matchPageState.bowled,
            catchOut: matchPageState.catchOut,
            runOutBatter1: matchPageState.runOutBatter1,
            runOutBatter2: matchPageState.runOutBatter2,
            noBall: matchPageState.noBall,
            wideBall: matchPageState.wideBall,
            updateScore: matchPageState.updateScore,
          ));
        } else if (state.runtimeType == MatchCompletedPageState) {
          final matchCompletedPageState = state as MatchCompletedPageState;
          emit(MatchCompletedPageState(
            user: matchCompletedPageState.user,
            matchName: matchCompletedPageState.matchName,
            dateTime: matchCompletedPageState.dateTime,
            matchId: matchCompletedPageState.matchId,
            maxOvers: matchCompletedPageState.maxOvers,
            innings1runs: matchCompletedPageState.innings1runs,
            innings1overs: matchCompletedPageState.innings1overs,
            innings1balls: matchCompletedPageState.innings1balls,
            innings1wickets: matchCompletedPageState.innings1wickets,
            innings2runs: matchCompletedPageState.innings2runs,
            innings2overs: matchCompletedPageState.innings2overs,
            innings2balls: matchCompletedPageState.innings2balls,
            innings2wickets: matchCompletedPageState.innings2wickets,
            matchAbandoned: matchCompletedPageState.matchAbandoned,
            disableButton: true,
          ));
        }

        try {
          //await fetch scorecard from firestore
          var scoreCardData =
              await FireStoreData.fetchScoreCardDataFromFirestore(
            db,
            event.user,
            event.documentIdOfMatch,
            getRepository().getTimers().firebaseTransactionTimeout,
          );

          // log.e(scoreCardData);

          //emit scoreCardDataState
          emit(ScoreCardDataState(
            user: scoreCardData.user,
            matchId: scoreCardData.matchId,
            matchName: scoreCardData.matchName,
            dateTime: scoreCardData.dateTime,
            maxOvers: scoreCardData.maxOvers,
            innings1inProgress: scoreCardData.innings1inProgress,
            innings2inProgress: scoreCardData.innings2inProgress,
            innings1batterScore: scoreCardData.innings1batterScore,
            innings1score: scoreCardData.innings1score,
            innings1over: scoreCardData.innings1over,
            innings1ball: scoreCardData.innings1ball,
            innings1wicket: scoreCardData.innings1wicket,
            innings1extra: scoreCardData.innings1extra,
            innings1noBall: scoreCardData.innings1noBall,
            innings1wideBall: scoreCardData.innings1wideBall,
            innings1bowlerScore: scoreCardData.innings1bowlerScore,
            innings2batterScore: scoreCardData.innings2batterScore,
            innings2score: scoreCardData.innings2score,
            innings2over: scoreCardData.innings2over,
            innings2ball: scoreCardData.innings2ball,
            innings2wicket: scoreCardData.innings2wicket,
            innings2extra: scoreCardData.innings2extra,
            innings2noBall: scoreCardData.innings2noBall,
            innings2wideBall: scoreCardData.innings2wideBall,
            innings2bowlerScore: scoreCardData.innings2bowlerScore,
          ));
        } catch (e) {
          if (state.runtimeType == MatchPageState) {
            final matchPageState = state as MatchPageState;
            emit(MatchPageState(
              snackBarMessage: e.toString(),
              user: matchPageState.user,
              matchName: matchPageState.matchName,
              dateTime: matchPageState.dateTime,
              matchId: matchPageState.matchId,
              maxOvers: matchPageState.maxOvers,
              innings1isInProgress: matchPageState.innings1isInProgress,
              innings1runs: matchPageState.innings1runs,
              innings1overs: matchPageState.innings1overs,
              innings1balls: matchPageState.innings1balls,
              innings1wickets: matchPageState.innings1wickets,
              innings2runs: matchPageState.innings2runs,
              innings2overs: matchPageState.innings2overs,
              innings2balls: matchPageState.innings2balls,
              innings2wickets: matchPageState.innings2wickets,
              batterOnStrikeName: matchPageState.batterOnStrikeName,
              batter1Name: matchPageState.batter1Name,
              batter1run: matchPageState.batter1run,
              batter1ball: matchPageState.batter1ball,
              batter2Name: matchPageState.batter2Name,
              batter2run: matchPageState.batter2run,
              batter2ball: matchPageState.batter2ball,
              currentBowler: matchPageState.currentBowler,
              thisOverStats: matchPageState.thisOverStats,
              zero: matchPageState.zero,
              one: matchPageState.one,
              two: matchPageState.two,
              three: matchPageState.three,
              four: matchPageState.four,
              five: matchPageState.five,
              six: matchPageState.six,
              bowled: matchPageState.bowled,
              catchOut: matchPageState.catchOut,
              runOutBatter1: matchPageState.runOutBatter1,
              runOutBatter2: matchPageState.runOutBatter2,
              noBall: matchPageState.noBall,
              wideBall: matchPageState.wideBall,
              updateScore: matchPageState.updateScore,
            ));
          } else if (state.runtimeType == MatchCompletedPageState) {
            final matchCompletedPageState = state as MatchCompletedPageState;
            emit(MatchCompletedPageState(
              snackBarMessageOrNull: e.toString(),
              user: matchCompletedPageState.user,
              matchName: matchCompletedPageState.matchName,
              dateTime: matchCompletedPageState.dateTime,
              matchId: matchCompletedPageState.matchId,
              maxOvers: matchCompletedPageState.maxOvers,
              innings1runs: matchCompletedPageState.innings1runs,
              innings1overs: matchCompletedPageState.innings1overs,
              innings1balls: matchCompletedPageState.innings1balls,
              innings1wickets: matchCompletedPageState.innings1wickets,
              innings2runs: matchCompletedPageState.innings2runs,
              innings2overs: matchCompletedPageState.innings2overs,
              innings2balls: matchCompletedPageState.innings2balls,
              innings2wickets: matchCompletedPageState.innings2wickets,
              matchAbandoned: matchCompletedPageState.matchAbandoned,
            ));
          }
        }
      },
    );

    on<SendOtpToUserEvent>(
      (event, emit) async {
        try {
          emit(WaitingForOtpPageState(
            confirmationResult: null,
            errorMessage: null,
            disableButton: true,
          ));
          // log.i('phone number received : ${event.phoneNumber}');

          final confirmationResult =
              await FireStoreData.sendOtpToUser(event.phoneNumber)
                  .timeout(_dataRepository.getTimers().firebaseSignInTimeout);

          // getRepository().updateUserCredential()

          emit(WaitingForOtpPageState(
            confirmationResult: confirmationResult,
            errorMessage: null,
          ));
        } catch (e) {
          emit(WaitingForOtpPageState(
            confirmationResult: null,
            errorMessage: e.toString(),
          ));
        }
      },
    );

    on<VerifyOtpEvent>((event, emit) async {
      try {
        // log.i('otp received is ${event.otp}');
        final waitingForOtpPageState = state as WaitingForOtpPageState;

        emit(WaitingForOtpPageState(
          confirmationResult: waitingForOtpPageState.confirmationResult,
          disableButton: true,
        ));

        final userPageState = await FireStoreData.verifyOtp(
          confirmationResult: event.confirmationResult,
          otp: event.otp,
          timeout: _dataRepository.getTimers().firebaseTransactionTimeout,
        );
        // .timeout(_dataRepository.getTimers().firebaseTransactionTimeout);
        _dataRepository.updateUser(userPageState.user);
        // emit(userPageState as UserPageState);

        emit(UserPageState(
          userPageState.user,
          userPageState.matchName,
          userPageState.dateTime,
          userPageState.matchInProgress,
        ));
      } catch (error) {
        emit(WaitingForOtpPageState(
          confirmationResult: event.confirmationResult,
          errorMessage: error.toString(),
        ));
      }
    });

    on<AppStartedForFirstTimeEvent>(
      (event, emit) async {
        //
        emit(WaitingForOtpPageState(
          confirmationResult: null,
          disableButton: true,
        ));

        if (FirebaseAuth.instance.currentUser == null) {
          emit(WaitingForOtpPageState(confirmationResult: null));
        } else {
          try {
            final user = FirebaseAuth.instance.currentUser!;

            final userPageState = await FireStoreData.fetchUserPageState(
              db: FirebaseFirestore.instance,
              user: user,
              timeout: getRepository().getTimers().firebaseTransactionTimeout,
            );

            getRepository().updateUser(user);

            // log.d('$userPageState');

            emit(UserPageState(
              userPageState.user,
              userPageState.matchName,
              userPageState.dateTime,
              userPageState.matchInProgress,
            ));
          } catch (e) {
            // log.d(e.toString());

            emit(WaitingForOtpPageState(
              confirmationResult: null,
              errorMessage: e.toString(),
              disableButton: false,
            ));
          }
        }
      },
    );
  }

  DataRepository getRepository() => _dataRepository;

  @override
  void onEvent(HomescreenEvent event) {
    super.onEvent(event);
    // log.i('HomescreenBloc-Event-${event.runtimeType}-$event');
  }

  @override
  void onTransition(Transition<HomescreenEvent, HomescreenState> transition) {
    // log.i('HOMESCREENBLOC-EVENT-${transition.event}');
    // log.i('HOMESCREENBLOC-STATE-${transition.nextState}');
    super.onTransition(transition);
  }
}
