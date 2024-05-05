import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';

class DataRepository {
  // final batters = Batters();
  // final bowlers = Bowlers();
  // final match = Match();
  // UserCredential? userCredential;
  User? _user;

  final AppColors _appColors = AppColors();
  final Dimensions _dimensions = Dimensions();
  final Fonts _fonts = Fonts();
  final Timers _timers = Timers();

  // List<String> getBatterScore(String batterName) {
  //   return [
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //     '6',
  //     '6',
  //     '1',
  //     '1',
  //   ];
  // }

  /// updates value of userCredential
  // void updateUserCredential(UserCredential userCredential) {
  //   this.userCredential = userCredential;
  //   log.e('Writing userCredential : ${this.userCredential}');
  // }

  ///- returns userCredential on success
  ///- throws exception on error
  // UserCredential getUserCredential() {
  //   log.i('reading userCredential : $userCredential');
  //   if (userCredential == null) {
  //     throw Exception('user credential is null');
  //   }
  //   return userCredential!;
  // }

  void updateUser(User user) {
    _user = user;
  }

  User getUser() {
    if (_user == null) {
      throw Exception('user is null');
    } else {
      return _user!;
    }
  }

  AppColors getColors() => _appColors;
  Dimensions getDimensions() => _dimensions;
  Fonts getFonts() => _fonts;
  Timers getTimers() => _timers;
}

class AppColors {
  final darkBackgroundColor1 = Colors.grey.shade900;
  final darkBackgroundFontColor1 = Colors.grey.shade100;
  final darkBackgroundColor2 = Colors.grey.shade700;
  final darkBackgroundFontColor2 = Colors.grey.shade300;
  final lightBackgroundColor1 = Colors.white;
  final lightBackgroundFontColor1 = Colors.grey.shade900;
  final lightBackgroundFontColorDisabled1 = Colors.grey.shade500;
  final lightBackgroundColor2 = Colors.grey.shade200;
  final lightBackgroundFontColor2 = Colors.grey.shade700;
  final accentColor = Colors.blue.shade200;
  // final darkTextColor = const Color.fromARGB(255, 50, 50, 50);
  // final buttonColor = const Color.fromARGB(255, 100, 100, 100);
  final buttonColor = Colors.grey.shade900;
  final buttonFontColor = Colors.grey.shade100;
  final disabledButtonColor = Colors.grey.shade400;
  final disabledButtonBorderColor = Colors.grey.shade400;
  final disabledButtonFontColor = Colors.grey.shade700;

  AppColors();
}

class Dimensions {
  final borderRadius = 20.0;
  final horizontalMargin = 30.0;
  final verticalMargin = 10.0;
  final heightOfButton = 40.0;
  final dialogBoxWidth = 300.0;
  final widthOfBatterIcon = 40.0;
  // final heightOf
}

class Fonts {
  final fontSize1 = 24.0;
  final fontWeight1 = FontWeight.bold;
  final fontSize2 = 14.0;
  final fontWeight2 = FontWeight.bold;
  final fontSize3 = 12.0;
  final fontWeight3 = FontWeight.bold;
  final fontSize4 = 14.0;
  final fontWeight4 = FontWeight.bold;
  // final fontFamily4 = 'Roboto';
  final fontFamily4 = 'ComicNeue';
}

class Timers {
  final snackBarTime1 = const Duration(seconds: 10);
  final firebaseSignInTimeout = const Duration(minutes: 1);
  final firebaseTransactionTimeout = const Duration(seconds: 5);
}

class FireStoreData {
  static Future<String?> getMatchId(
    FirebaseFirestore db,
    User user,
    String matchName,
  ) async {
    String? documentId;
    final userId = _getDocumentIdOfUser(user);

    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .get()
        .then((querySnapShot) {
      for (var docSnapShot in querySnapShot.docs) {
        if (docSnapShot['matchName'] == matchName) {
          documentId = docSnapShot.id;
          break;
        }
      }
    });

    return documentId;
  }

  static String _getDocumentIdOfUser(User user) {
    // if (user.email != null) {
    //   return user.email!;
    // } else if (user.phoneNumber != null) {
    //   return user.phoneNumber!;
    // } else {
    //   throw Exception('user does not contain email or phone number');
    // }

    return user.uid;
  }

  static String _getEmailIdOfUser(User user) {
    if (user.email != null) {
      return user.email!;
    } else if (user.phoneNumber != null) {
      return user.phoneNumber!;
    } else {
      throw Exception('user does not contain email or phone number');
    }
  }

