import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/home_page.dart';
import 'package:gully_cricket_scorer/ui/scorecard_page.dart';

class MatchCompletedPage extends StatelessWidget {
  const MatchCompletedPage({super.key});

  @override
  Widget build(context) {
    final homescreenBloc = BlocProvider.of<HomescreenBloc>(context);

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listenWhen: (previous, current) {
        if (current.runtimeType == MatchCompletedPageState) {
          final matchCompletedPageState = current as MatchCompletedPageState;
          if (matchCompletedPageState.snackBarMessageOrNull != null) {
            return true;
          }
        } else if (current.runtimeType == ScoreCardDataState) {
          return true;
        } else if (current.runtimeType == UserPageState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.runtimeType == MatchCompletedPageState) {
          final matchCompletedPageState = state as MatchCompletedPageState;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(matchCompletedPageState.snackBarMessageOrNull ?? ''),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state.runtimeType == ScoreCardDataState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const ScoreCardPage(),
              ),
            ),
          );
        } else if (state.runtimeType == UserPageState) {
          final userPageState = state as UserPageState;
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: MyHomePage(user: userPageState.user),
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current.runtimeType == MatchCompletedPageState,
      builder: (context, state) {
        final disableButton = (state as MatchCompletedPageState).disableButton;
        final bloc = BlocProvider.of<HomescreenBloc>(context);
        final colors = bloc.getRepository().getColors();
        final fonts = bloc.getRepository().getFonts();
        final dimensions = bloc.getRepository().getDimensions();

        List<Widget> columnWidgets = [];
        final matchCompletedPageState = state as MatchCompletedPageState;

        final teamNames = matchCompletedPageState.matchName.split('vs');
        final team1name = teamNames.first;
        final team2name = teamNames[1];

        bool innings1ballNotBowled = matchCompletedPageState.innings1overs * 6 +
                matchCompletedPageState.innings1balls ==
            0;

        final widgetInnings1Score = innings1ballNotBowled
            ? <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Did not bat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            : <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${matchCompletedPageState.innings1runs}'
                        '/${matchCompletedPageState.innings1wickets}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Overs: ${matchCompletedPageState.innings1overs}'
                        '.${matchCompletedPageState.innings1balls}'
                        '/${matchCompletedPageState.maxOvers}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
              ];

        columnWidgets.add(
          Card(
            margin: EdgeInsets.all(dimensions.borderRadius / 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
              ),
              child: Column(
                children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team1name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.lightBackgroundFontColor1,
                                fontSize: fonts.fontSize2,
                                fontWeight: fonts.fontWeight2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] +
                    widgetInnings1Score,
              ),
            ),
          ),
        );

        bool innings2ballNotBowled = matchCompletedPageState.innings2overs * 6 +
                matchCompletedPageState.innings2balls ==
            0;

        final widgetInnings2Score = innings2ballNotBowled
            ? <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Did not bat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            : <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${matchCompletedPageState.innings2runs}'
                        '/${matchCompletedPageState.innings2wickets}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Overs: ${matchCompletedPageState.innings2overs}'
                        '.${matchCompletedPageState.innings2balls}'
                        '/${matchCompletedPageState.maxOvers}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.lightBackgroundFontColor1,
                          fontSize: fonts.fontSize2,
                          fontWeight: fonts.fontWeight2,
                        ),
                      ),
                    ),
                  ],
                ),
              ];

        columnWidgets.add(
          Card(
            margin: EdgeInsets.all(dimensions.borderRadius / 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
              ),
              child: Column(
                children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team2name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.lightBackgroundFontColor1,
                                fontSize: fonts.fontSize2,
                                fontWeight: fonts.fontWeight2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] +
                    widgetInnings2Score,
              ),
            ),
          ),
        );

        columnWidgets.add(GestureDetector(
          onTap: disableButton
              ? null
              : () {
                  // log.i('MatchCompletedPage: Show Scorecard button pressed');
                  bloc.add(ShowScoreCardEvent(matchCompletedPageState.user,
                      matchCompletedPageState.matchId));
                },
          child: Card(
            color: disableButton
                ? colors.disabledButtonBorderColor
                : colors.buttonColor,
            margin: EdgeInsets.all(dimensions.borderRadius / 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
            ),
            child: Container(
              alignment: Alignment.center,
              height: dimensions.heightOfButton,
              child: Text(
                'Show Scorecard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: disableButton
                      ? colors.disabledButtonFontColor
                      : colors.buttonFontColor,
                  fontSize: fonts.fontSize2,
                  fontWeight: fonts.fontWeight2,
                ),
              ),
            ),
          ),
        ));

        final dateTimeParts =
            MatchCardData.getPartsOfDateTime(matchCompletedPageState.dateTime);

        return Scaffold(
          backgroundColor: colors.lightBackgroundColor1,
          appBar: AppBar(
            backgroundColor: colors.darkBackgroundColor1,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: disableButton
                  ? colors.disabledButtonFontColor
                  : colors.buttonFontColor,
              onPressed: disableButton
                  ? null
                  : () {
                      homescreenBloc
                          .add(OpenUserPageFromMatchCompletedPageEvent());
                      // log.i('MatchCompletedPage: Back button pressed');
                    },
            ),
            centerTitle: true,
            title: Column(children: [
              Text(
                matchCompletedPageState.matchName,
                style: TextStyle(
                  color: colors.darkBackgroundFontColor1,
                  fontSize: fonts.fontSize1,
                  fontWeight: fonts.fontWeight1,
                ),
                softWrap: true,
              ),
              Text(
                '${dateTimeParts.yyyyDotMmmDotDd}  ${dateTimeParts.hhColonMmAm}',
                style: TextStyle(
                  color: colors.darkBackgroundFontColor1,
                  fontWeight: fonts.fontWeight2,
                  fontSize: fonts.fontSize2,
                ),
              )
            ]),
          ),
          body: Column(
            children: columnWidgets,
          ),
        );
      },
    );
  }
}
