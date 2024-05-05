import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/create_new_match_page.dart';
import 'package:gully_cricket_scorer/ui/match_completed_page.dart';
import 'package:gully_cricket_scorer/ui/match_page.dart';
import 'package:gully_cricket_scorer/ui/phone_login_page.dart';

class MyHomePage extends StatelessWidget {
  final User user;
  const MyHomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homescreenBloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = homescreenBloc.getRepository().getColors();
    final fonts = homescreenBloc.getRepository().getFonts();
    final dimensions = homescreenBloc.getRepository().getDimensions();

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listenWhen: (previous, current) {
        if (current.runtimeType == UserPageState) {
          final userPageState = current as UserPageState;
          if (userPageState.snackBarMessageOrNull != null) {
            return true;
          }
        }
        if (current.runtimeType == SignOutSuccessState) {
          return true;
        }
        if (current.runtimeType == MatchPageState) {
          return true;
        }
        if (current.runtimeType == MatchCompletedPageState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.runtimeType == UserPageState) {
          final userPageState = state as UserPageState;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userPageState.snackBarMessageOrNull ?? ''),
              duration: const Duration(milliseconds: 500),
            ),
          );
        } else if (state.runtimeType == SignOutSuccessState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const PhoneLoginPage(),
              ),
            ),
          );
        } else if (state.runtimeType == MatchPageState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const MatchPageNew(),
              ),
            ),
          );
        } else if (state.runtimeType == MatchCompletedPageState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const MatchCompletedPage(),
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.runtimeType == UserPageState,
      builder: (context, state) {
        final userPageState = state as UserPageState;
        final disableButton = userPageState.disableButton;

        List<Widget> matchSelectWidget = [];
        List<MatchCardData> matchCardDatas = [];
        for (int i = 0; i < userPageState.matchName.length; ++i) {
          matchCardDatas.add(MatchCardData(
            matchName: userPageState.matchName[i],
            dateTime: userPageState.dateTime[i],
            matchInProgress: userPageState.matchInProgress[i],
          ));
        }

        matchCardDatas.sort((elem1, elem2) => MatchCardData.comp(elem1, elem2));

        for (int i = 0; i < matchCardDatas.length; ++i) {
          final name = matchCardDatas[i].matchName;
          final dateTimeParts =
              MatchCardData.getPartsOfDateTime(matchCardDatas[i].dateTime);

          matchSelectWidget.add(GestureDetector(
            onTap: disableButton
                ? null
                : () {
                    homescreenBloc.add(OpenExistingMatchEvent(
                      user,
                      name,
                      matchCardDatas[i].dateTime,
                      matchCardDatas[i].matchInProgress,
                    ));
                  },
            child: Card(
              margin: EdgeInsets.fromLTRB(
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
              ),
              child: SizedBox(
                height: dimensions.heightOfButton * 1.25,
                child: Column(
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fonts.fontSize2,
                        fontWeight: fonts.fontWeight2,
                        color: disableButton
                            ? colors.lightBackgroundFontColorDisabled1
                            : colors.lightBackgroundFontColor1,
                      ),
                    ),
                    Text(
                      '${dateTimeParts.yyyyDotMmmDotDd}  '
                      '${dateTimeParts.hhColonMmAm}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fonts.fontSize2,
                        fontWeight: fonts.fontWeight2,
                        color: disableButton
                            ? colors.lightBackgroundFontColorDisabled1
                            : colors.lightBackgroundFontColor1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.darkBackgroundColor1,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Gully Cricket Scorer',
                  style: TextStyle(
                    color: colors.darkBackgroundFontColor1,
                    fontSize: fonts.fontSize1,
                    fontWeight: fonts.fontWeight1,
                  ),
                ),
                Text(
                  'Signed in as ${user.phoneNumber}',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    color: colors.darkBackgroundFontColor1,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: disableButton
                    ? null
                    : () {
                        homescreenBloc.add(SignOutEvent());
                      },
                icon: Icon(
                  Icons.power_settings_new_outlined,
                  color: disableButton
                      ? colors.darkBackgroundFontColor2
                      : colors.darkBackgroundFontColor1,
                ),
              ),
            ],
          ),
          backgroundColor: colors.lightBackgroundColor1,
          body: Column(children: [
            GestureDetector(
              onTap: disableButton
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          value: homescreenBloc,
                          child: const Dialog(child: CreateNewMatchDialog()),
                        ),
                      );
                    },
              child: Card(
                color: disableButton
                    ? colors.disabledButtonColor
                    : colors.darkBackgroundColor1,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius)),
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  dimensions.borderRadius / 2,
                  dimensions.borderRadius,
                  dimensions.borderRadius / 2,
                ),
                child: Container(
                  height: dimensions.heightOfButton * 1.25,
                  alignment: Alignment.center,
                  child: Text(
                    'Create new match',
                    style: TextStyle(
                      fontSize: fonts.fontSize2,
                      fontWeight: fonts.fontWeight2,
                      color: disableButton
                          ? colors.disabledButtonFontColor
                          : colors.darkBackgroundFontColor1,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Or',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fonts.fontSize2,
                fontWeight: fonts.fontWeight2,
                color: colors.lightBackgroundFontColor1,
              ),
            ),
            Text(
              'Open existing match',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fonts.fontSize2,
                fontWeight: fonts.fontWeight2,
                color: colors.lightBackgroundFontColor1,
              ),
            ),
            Expanded(
              child: ListView(
                children: matchSelectWidget,
              ),
            ),
          ]),
        );
      },
    );
  }
}

class MatchCardData {
  String matchName;
  DateTime dateTime;
  bool matchInProgress;
  MatchCardData({
    required this.matchName,
    required this.dateTime,
    required this.matchInProgress,
  });

  /// returns
  /// - -1 if first is after second
  /// - +1 if first is before second
  static int comp(MatchCardData first, MatchCardData second) {
    if (first.dateTime.isBefore(second.dateTime)) {
      return 1;
    } else {
      return -1;
    }
  }

  static ({
    String yyyyDotMmmDotDd,
    String hhColonMmAm,
  }) getPartsOfDateTime(DateTime dateTime) {
    final String dateTimeString = '$dateTime';
    final dateTimeStringComponents = dateTimeString.split(' ');
    final date = dateTimeStringComponents.first;
    final dateParts = date.split('-');
    final yyyy = dateParts.first;
    final String mmm;
    switch (int.parse(dateParts[1])) {
      case 1:
        mmm = 'Jan';
        break;
      case 2:
        mmm = 'Feb';
        break;
      case 3:
        mmm = 'Mar';
        break;
      case 4:
        mmm = 'Apr';
        break;
      case 5:
        mmm = 'May';
        break;
      case 6:
        mmm = 'Jun';
        break;
      case 7:
        mmm = 'Jul';
        break;
      case 8:
        mmm = 'Aug';
        break;
      case 9:
        mmm = 'Sep';
        break;
      case 10:
        mmm = 'Oct';
        break;
      case 11:
        mmm = 'Nov';
        break;
      case 12:
        mmm = 'Dec';
        break;
      default:
        mmm = '###';
        break;
    }

    final dd = dateParts[2];

    final timeComponents = dateTimeStringComponents[1].split(':');
    final hh = timeComponents.first;
    final hhAsInt = int.parse(hh);
    final hhFinal = (hhAsInt > 12) ? hhAsInt - 12 : hhAsInt;
    final mm = timeComponents[1];

    return (
      yyyyDotMmmDotDd: '$yyyy-$mmm-$dd',
      hhColonMmAm: '$hhFinal:$mm ${hhAsInt > 12 ? 'pm' : 'am'}',
    );
  }
}