  static Future<bool> updateMatchName(
    FirebaseFirestore db,
    String documentIdOfUser,
    String documentIdOfMatch,
    String oldMatchName,
    String newMatchName,
  ) async {
    try {
      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .update(
        {'matchName': newMatchName},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  ///returns null on success, & error message as String on failure
  static Future<String?> createBatter(
    FirebaseFirestore db,
    String documentIdOfUser,
    String documentIdOfMatch,
    bool batterIsOfTeam1,
    String batterName,
  ) async {
    try {
      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .collection('stats')
          .doc(batterIsOfTeam1 ? 'innings1batter' : 'innings2batter')
          .set(
        {
          batterName: [],
        },
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> createBowler(
    FirebaseFirestore db,
    String documentIdOfUser,
    String documentIdOfMatch,
    bool firstInningsInProgress,
    String bowlerName,
  ) async {
    try {
      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .collection('stats')
          .doc(firstInningsInProgress ? 'innings1bowler' : 'innings2bowler')
          .set(
        {
          bowlerName: [],
        },
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<bool> appendBatterScore(
    FirebaseFirestore db,
    String documentIdOfUser,
    String documentIdOfMatch,
    bool batterIsOfTeam1,
    String batterName,
    String bowlerName,
    String score,
  ) async {
    //

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection(batterIsOfTeam1 ? 'team1scoreCard' : 'team2scoreCard')
        .doc('batting')
        .set({batterName: []});

    return true;
  }

  ///if success, message is matchId
  ///if failure, message is error message
  ///- returns Future of data of MatchPageState if success
  ///- throws exception on failure
  static Future<
      ({
        User user,
        String matchName,
        DateTime dateTime,
        String matchId,
        int maxOvers,
        bool innings1isInProgress,
        int innings1runs,
        int innings1overs,
        int innings1balls,
        int innings1wickets,
        int innings2runs,
        int innings2overs,
        int innings2balls,
        int innings2wickets,
        String? batterOnStrikeName,
        String? batter1Name,
        int batter1run,
        int batter1ball,
        String? batter2Name,
        int batter2run,
        int batter2ball,
        String? currentBowler,
        List<String> thisOverStats,
      })> createNewMatch(
    FirebaseFirestore db,
    User user,
    String teamBattingFirstName,
    String teamBattingSecondName,
    int maxOvers, {
    required Duration timeout,
  }) async {
    final String matchName = '$teamBattingFirstName vs $teamBattingSecondName';
    final String userId = _getDocumentIdOfUser(user);
    String matchId = '';
    DateTime dateTime = DateTime.now();

    // create new match in firebase
    final docRef =
        await db.collection('users').doc(userId).collection('matches').add(
      {
        'dateTime': dateTime,
        'innings1inProgress': true,
        'innings2inProgress': false,
        'matchAbandoned': false,
        'matchName': matchName,
        'maxOvers': maxOvers,
      },
    ).timeout(timeout);

    matchId = docRef.id;

    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings1batter')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings1bowler')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings1bowlerAndHisOvers')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings1catches')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings1runOut')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings2batter')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings2bowler')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings2bowlerAndHisOvers')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings2catches')
        .set(
      {},
    ).timeout(timeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(matchId)
        .collection('stats')
        .doc('innings2runOut')
        .set(
      {},
    ).timeout(timeout);
    return (
      user: user,
      matchName: matchName,
      dateTime: dateTime,
      matchId: matchId,
      maxOvers: maxOvers,
      innings1isInProgress: true,
      innings1runs: 0,
      innings1overs: 0,
      innings1balls: 0,
      innings1wickets: 0,
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
      thisOverStats: <String>[],
    );
  }

  /// String as each ball score
  /// run, legalBall/wideBall/noBall/notPlayed, catchOut/bowledOut/runOut/hitWicket/notOut
  static String getEachBallScoreAsString(
    int run,
    bool catchOut,
    bool runOut,
    bool bowled,
    bool wideBall,
    bool noBall,
  ) {
    String score = '';
    score += run.toString();
    score += ',';
    if (wideBall) {
      score += 'wideBall';
    } else if (noBall) {
      score += 'noBall';
    } else {
      score += 'legalBall';
    }
    score += ',';
    if (catchOut) {
      score += 'catchOut';
    } else if (bowled) {
      score += 'bowledOut';
    } else if (runOut) {
      score += 'runOut';
    } else {
      score += 'notOut';
    }
    return score;
  }

  /// String for display as thisOverStats
  static String getEachBallScoreForDisplay(String eachBallScoreAsString) {
    final eachBallScoreComponent = eachBallScoreAsString.split(',');
    String score = '';
    score += eachBallScoreAsString[0].toString();
    if (eachBallScoreComponent[2] == 'catchOut') {
      score += '+W';
    } else if (eachBallScoreComponent[2] == 'bowledOut') {
      score += '+W';
    } else if (eachBallScoreComponent[2] == 'hitWicket') {
      score += '+W';
    } else if (eachBallScoreComponent[1] == 'wideBall') {
      score += '+wb';
    } else if (eachBallScoreComponent[2] == 'runOut') {
      score += '+W';
      if (eachBallScoreComponent[1] == 'noBall') {
        score += '+nb';
      }
    } else if (eachBallScoreComponent[1] == 'noBall') {
      score += '+nb';
    }
    return score;
  }

  static ({
    int run,
    int ball,
    bool catchOut,
    bool runOut,
    bool bowled,
    bool wideBall,
    bool noBall,
  }) getEachBallScore(String eachBallScoreAsString) {
    List<String> values = eachBallScoreAsString.split(',');
    int run = 0;
    bool catchOut = false;
    bool runOut = false;
    bool bowled = false;
    bool wideBall = false;
    bool noBall = false;

    run = int.parse(values.first);

    for (String val in values) {
      if (val == 'catchOut') {
        catchOut = true;
      } else if (val == 'runOut') {
        runOut = true;
      } else if (val == 'bowledOut') {
        bowled = true;
      } else if (val == 'wideBall') {
        wideBall = true;
      } else if (val == 'noBall') {
        noBall = true;
      }
    }

    run += (noBall || wideBall) ? 1 : 0;

    return (
      run: run,
      ball: noBall || wideBall ? 0 : 1,
      catchOut: catchOut,
      runOut: runOut,
      bowled: bowled,
      wideBall: wideBall,
      noBall: noBall,
    );
  }

  static Future<void> updateBatterScoreToFireStore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    bool thisIsFirstInnings,
    String batterName,
    String batterScore, {
    required Duration timeout,
  }) async {
    final String fieldName =
        thisIsFirstInnings ? 'innings1batter' : 'innings2batter';

    List newBatterScore = [];

    final documentIdOfUser = _getDocumentIdOfUser(user);
    try {
      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .collection('stats')
          .doc(fieldName)
          .get()
          .then((docSnapshot) {
        final batterScorePrevious = docSnapshot.data()![batterName];

        for (var score in batterScorePrevious) {
          // log.e(score);
          newBatterScore.add(score);
        }
      }).timeout(timeout);
    } catch (e) {
      // log.e(e);
    }

    newBatterScore.add(batterScore);

    // log.e('New batter score of "$batterName" : $newBatterScore');

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(fieldName)
        .update({batterName: newBatterScore}).timeout(timeout);
  }

  /// throws exception if score could not be updated to firestore
  static Future<void> updateEachBallScoreToFireStore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    bool thisIsFirstInnings,
    String bowlerName,
    String eachBallScore, {
    required Duration timeout,
  }) async {
    final String fieldName =
        thisIsFirstInnings ? 'innings1bowler' : 'innings2bowler';

    List newBowlerScore = [];

    final documentIdOfUser = _getDocumentIdOfUser(user);

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(fieldName)
        .get()
        .then((docSnapshot) {
      final bowlerScore = docSnapshot.data()![bowlerName];

      for (String score in bowlerScore) {
        newBowlerScore.add(score);
      }
    }).timeout(timeout);

    newBowlerScore.add(eachBallScore);

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(fieldName)
        .update({bowlerName: newBowlerScore}).timeout(timeout);
  }

  /// - null if failure
  /// - matchId if success
  static Future<String?> _getMatchIdOfExistingMatch(
      String userEmail, String matchName, DateTime dateTime) async {
    try {
      final db = FirebaseFirestore.instance;
      String? matchId;

      await db
          .collection('users')
          .doc(userEmail)
          .collection('matches')
          .get()
          .then((querySnapShot) {
        for (var docSnapShot in querySnapShot.docs) {
          final String matchNameOfDoc = docSnapShot['matchName'];
          final Timestamp timestamp = docSnapShot['dateTime'];
          final DateTime dateTimeOfDoc = timestamp.toDate();
          if (matchNameOfDoc == matchName && dateTimeOfDoc == dateTime) {
            matchId = docSnapShot.id;
            break;
          }
        }
      });
      return matchId;
    } catch (_) {
      return null;
    }
  }

  /// eachBallFormat for batter
  /// run,legalBall/wideBall/noBall/notPlayed,catchOut/bowledOut/runOut/hitWicket/notOut
  static ({int run, int ball, bool out}) getBatterScore(List batterScore) {
    int run = 0;
    int ball = 0;
    bool out = false;
    for (var element in batterScore) {
      if (element.runtimeType == String) {
        final eachStrikeScore = element as String;
        var eachBallComponent = eachStrikeScore.split(',');
        run += int.parse(eachBallComponent.first);
        if (eachBallComponent[1] == 'legalBall') {
          ++ball;
        }
        if (eachBallComponent[2] != 'notOut') {
          out = true;
          break;
        }
      }
    }
    return (run: run, ball: ball, out: out);
  }

  /// eachBallFormat for bowler
  /// run,legalBall/wideBall/noBall/notPlayed,catchOut/bowledOut/runOut/hitWicket/notOut
  static ({
    int over,
    int ball,
    int maiden,
    int run,
    int wicket,
    double economy,
    int runOut
  }) getBowlerScore(List bowlerScore) {
    int over = 0;
    int ball = 0;
    int maiden = 0;
    int run = 0;
    int wicket = 0;
    int runOut = 0;
    double economy = 0;

    int countOfConsecutiveDotsInAnOver = 0;

    for (var element in bowlerScore) {
      if (element.runtimeType == String) {
        final eachBallScore = element as String;
        final scoreComponent = eachBallScore.split(',');
        run += int.parse(scoreComponent.first);

        switch (scoreComponent[1]) {
          case 'legalBall':
            ++ball;
            if (ball == 6) {
              ++over;
              ball = 0;
            }
            break;
          case 'wideBall':
            ++run;
            break;
          case 'noBall':
            ++run;
            break;
          default:
        }

        if (scoreComponent[2] == 'catchOut' ||
            scoreComponent[2] == 'bowledOut' ||
            scoreComponent[2] == 'hitWicket') {
          ++wicket;
        }
        if (scoreComponent[2] == 'runOut') {
          ++runOut;
        }

        if (ball == 1) {
          countOfConsecutiveDotsInAnOver = 0;
        }
        if (scoreComponent.first == '0') {
          if (scoreComponent[1] == 'legalBall') {
            ++countOfConsecutiveDotsInAnOver;
            if (countOfConsecutiveDotsInAnOver == 6 && ball == 0) {
              ++maiden;
            }
          } else if (scoreComponent[1] == 'notPlayed') {
          } else {
            countOfConsecutiveDotsInAnOver = 0;
          }
        } else {
          countOfConsecutiveDotsInAnOver = 0;
        }
      }
    }

    double overAndBall = over.toDouble() + ball / 6;
    if (over == 0 && ball == 0) {
    } else {
      economy = run / overAndBall;
    }

    return (
      ball: ball,
      over: over,
      maiden: maiden,
      run: run,
      wicket: wicket,
      economy: economy,
      runOut: runOut,
    );
  }

  /// also returns illegal deliveries
  /// run, legalBall/wideBall/noBall/notPlayed, catchOut/bowledOut/runOut/hitWicket/notOut
  static List<String> getTheseManyBallsFromLast(
      int ball, List<dynamic> ballerScore) {
    Queue<String> thisOver = Queue();
    int legalBallFound = 0;
    for (int i = ballerScore.length - 1; i >= 0; --i) {
      // log.e(i);
      List<String> ballerScoreComponents = ballerScore[i].split(',');
      if (ballerScoreComponents[1] == 'legalBall') {
        ++legalBallFound;
      }
      if (legalBallFound > ball) {
        break;
      } else {
        thisOver.addFirst(ballerScore[i]);
      }
    }

    // log.e('getTheseManyBalls output : ${thisOver}');
    return thisOver.toList();
  }

  static List<String> convertThisOverStatsToConventionalForm(
      List<String> thisOverStats) {
    List<String> presentableStats = [];
    for (String thisBallStats in thisOverStats) {
      String str = '';
      var thisBallStatsComponent = thisBallStats.split(',');
      str += thisBallStatsComponent.first;
      if (thisBallStatsComponent[1] == 'wideBall') {
        str += 'wd';
      } else if (thisBallStatsComponent[1] == 'noBall') {
        str += 'nb';
      }
      if (thisBallStatsComponent[2] != 'notOut') {
        str += 'W';
      }
      presentableStats.add(str);
    }
    return presentableStats;
  }

  static Future<List<String>> fetchBowlerNamesFromFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    bool thisIsFirstInnings,
  ) async {
    List<String> bowlerNames = [];

    final String fieldName =
        thisIsFirstInnings ? 'innings1bowler' : 'innings2bowler';

    final documentIdOfUser = _getDocumentIdOfUser(user);

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(fieldName)
        .get()
        .then((docSnapshot) {
      bowlerNames = docSnapshot.data()!.keys.toList();
    });

    return bowlerNames;
  }

  /// - Success
  ///   - If new bowler name is provided, then adds to bowler name, and returns
  ///     void.
  ///   - If existing bowler name is provided, then does not add to bowler name,
  ///     returns with void
  /// - Failure
  ///   - throws exception if error is found in communication with firebase
  static Future<void> addNewBowlerNameToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    bool thisIsFirstInnings,
    String newBowlerName,
  ) async {
    bool bowlerIsIdentical = true;
    final String fieldName =
        thisIsFirstInnings ? 'innings1bowler' : 'innings2bowler';

    final documentIdOfUser = _getDocumentIdOfUser(user);

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(fieldName)
        .get()
        .then((docSnapshot) {
      final bowlerNames = docSnapshot.data()!.keys;

      for (String bowlerName in bowlerNames) {
        if (bowlerName == newBowlerName) {
          bowlerIsIdentical = false;
          break;
        }
      }
    });

    if (bowlerIsIdentical) {
      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .collection('stats')
          .doc(fieldName)
          .set(
        {newBowlerName: []},
        SetOptions(merge: true),
      );
    }
  }

  ///- returns true if batter is added successfully
  ///- returns false
  ///   - if connection to firestore is lost
  ///   - if batter name already exists
  static Future<bool> addNewBatterNameToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    bool thisIsFirstInnings,
    String newBatterName,
  ) async {
    bool batterIsIdentical = true;

    final documentIdOfUser = _getDocumentIdOfUser(user);

    try {
      final String fieldName =
          thisIsFirstInnings ? 'innings1batter' : 'innings2batter';

      await db
          .collection('users')
          .doc(documentIdOfUser)
          .collection('matches')
          .doc(documentIdOfMatch)
          .collection('stats')
          .doc(fieldName)
          .get()
          .then((docSnapshot) {
        final batterNames = docSnapshot.data()!.keys;

        for (String batterName in batterNames) {
          if (batterName == newBatterName) {
            batterIsIdentical = false;
            break;
          }
        }
      });

      if (batterIsIdentical) {
        await db
            .collection('users')
            .doc(documentIdOfUser)
            .collection('matches')
            .doc(documentIdOfMatch)
            .collection('stats')
            .doc(fieldName)
            .set(
          {newBatterName: []},
          SetOptions(merge: true),
        );

        return true;
      }
    } catch (e) {
      //
    }
    return false;
  }

  /// - returns void on Success
  /// - throws exception on Failure
  static Future<void> updateInnings1HasCompletedToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch, {
    required Duration timeout,
  }) async {
    final documentIdOfUser = _getDocumentIdOfUser(user);

    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .update({'innings1inProgress': false}).timeout(timeout);
  }

  /// - returns void on Success
  /// - throws exception on Failure
  static Future<void> updateInnings2HasStartedToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch, {
    required Duration timeout,
  }) async {
    final documentIdOfUser = _getDocumentIdOfUser(user);
    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .update({'innings2inProgress': true}).timeout(timeout);
  }

  /// - returns void on Success
  /// - throws exception on Failure
  static Future<void> updateInnings2HasCompletedToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch, {
    required Duration timeout,
  }) async {
    final documentIdOfUser = _getDocumentIdOfUser(user);
    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .update({'innings2inProgress': false}).timeout(timeout);
  }

  /// - returns void on Success
  /// - throws exception on Failure
  static Future<void> updateMatchAbandonedToFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch, {
    required Duration timeout,
  }) async {
    final documentIdOfUser = _getDocumentIdOfUser(user);
    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .update({
      'innings1inProgress': false,
      'innings2inProgress': false,
      'matchAbandoned': true,
    }).timeout(timeout);
  }

  static Future<
      ({
        String? snackBarMessage,
        String matchId,
        bool innings1inProgress,
        int maxOvers,
        int innings1runs,
        int innings1overs,
        int innings1balls,
        int innings1wickets,
        int innings2runs,
        int innings2overs,
        int innings2balls,
        int innings2wickets,
        String? batterOnStrikeName,
        String? batter1Name,
        int batter1run,
        int batter1ball,
        String? batter2Name,
        int batter2run,
        int batter2ball,
        String? currentBowler,
        List<String> thisOverStats,
      })> getStatsOfExistingMatch(
    User user,
    String matchName,
    DateTime dateTime,
    Duration transactionTimeout,
  ) async {
    bool innings1inProgress = true;
    int maxOvers = 0;

    int innings1runs = 0;
    int innings1overs = 0;
    int innings1balls = 0;
    int innings1wickets = 0;

    int innings2runs = 0;
    int innings2overs = 0;
    int innings2balls = 0;
    int innings2wickets = 0;

    String? batterOnStrikeName;
    String? batter1Name;
    int batter1run = 0;
    int batter1ball = 0;
    String? batter2Name;
    int batter2run = 0;
    int batter2ball = 0;

    String? currentBowler;
    List<String> thisOverStats = [];

    final db = FirebaseFirestore.instance;
    final userId = _getDocumentIdOfUser(user);

    final matchId =
        await _getMatchIdOfExistingMatch(userId, matchName, dateTime);

    // log.e(matchId);

    try {
      await db
          .collection('users')
          .doc(userId)
          .collection('matches')
          .doc(matchId)
          .get()
          .then((docSnapshot) {
        maxOvers = docSnapshot['maxOvers'];
        bool innings1true = docSnapshot['innings1inProgress'];
        // bool innings2true = docSnapshot['innings2inProgress'];
        innings1inProgress = innings1true;
      }).timeout(transactionTimeout);

      //if innings1 is in progress, then get batter score of innings1 batter
      if (innings1inProgress) {
        await db
            .collection('users')
            .doc(userId)
            .collection('matches')
            .doc(matchId)
            .collection('stats')
            .doc('innings1batter')
            .get()
            .then((docSnapshot) {
          int notOutBatterCount = 0;

          final data = docSnapshot.data();
          // log.e('data : $data');
          if (data != null) {
            // log.e('data.keys : ${data.keys}');
            for (String batter in data.keys) {
              // log.d('inside for loop');
              // log.e('${data[batter].runtimeType}');
              List<String> batterScoreCard = [];

              for (dynamic val in data[batter]) {
                if (val.runtimeType == String) {
                  batterScoreCard.add(val);
                }
              }

              // log.d(batterScoreCard);
              final batterScore = getBatterScore(batterScoreCard);

              if (!batterScore.out) {
                ++notOutBatterCount;
                if (notOutBatterCount == 1) {
                  batter1Name = batter;
                  batter1run = batterScore.run;
                  batter1ball = batterScore.ball;
                } else if (notOutBatterCount == 2) {
                  batter2Name = batter;
                  batter2run = batterScore.run;
                  batter2ball = batterScore.ball;
                  break;
                }
              }
            }
          }
        }).timeout(transactionTimeout);
      }
      //if innings2 is in progress, then get batter score of innings2 batter
      else {
        await db
            .collection('users')
            .doc(userId)
            .collection('matches')
            .doc(matchId)
            .collection('stats')
            .doc('innings2batter')
            .get()
            .then((docSnapshot) {
          int notOutBatterCount = 0;

          final data = docSnapshot.data();
          // log.e('data : $data');
          if (data != null) {
            // log.e('data.keys : ${data.keys}');
            for (String batter in data.keys) {
              // log.d('inside for loop');
              // log.e('${data[batter].runtimeType}');
              List<String> batterScoreCard = [];

              for (dynamic val in data[batter]) {
                if (val.runtimeType == String) {
                  batterScoreCard.add(val);
                }
              }

              // log.d(batterScoreCard);
              final batterScore = getBatterScore(batterScoreCard);

              if (!batterScore.out) {
                ++notOutBatterCount;
                if (notOutBatterCount == 1) {
                  batter1Name = batter;
                  batter1run = batterScore.run;
                  batter1ball = batterScore.ball;
                } else if (notOutBatterCount == 2) {
                  batter2Name = batter;
                  batter2run = batterScore.run;
                  batter2ball = batterScore.ball;
                  break;
                }
              }
            }
          }
        }).timeout(transactionTimeout);
      }

      //  RUN THROUGH INNINGS 1 BOWLER'S DATA
      //  FIND OUT INNINGS 1 RUN, WICKET, OVER, BALL
      //  IF INNINGS 1 IS IN PROGRESS, FIND BOWLER'S NAME, THIS OVER STATS
      await db
          .collection('users')
          .doc(userId)
          .collection('matches')
          .doc(matchId)
          .collection('stats')
          .doc('innings1bowler')
          .get()
          .then((docSnapshot) {
        final data = docSnapshot.data();

        // log.e('innings1bowler data : $data');

        int run = 0, wicket = 0, ball = 0;
        // document exists
        if (data != null) {
          for (String bowler in data.keys) {
            // log.e('bowlerScore of $bowler = ${data[bowler]}');
            final bowlerScore = getBowlerScore(data[bowler]);
            run += bowlerScore.run;
            wicket += bowlerScore.wicket + bowlerScore.runOut;
            ball += bowlerScore.over * 6 + bowlerScore.ball;

            // log.e(bowlerScore);
            if (innings1inProgress) {
              if (bowlerScore.ball != 0) {
                currentBowler = bowler;
                // log.e(currentBowler);
                // log.e('bowlerScore.ball = ${bowlerScore.ball}');
                // log.e('data[bowler] = ${data[bowler]}');

                thisOverStats =
                    getTheseManyBallsFromLast(bowlerScore.ball, data[bowler]);
                // log.e('thisOverStats = $thisOverStats');
                // break;
              }
            }
          }
        }
        // log.e('thisOverStats = $thisOverStats');

        innings1runs = run;
        innings1wickets = wicket;
        innings1overs = ball ~/ 6;
        innings1balls = ball - innings1overs * 6;
      }).timeout(transactionTimeout);

      await db
          .collection('users')
          .doc(userId)
          .collection('matches')
          .doc(matchId)
          .collection('stats')
          .doc('innings2bowler')
          .get()
          .then((docSnapshot) {
        final data = docSnapshot.data();

        int run = 0, wicket = 0, ball = 0;
        // document exists
        if (data != null) {
          for (String bowler in data.keys) {
            // log.e('bowlerScore of $bowler = ${data[bowler]}');
            final bowlerScore = getBowlerScore(data[bowler]);
            run += bowlerScore.run;
            wicket += bowlerScore.wicket + bowlerScore.runOut;
            ball += bowlerScore.over * 6 + bowlerScore.ball;
            // log.i('ball = $ball');

            // log.e('$bowler : $bowlerScore');
            if (!innings1inProgress) {
              if (bowlerScore.ball != 0) {
                currentBowler = bowler;
                // log.e(currentBowler);
                // log.e('bowlerScore.ball = ${bowlerScore.ball}');
                // log.e('data[bowler] = ${data[bowler]}');

                thisOverStats =
                    getTheseManyBallsFromLast(bowlerScore.ball, data[bowler]);
                // log.e('thisOverStats = $thisOverStats');
                // break;
              }
            }
          }

          innings2runs = run;
          innings2wickets = wicket;
          innings2overs = ball ~/ 6;
          innings2balls = ball - innings2overs * 6;

          // log.i(ball);
          // log.i('$innings2overs.$innings2balls');
        }
      }).timeout(transactionTimeout);

      final thisOverStatsForDisplay =
          thisOverStats.map((e) => getEachBallScoreForDisplay(e)).toList();
      // log.e('THIS OVER STATS FOR DISPLAY : $thisOverStatsForDisplay');

      // log.e('${(
      //   snackBarMessage: null,
      //   matchId: matchId ?? '',
      //   innings1inProgress: innings1inProgress,
      //   maxOvers: maxOvers,
      //   innings1runs: innings1runs,
      //   innings1overs: innings1overs,
      //   innings1balls: innings1balls,
      //   innings1wickets: innings1wickets,
      //   innings2runs: innings2runs,
      //   innings2overs: innings2overs,
      //   innings2balls: innings2balls,
      //   innings2wickets: innings2wickets,
      //   batterOnStrikeName: batter1Name,
      //   batter1Name: batter1Name,
      //   batter1run: batter1run,
      //   batter1ball: batter1ball,
      //   batter2Name: batter2Name,
      //   batter2run: batter2run,
      //   batter2ball: batter2ball,
      //   currentBowler: currentBowler,
      //   thisOverStats: thisOverStatsForDisplay,
      // )}');

      return (
        snackBarMessage: null,
        matchId: matchId ?? '',
        innings1inProgress: innings1inProgress,
        maxOvers: maxOvers,
        innings1runs: innings1runs,
        innings1overs: innings1overs,
        innings1balls: innings1balls,
        innings1wickets: innings1wickets,
        innings2runs: innings2runs,
        innings2overs: innings2overs,
        innings2balls: innings2balls,
        innings2wickets: innings2wickets,
        batterOnStrikeName: batter1Name,
        batter1Name: batter1Name,
        batter1run: batter1run,
        batter1ball: batter1ball,
        batter2Name: batter2Name,
        batter2run: batter2run,
        batter2ball: batter2ball,
        currentBowler: currentBowler,
        thisOverStats: thisOverStatsForDisplay,
      );
    } catch (e) {
      return (
        snackBarMessage: e.toString(),
        matchId: matchId ?? '',
        innings1inProgress: innings1inProgress,
        maxOvers: maxOvers,
        innings1runs: innings1runs,
        innings1overs: innings1overs,
        innings1balls: innings1balls,
        innings1wickets: innings1wickets,
        innings2runs: innings2runs,
        innings2overs: innings2overs,
        innings2balls: innings2balls,
        innings2wickets: innings2wickets,
        batterOnStrikeName: batterOnStrikeName,
        batter1Name: batter1Name,
        batter1run: batter1run,
        batter1ball: batter1ball,
        batter2Name: batter2Name,
        batter2run: batter2run,
        batter2ball: batter2ball,
        currentBowler: currentBowler,
        thisOverStats: thisOverStats,
      );
    }
  }

  static Future<
      ({
        User user,
        String matchId,
        String matchName,
        DateTime dateTime,
        int maxOvers,
        bool innings1inProgress,
        bool innings2inProgress,
        List<List<String>> innings1batterScore,
        int innings1score,
        int innings1over,
        int innings1ball,
        int innings1wicket,
        int innings1extra,
        int innings1noBall,
        int innings1wideBall,
        List<List<String>> innings1bowlerScore,
        List<List<String>> innings2batterScore,
        int innings2score,
        int innings2over,
        int innings2ball,
        int innings2wicket,
        int innings2extra,
        int innings2noBall,
        int innings2wideBall,
        List<List<String>> innings2bowlerScore,
      })> fetchScoreCardDataFromFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    Duration timeout,
  ) async {
    final String userId = _getDocumentIdOfUser(user);

    final String matchId = documentIdOfMatch;
    String matchName = '';
    DateTime dateTime = DateTime.now();
    int maxOvers = 0;

    bool innings1inProgress = false;
    bool innings2inProgress = false;

    List<List<String>> innings1batterScore = [];
    int innings1score = 0;
    int innings1over = 0;
    int innings1ball = 0;
    int innings1wicket = 0;
    int innings1extra = 0;
    int innings1noBall = 0;
    int innings1wideBall = 0;
    List<List<String>> innings1bowlerScore = [];

    List<List<String>> innings2batterScore = [];
    int innings2score = 0;
    int innings2over = 0;
    int innings2ball = 0;
    int innings2wicket = 0;
    int innings2extra = 0;
    int innings2noBall = 0;
    int innings2wideBall = 0;
    List<List<String>> innings2bowlerScore = [];

    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(documentIdOfMatch)
        .get()
        .then((docSnapshot) {
      innings1inProgress = docSnapshot['innings1inProgress'];
      innings2inProgress = docSnapshot['innings2inProgress'];
      matchName = docSnapshot['matchName'];
      final Timestamp timestamp = docSnapshot['dateTime'];
      dateTime = timestamp.toDate();
      maxOvers = docSnapshot['maxOvers'];
    }).timeout(timeout);

    // log.i('matchName : $matchName');
    // log.i('dateTime : $dateTime');
    // log.i('maxOvers : $maxOvers');

    if (innings1inProgress) {
      // only fetch innings 1 scorecard
      var inningsScorecard = await getInningsScoreCard(
          db, userId, documentIdOfMatch,
          innings1: true, innings2: false, timeout: timeout);

      innings1batterScore = inningsScorecard.inningsBatterScore;
      innings1score = inningsScorecard.inningsScore;
      innings1over = inningsScorecard.inningsOver;
      innings1ball = inningsScorecard.inningsBall;
      innings1wicket = inningsScorecard.inningsWicket;
      innings1extra = inningsScorecard.inningsExtra;
      innings1noBall = inningsScorecard.inningsNoBall;
      innings1wideBall = inningsScorecard.inningsWideBall;
      innings1bowlerScore = inningsScorecard.inningsBowlerScore;
    } else if ((innings2inProgress) ||
        (!innings1inProgress && !innings2inProgress)) {
      // fetch scorecard of innings 1 and innings 2 both
      var inningsScorecard = await getInningsScoreCard(
        db,
        userId,
        documentIdOfMatch,
        innings1: true,
        innings2: false,
        timeout: timeout,
      );
      innings1batterScore = inningsScorecard.inningsBatterScore;
      innings1score = inningsScorecard.inningsScore;
      innings1over = inningsScorecard.inningsOver;
      innings1ball = inningsScorecard.inningsBall;
      innings1wicket = inningsScorecard.inningsWicket;
      innings1extra = inningsScorecard.inningsExtra;
      innings1noBall = inningsScorecard.inningsNoBall;
      innings1wideBall = inningsScorecard.inningsWideBall;
      innings1bowlerScore = inningsScorecard.inningsBowlerScore;

      var innings2scorecard = await getInningsScoreCard(
        db,
        userId,
        documentIdOfMatch,
        innings1: false,
        innings2: true,
        timeout: timeout,
      );
      innings2batterScore = innings2scorecard.inningsBatterScore;
      innings2score = innings2scorecard.inningsScore;
      innings2over = innings2scorecard.inningsOver;
      innings2ball = innings2scorecard.inningsBall;
      innings2wicket = innings2scorecard.inningsWicket;
      innings2extra = innings2scorecard.inningsExtra;
      innings2noBall = innings2scorecard.inningsNoBall;
      innings2wideBall = innings2scorecard.inningsWideBall;
      innings2bowlerScore = innings2scorecard.inningsBowlerScore;
    }

    return (
      user: user,
      matchId: matchId,
      matchName: matchName,
      dateTime: dateTime,
      maxOvers: maxOvers,
      innings1inProgress: innings1inProgress,
      innings2inProgress: innings2inProgress,
      innings1batterScore: innings1batterScore,
      innings1score: innings1score,
      innings1over: innings1over,
      innings1ball: innings1ball,
      innings1wicket: innings1wicket,
      innings1extra: innings1extra,
      innings1noBall: innings1noBall,
      innings1wideBall: innings1wideBall,
      innings1bowlerScore: innings1bowlerScore,
      innings2batterScore: innings2batterScore,
      innings2score: innings2score,
      innings2over: innings2over,
      innings2ball: innings2ball,
      innings2wicket: innings2wicket,
      innings2extra: innings2extra,
      innings2noBall: innings2noBall,
      innings2wideBall: innings2wideBall,
      innings2bowlerScore: innings2bowlerScore,
    );
  }

  static Future<
      ({
        int inningsScore,
        int inningsOver,
        int inningsBall,
        int inningsWicket,
        int inningsExtra,
        int inningsNoBall,
        int inningsWideBall,
        List<List<String>> inningsBatterScore,
        List<List<String>> inningsBowlerScore,
      })> getInningsScoreCard(
    FirebaseFirestore db,
    String documentIdOfUser,
    String documentIdOfMatch, {
    required bool innings1,
    required bool innings2,
    required Duration timeout,
  }) async {
    if ((innings1 && innings2) || (!innings1 && !innings2)) {
      throw Exception('both innings scorecard cannot be fetched at one using'
          'this function. Run function two times, first time using innings1:true'
          'second time using innings2:true');
    }

    int inningsScore = 0;
    int inningsOver = 0;
    int inningsBall = 0;
    int inningsWicket = 0;
    int inningsExtra = 0;
    int inningsNoBall = 0;
    int inningsWideBall = 0;
    List<List<String>> inningsBatterScore = [];
    List<List<String>> inningsBowlerScore = [];

    //get innings batter
    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(innings1 ? 'innings1batter' : 'innings2batter')
        .get()
        .then((docSnapShot) {
      var data = docSnapShot.data();
      var batterNames = data!.keys;
      // log.i('batterNames : ${batterNames.toList()}');
      for (var batterName in batterNames) {
        final listOfBatterScore = data[batterName];
        // log.i('listOfBatterScore : $listOfBatterScore');
        var batterString = getBatterString(
            batterName: batterName, batterStringScores: listOfBatterScore);
        // log.i('batterString : $batterString');
        inningsBatterScore.add(batterString);
        if (batterString[1] != 'notOut') {
          ++inningsWicket;
        }
        // for (var listOfBatterScore in data[batterName]) {
        // log.i('listOfBatterScore : $listOfBatterScore');
        // var batterString = getBatterString(
        //     batterName: batterName, batterStringScores: listOfBatterScore);
        // log.i('batterString : $batterString');
        // inningsBatterScore.add(batterString);
        // if (batterString[1] != 'notOut') {
        //   ++inningsWicket;
        // }
        // }
      }
    }).timeout(timeout);

    //get innings bowler
    await db
        .collection('users')
        .doc(documentIdOfUser)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc(innings1 ? 'innings1bowler' : 'innings2bowler')
        .get()
        .then((docSnapShot) {
      var data = docSnapShot.data();
      var bowlerNames = data!.keys;

      for (var bowlerName in bowlerNames) {
        final listOfBowlerString = data[bowlerName];
        var bowlerString = getBowlerString(bowlerName, listOfBowlerString);
        inningsBowlerScore.add(bowlerString);

        inningsScore += int.parse(bowlerString[3]);
        List<String> overComponents = bowlerString[1].split('.');
        if (overComponents.length == 1) {
          inningsOver += int.parse(overComponents.first);
        } else {
          inningsOver += int.parse(overComponents.first);
          inningsBall += int.parse(overComponents[1]);
        }

        int noBall = int.parse(bowlerString[5]);
        int wideBall = int.parse(bowlerString[6]);
        inningsNoBall += noBall;
        inningsWideBall += wideBall;
        inningsExtra += noBall + wideBall;
        // for (var listOfBowlerString in data[bowlerName]) {
        //   var bowlerString = getBowlerString(bowlerName, listOfBowlerString);
        //   inningsBowlerScore.add(bowlerString);

        //   inningsScore += int.parse(bowlerString[3]);
        //   List<String> overComponents = bowlerString[1].split('.');
        //   if (overComponents.length == 1) {
        //     inningsOver += int.parse(overComponents.first);
        //   } else {
        //     inningsOver += int.parse(overComponents.first);
        //     inningsBall += int.parse(overComponents[1]);
        //   }

        //   int noBall = int.parse(bowlerString[5]);
        //   int wideBall = int.parse(bowlerString[6]);
        //   inningsNoBall += noBall;
        //   inningsWideBall += wideBall;
        //   inningsExtra += noBall + wideBall;
        // }
      }
    }).timeout(timeout);

    return (
      inningsScore: inningsScore,
      inningsOver: inningsOver,
      inningsBall: inningsBall,
      inningsWicket: inningsWicket,
      inningsExtra: inningsExtra,
      inningsNoBall: inningsNoBall,
      inningsWideBall: inningsWideBall,
      inningsBatterScore: inningsBatterScore,
      inningsBowlerScore: inningsBowlerScore,
    );
  }

  ///   [batterName, catch/runOut/bowled/notOut, Runs, Balls, 4s, 6s, Strike Rate]
  static List<String> getBatterString(
      {required String batterName, required dynamic batterStringScores}) {
    List<String> batterString = [];
    String catchRunBowledNotOut = 'notOut';
    int run = 0;
    int ball = 0;
    int four = 0;
    int six = 0;
    double strikeRate;

    batterString.add(batterName);

    // log.i('batterStringScores.runtimeType : ${batterStringScores.runtimeType}');

    for (String batterPerBallScore in batterStringScores) {
      // log.i('batterPerBallScore : $batterPerBallScore');
      // run,legalBall/wideBall/noBall/notPlayed,catchOut/bowledOut/runOut/hitWicket/notOut
      List<String> scoreComponent = batterPerBallScore.split(',');
      // log.i('scoreComponent : $scoreComponent');
      final thisBallRun = int.parse(scoreComponent.first);

      if (thisBallRun == 4) {
        ++four;
      } else if (thisBallRun == 6) {
        ++six;
      }

      run += thisBallRun;
      if (scoreComponent[1] == 'legalBall') {
        ++ball;
      }
      if (scoreComponent[2] == 'catchOut') {
        catchRunBowledNotOut = 'catchOut';
        break;
      } else if (scoreComponent[2] == 'bowledOut') {
        catchRunBowledNotOut = 'bowledOut';
        break;
      } else if (scoreComponent[2] == 'runOut') {
        catchRunBowledNotOut = 'runOut';
        break;
      } else if (scoreComponent[2] == 'hitWicket') {
        catchRunBowledNotOut = 'catchOut';
        break;
      }
    }

    // strikeRate =
    if (ball == 0) {
      strikeRate = 0;
    } else {
      strikeRate = run / ball * 100;
    }

    return <String>[
      batterName,
      catchRunBowledNotOut,
      run.toString(),
      ball.toString(),
      four.toString(),
      six.toString(),
      strikeRate.toStringAsFixed(2),
    ];
  }

  ///   [bowlerName, Over, Maiden, Runs, Wicket, NoBall, WideBall, Economy]
  static List<String> getBowlerString(
      String bowlerName, dynamic bowlerStringList) {
    int over = 0;
    int ball = 0;
    int maiden = 0;
    int run = 0;
    int wicket = 0;
    int noBall = 0;
    int wideBall = 0;
    double economy = 0;
    bool zeroRunsScoredInThisOver = true;

    // run,
    // legalBall/wideBall/noBall/notPlayed,
    // catchOut/bowledOut/runOut/hitWicket/notOut
    for (String bowlerString in bowlerStringList) {
      List<String> bowlerStringComponent = bowlerString.split(',');
      int runOnThisBall = int.parse(bowlerStringComponent.first);
      if (bowlerStringComponent[1] == 'legalBall') {
        ++ball;

        // 6 balls means over has completed
        if (ball == 6) {
          ++over;
          ball = 0;
          if (zeroRunsScoredInThisOver) {
            ++maiden;
          }
          zeroRunsScoredInThisOver = true; //because new over has started
        }
      } else if (bowlerStringComponent[1] == 'noBall') {
        ++runOnThisBall;
        ++noBall;
      } else if (bowlerStringComponent[1] == 'wideBall') {
        ++runOnThisBall;
        ++wideBall;
      }
      if (bowlerStringComponent[2] == 'catchOut' ||
          bowlerStringComponent[2] == 'bowledOut') {
        ++wicket;
      }

      if (runOnThisBall != 0) {
        zeroRunsScoredInThisOver = false;
      }

      run += runOnThisBall;
    }

    int totalBall = over * 6 + ball;
    if (totalBall != 0) {
      economy = 6 * run / totalBall;
    }

    return <String>[
      bowlerName,
      ball == 0 ? '$over' : '$over.$ball',
      maiden.toString(),
      run.toString(),
      wicket.toString(),
      noBall.toString(),
      wideBall.toString(),
      economy.toStringAsFixed(2),
    ];
  }

  static Future<
      ({
        User user,
        String matchName,
        DateTime dateTime,
        String matchId,
        int maxOvers,
        int innings1runs,
        int innings1overs,
        int innings1balls,
        int innings1wickets,
        int innings2runs,
        int innings2overs,
        int innings2balls,
        int innings2wickets,
        bool matchAbandoned,
      })> fetchMatchCompletedPageDataFromFirestore(
    FirebaseFirestore db,
    User user,
    String documentIdOfMatch,
    Duration transactionTimeout,
  ) async {
    final String userId = _getDocumentIdOfUser(user);
    String matchName = '';
    DateTime dateTime = DateTime.now();
    String matchId = documentIdOfMatch;
    int maxOvers = 0;
    int innings1runs = 0;
    int innings1overs = 0;
    int innings1balls = 0;
    int innings1wickets = 0;
    int innings2runs = 0;
    int innings2overs = 0;
    int innings2balls = 0;
    int innings2wickets = 0;
    bool matchAbandoned = false;

    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(documentIdOfMatch)
        .get()
        .then((docSnapshot) {
      final Timestamp timestamp = docSnapshot['dateTime'];
      dateTime = timestamp.toDate();
      matchName = docSnapshot['matchName'];
      maxOvers = docSnapshot['maxOvers'];
      matchAbandoned = docSnapshot['matchAbandoned'];
    }).timeout(transactionTimeout);
    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc('innings1batter')
        .get()
        .then((docSnapShot) {
      final data = docSnapShot.data();
      final batterNames = data!.keys;

      for (String batterName in batterNames) {
        List<dynamic> batterScoreStringList = data[batterName];
        final batterScore = getBatterScore(batterScoreStringList);
        innings1runs += batterScore.run;
        if (batterScore.out) {
          ++innings1wickets;
        }
        int ball = batterScore.ball;
        int over = ball ~/ 6;
        ball = ball - over * 6;
        innings1overs += over;
        innings1balls += ball;
      }
    }).timeout(transactionTimeout);

    await db
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(documentIdOfMatch)
        .collection('stats')
        .doc('innings2batter')
        .get()
        .then((docSnapShot) {
      final data = docSnapShot.data();
      final batterNames = data!.keys;

      for (String batterName in batterNames) {
        List<dynamic> batterScoreStringList = data[batterName];
        final batterScore = getBatterScore(batterScoreStringList);
        innings2runs += batterScore.run;
        if (batterScore.out) {
          ++innings2wickets;
        }
        int ball = batterScore.ball;
        int over = ball ~/ 6;
        ball = ball - over * 6;
        innings2overs += over;
        innings2balls += ball;
      }
    }).timeout(transactionTimeout);

    return (
      user: user,
      matchName: matchName,
      dateTime: dateTime,
      matchId: matchId,
      maxOvers: maxOvers,
      innings1runs: innings1runs,
      innings1overs: innings1overs,
      innings1balls: innings1balls,
      innings1wickets: innings1wickets,
      innings2runs: innings2runs,
      innings2overs: innings2overs,
      innings2balls: innings2balls,
      innings2wickets: innings2wickets,
      matchAbandoned: matchAbandoned,
    );
  }

  static Future<void> createUserInFirestore(
    UserCredential userCredential,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // final uid = userCredential.user!.uid;

    // String userDocumentName = _getUserDocumentName(userCredential);

    final documentIdOfUser = _getDocumentIdOfUser(userCredential.user!);
    final emailOrPhoneNumber = _getEmailIdOfUser(userCredential.user!);
    await db.collection('users').doc(documentIdOfUser).set(
      {'email': emailOrPhoneNumber, 'password': ''},
      SetOptions(merge: true),
    );
  }

  static Future<ConfirmationResult> sendOtpToUser(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult =
        await auth.signInWithPhoneNumber(phoneNumber);
    return confirmationResult;
  }

  static Future<UserPageState> verifyOtp({
    required ConfirmationResult confirmationResult,
    required String otp,
    required Duration timeout,
  }) async {
    // UserCredential userCredential = await confirmationResult.confirm('123456');
    UserCredential userCredential =
        await confirmationResult.confirm(otp).timeout(timeout);
    final db = FirebaseFirestore.instance;
    final String uid = userCredential.user!.uid;

    // check if user already exists, then
    // if email field already exists, that means user already exists
    bool userAlreadyExists = false;
    await db.collection('users').doc(uid).get().then(
      (docSnapshot) {
        final doc = docSnapshot.data();

        userAlreadyExists = doc != null;

        // final email = docSnapshot['email'];
        // log.i('email: ${email.toString()}');
        // userAlreadyExists = email != null;
        // log.i('userAlreadyExists: $userAlreadyExists');
      },
    ).timeout(timeout);

    // if user does not exist,
    //    then create user,
    //    - uid : uid
    //    - field email : phoneNumber
    //    - collection : matches
    if (!userAlreadyExists) {
      await db
          .collection('users')
          .doc(uid)
          .set({'email': userCredential.user!.phoneNumber}).timeout(timeout);
    }

    List<String> matchName = [];
    List<DateTime> dateTime = [];
    List<bool> matchInProgress = [];
    // int numberOfMatches = 0;

    // fetch
    //  - matchNames
    //  - dateTimes
    //  - matchInProgress
    await db.collection('users').doc(uid).collection('matches').get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            // ++numberOfMatches;
            String thisMatchName = docSnapshot['matchName'];
            matchName.add(thisMatchName);
            Timestamp thisTimeStamp = docSnapshot['dateTime'];
            dateTime.add(thisTimeStamp.toDate());
            final bool innings1inProgress = docSnapshot['innings1inProgress'];
            final bool innings2inProgress = docSnapshot['innings2inProgress'];
            final thisMatchInProgress =
                innings1inProgress || innings2inProgress;
            matchInProgress.add(thisMatchInProgress);
          }
        }
      },
    ).timeout(timeout);

    return UserPageState(
      userCredential.user!,
      matchName,
      dateTime,
      matchInProgress,
    );
  }

  static Future<MatchPageState> updateScoreToFirebase(
    FirebaseFirestore db,
    MatchPageState matchPageState,
    Duration timeout,
  ) async {
    final bool innings1inProgress = matchPageState.innings1isInProgress;

    final int innings1run;
    final int innings1wicket;
    final int innings1over;
    final int innings1ball;

    final int innings2run;
    final int innings2wicket;
    final int innings2over;
    final int innings2ball;

    final String? batter1;
    final int batter1run;
    final int batter1ball;

    final String? batter2;
    final int batter2run;
    final int batter2ball;

    final String? bowler;
    final List<String> thisOverStats;

    final int runByBat;
    final int runExtra =
        (matchPageState.noBall || matchPageState.wideBall) ? 1 : 0;
    final int wicket = (matchPageState.bowled ||
            matchPageState.catchOut ||
            matchPageState.runOutBatter1 ||
            matchPageState.runOutBatter2)
        ? 1
        : 0;
    final int ball = (matchPageState.noBall || matchPageState.wideBall) ? 0 : 1;

    if (matchPageState.zero) {
      runByBat = 0;
    } else if (matchPageState.one) {
      runByBat = 1;
    } else if (matchPageState.two) {
      runByBat = 2;
    } else if (matchPageState.four) {
      runByBat = 4;
    } else if (matchPageState.six) {
      runByBat = 6;
    } else if (matchPageState.three) {
      runByBat = 3;
    } else if (matchPageState.five) {
      runByBat = 5;
    } else {
      runByBat = 0;
    }

    // get bowler string
    String eachBallScoreAsString = FireStoreData.getEachBallScoreAsString(
      runByBat,
      matchPageState.catchOut,
      matchPageState.runOutBatter1 || matchPageState.runOutBatter2,
      matchPageState.bowled,
      matchPageState.wideBall,
      matchPageState.noBall,
    );
    // update to bowler as per innings
    // log.d(eachBallScoreAsString);
    // log.d('TRY: update bowler score');
    if (matchPageState.currentBowler != null) {
      await updateEachBallScoreToFireStore(
        db,
        matchPageState.user,
        matchPageState.matchId,
        matchPageState.innings1isInProgress,
        matchPageState.currentBowler!,
        eachBallScoreAsString,
        timeout: timeout,
      );
    }
    // log.d('SUCCESS: update bowler score');

    // get batter string
    ({String? batter1string, String? batter2string}) getBatterString({
      required String? batter1name,
      required String? batter2name,
      required int runByBat,
      required bool noBall,
      required bool wideBall,
      required bool bowledOut,
      required bool catchOut,
      required bool batter1runOut,
      required bool batter2runOut,
    }) {
      final String? batter1string, batter2string;
      if (null == batter1name) {
        batter1string = null;
      } else {
        final String runString, ballString, outString;

        runString = runByBat.toString();

        if (noBall) {
          ballString = 'noBall';
        } else if (wideBall) {
          ballString = 'wideBall';
        } else {
          ballString = 'legalBall';
        }

        if (bowledOut) {
          outString = 'bowledOut';
        } else if (catchOut) {
          outString = 'catchOut';
        } else if (batter1runOut) {
          outString = 'runOut';
        } else {
          outString = 'notOut';
        }

        batter1string = '$runString,$ballString,$outString';
      }

      if (batter2name != null && batter2runOut) {
        batter2string = '0,notPlayed,runOut';
      } else {
        batter2string = null;
      }

      return (batter1string: batter1string, batter2string: batter2string);
    }

    final batterString = getBatterString(
      batter1name: matchPageState.batter1Name,
      batter2name: matchPageState.batter2Name,
      runByBat: runByBat,
      noBall: matchPageState.noBall,
      wideBall: matchPageState.wideBall,
      bowledOut: matchPageState.bowled,
      catchOut: matchPageState.catchOut,
      batter1runOut: matchPageState.runOutBatter1,
      batter2runOut: matchPageState.runOutBatter2,
    );

    // log.d(batterString);
    // log.d('TRY: update batter score');
    // update to batter as per innings
    if (batterString.batter1string != null) {
      await updateBatterScoreToFireStore(
          db,
          matchPageState.user,
          matchPageState.matchId,
          matchPageState.innings1isInProgress,
          (matchPageState.batter1Name)!,
          (batterString.batter1string)!,
          timeout: timeout);
    }
    if (batterString.batter2string != null) {
      await updateBatterScoreToFireStore(
        db,
        matchPageState.user,
        matchPageState.matchId,
        matchPageState.innings1isInProgress,
        (matchPageState.batter2Name)!,
        (batterString.batter2string)!,
        timeout: timeout,
      );
    }
    // log.d('SUCCESS: update batter score');

    //update UI match scorecard
    (int newOver, int newBall) getIncrementedOverBall(int over, int ball) {
      if (ball == 5) {
        return (over + 1, 0);
      } else {
        return (over, ball + 1);
      }
    }

    if (matchPageState.innings1isInProgress) {
      innings1run = matchPageState.innings1runs + runByBat + runExtra;
      innings1wicket = matchPageState.innings1wickets + wicket;
      if (0 == ball) {
        innings1over = matchPageState.innings1overs;
        innings1ball = matchPageState.innings1balls;
      } else {
        final newOverBall = getIncrementedOverBall(
            matchPageState.innings1overs, matchPageState.innings1balls);
        innings1over = newOverBall.$1;
        innings1ball = newOverBall.$2;
      }

      //innings2 same
      innings2run = matchPageState.innings2runs;
      innings2wicket = matchPageState.innings2wickets;
      innings2over = matchPageState.innings2overs;
      innings2ball = matchPageState.innings2balls;
    } else {
      innings2run = matchPageState.innings2runs + runByBat + runExtra;
      innings2wicket = matchPageState.innings2wickets + wicket;
      if (0 == ball) {
        innings2over = matchPageState.innings2overs;
        innings2ball = matchPageState.innings2balls;
      } else {
        final newOverBall = getIncrementedOverBall(
            matchPageState.innings2overs, matchPageState.innings2balls);
        innings2over = newOverBall.$1;
        innings2ball = newOverBall.$2;
      }

      //innings1 same
      innings1run = matchPageState.innings1runs;
      innings1wicket = matchPageState.innings1wickets;
      innings1over = matchPageState.innings1overs;
      innings1ball = matchPageState.innings1balls;
    }

    //update UI batter scorecard
    if (matchPageState.catchOut ||
        matchPageState.bowled ||
        matchPageState.runOutBatter1) {
      batter1 = matchPageState.batter2Name;
      batter1run = matchPageState.batter2run;
      batter1ball = matchPageState.batter2ball;
      batter2 = null;
      batter2run = 0;
      batter2ball = 0;
    } else if (matchPageState.runOutBatter2) {
      batter1 = matchPageState.batter1Name;
      batter1run = matchPageState.batter1run + runByBat;
      batter1ball = matchPageState.batter1ball + ball;
      batter2 = null;
      batter2run = 0;
      batter2ball = 0;
    } else {
      batter1 = matchPageState.batter1Name;
      batter1run = matchPageState.batter1run + runByBat;
      batter1ball = matchPageState.batter1ball + ball;
      batter2 = matchPageState.batter2Name;
      batter2run = matchPageState.batter2run;
      batter2ball = matchPageState.batter2ball;
    }

    final bool overFinishAndTwoBattersArePlaying;
    final bool singleTakenAndTwoBattersArePlaying =
        runByBat == 1 && (batter1 != null && batter2 != null);

    //update UI bowler name
    if (ball == 1) {
      // final currentOver = innings1inProgress ? innings1over : innings2over;
      // final currentBall = innings1inProgress ? innings1ball : innings2ball;
      // final newOverBall = getIncrementedOverBall(currentOver, currentBall);

      final newBall = innings1inProgress ? innings1ball : innings2ball;

      // bowler = (0 == newOverBall.$2) ? null : matchPageState.currentBowler;
      bowler = (0 == newBall) ? null : matchPageState.currentBowler;

      // log.i('NEW BALL=${newBall}, BOWLER=${bowler}');

      overFinishAndTwoBattersArePlaying =
          newBall == 0 && (batter1 != null && batter2 != null);
    } else {
      bowler = matchPageState.currentBowler;
      overFinishAndTwoBattersArePlaying = false;
    }

    final bool changeStrike;
    if (overFinishAndTwoBattersArePlaying &&
        singleTakenAndTwoBattersArePlaying) {
      changeStrike = false;
    } else if (overFinishAndTwoBattersArePlaying) {
      changeStrike = true;
    } else if (singleTakenAndTwoBattersArePlaying) {
      changeStrike = true;
    } else {
      changeStrike = false;
    }

    //update UI bowler score list
    if (true) {
      // final currentOver = innings1inProgress ? innings1over : innings2over;
      // final currentBall = innings1inProgress ? innings1ball : innings2ball;
      // final newOverBall = getIncrementedOverBall(currentOver, currentBall);

      final newBall = innings1inProgress ? innings1ball : innings2ball;

      if (newBall == 0) {
        thisOverStats = [];
      } else {
        thisOverStats = [
          ...matchPageState.thisOverStats,
          getEachBallScoreForDisplay(eachBallScoreAsString),
        ];
      }
    }

    return MatchPageState(
      snackBarMessage: null,
      user: matchPageState.user,
      matchName: matchPageState.matchName,
      dateTime: matchPageState.dateTime,
      matchId: matchPageState.matchId,
      maxOvers: matchPageState.maxOvers,
      innings1isInProgress: matchPageState.innings1isInProgress,
      innings1runs: innings1run,
      innings1overs: innings1over,
      innings1balls: innings1ball,
      innings1wickets: innings1wicket,
      innings2runs: innings2run,
      innings2overs: innings2over,
      innings2balls: innings2ball,
      innings2wickets: innings2wicket,
      batterOnStrikeName: changeStrike ? batter2 : batter1,
      batter1Name: changeStrike ? batter2 : batter1,
      batter1run: changeStrike ? batter2run : batter1run,
      batter1ball: changeStrike ? batter2ball : batter1ball,
      batter2Name: changeStrike ? batter1 : batter2,
      batter2run: changeStrike ? batter1run : batter2run,
      batter2ball: changeStrike ? batter1ball : batter2ball,
      currentBowler: bowler,
      thisOverStats: thisOverStats,
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
    );
  }

  static Future<UserPageState> fetchUserPageState({
    required FirebaseFirestore db,
    required User user,
    required Duration timeout,
  }) async {
    final List<String> matchName = [];
    final List<DateTime> dateTime = [];
    final List<bool> matchInProgress = [];

    await db.collection('users').doc(user.uid).collection('matches').get().then(
      (querySnapshot) {
        for (var docSnapShot in querySnapshot.docs) {
          matchName.add(docSnapShot['matchName']);
          // log.f(matchName);
          final Timestamp timeStamp = docSnapShot['dateTime'];
          dateTime.add(timeStamp.toDate());
          // log.f(dateTime);
          final bool innings1inProgress = docSnapShot['innings1inProgress'];
          final bool innings2inProgress = docSnapShot['innings2inProgress'];
          matchInProgress.add(innings1inProgress || innings2inProgress);
        }
      },
    ).timeout(timeout);

    return UserPageState(
      user,
      matchName,
      dateTime,
      matchInProgress,
    );
  }
}
