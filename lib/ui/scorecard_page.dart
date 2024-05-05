import 'package:flutter/material.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/ui/home_page.dart';
import 'package:gully_cricket_scorer/ui/match_completed_page.dart';
import 'package:gully_cricket_scorer/ui/match_page.dart';
import 'package:gully_cricket_scorer/data/logging.dart';

class ScoreCardPage extends StatelessWidget {
  const ScoreCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homescreenBloc = BlocProvider.of<HomescreenBloc>(context);

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listenWhen: (previous, current) {
        if (current.runtimeType == MatchPageState) {
          return true;
        }
        if (current.runtimeType == MatchCompletedPageState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.runtimeType == MatchPageState) {
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
      buildWhen: (previous, current) =>
          current.runtimeType == ScoreCardDataState,
      builder: (context, state) {
        final scoreCardDataState = state as ScoreCardDataState;

        final int numberOfTabs;
        if (scoreCardDataState.innings1inProgress) {
          numberOfTabs = 1;
        } else {
          numberOfTabs = 2;
        }

        return TabPageScoreCard(numberOfTabs: numberOfTabs);
      },
    );
  }
}

class TabPageScoreCard extends StatefulWidget {
  final int numberOfTabs;
  const TabPageScoreCard({super.key, required this.numberOfTabs});

  @override
  State<TabPageScoreCard> createState() => _TabPageScoreCardState();
}

class _TabPageScoreCardState extends State<TabPageScoreCard>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.numberOfTabs, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listener: (context, state) {
        if (state.runtimeType == ScoreCardDataState) {
          final scoreCardDataState = state as ScoreCardDataState;
          if (scoreCardDataState.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(scoreCardDataState.errorMessage!),
                duration: bloc.getRepository().getTimers().snackBarTime1,
              ),
            );
          }
        }
      },
      buildWhen: (previous, current) {
        if (current.runtimeType == ScoreCardDataState) {
          final scoreCardDataState = current as ScoreCardDataState;
          if (scoreCardDataState.errorMessage == null) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        final colors = bloc.getRepository().getColors();
        final fonts = bloc.getRepository().getFonts();
        final dimensions = bloc.getRepository().getDimensions();

        final scoreCardDataState = state as ScoreCardDataState;

        final dateTimeParts =
            MatchCardData.getPartsOfDateTime(scoreCardDataState.dateTime);

        final int numberOfTabs;
        if (scoreCardDataState.innings1inProgress) {
          numberOfTabs = 1;
        } else {
          numberOfTabs = 2;
        }

        List<Widget> tabs = [];
        final teamNames = scoreCardDataState.matchName.split('vs');
        // if (numberOfTabs == 1) {
        tabs.add(Text(
          '${teamNames.first}\n${scoreCardDataState.innings1score}'
          '/${scoreCardDataState.innings1wicket} '
          '(${scoreCardDataState.innings1over}.${scoreCardDataState.innings1ball}/'
          '${scoreCardDataState.maxOvers})',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.darkBackgroundFontColor1,
            fontSize: fonts.fontSize2,
            fontWeight: fonts.fontWeight2,
          ),
        ));
        // }
        if (numberOfTabs == 2) {
          tabs.add(Text(
            '${teamNames[1]}\n${scoreCardDataState.innings2score}'
            '/${scoreCardDataState.innings2wicket} '
            '(${scoreCardDataState.innings2over}.${scoreCardDataState.innings2ball}/'
            '${scoreCardDataState.maxOvers})',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.darkBackgroundFontColor1,
              fontSize: fonts.fontSize2,
              fontWeight: fonts.fontWeight2,
            ),
          ));
        }

        List<Widget> tabBarViewChildren = [];
        tabBarViewChildren.add(
          Scaffold(
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
                BattingScoreCardWidget(
                  inningsBatterScore: scoreCardDataState.innings1batterScore,
                  inningsScore: scoreCardDataState.innings1score,
                  inningsOver: scoreCardDataState.innings1over,
                  inningsBall: scoreCardDataState.innings1ball,
                  inningsWicket: scoreCardDataState.innings1wicket,
                  inningsExtra: scoreCardDataState.innings1extra,
                  inningsNoBall: scoreCardDataState.innings1noBall,
                  inningsWideBall: scoreCardDataState.innings1wideBall,
                ),
                BowlingScoreCardWidget(
                    inningsBowlerScore: scoreCardDataState.innings1bowlerScore),
              ],
            ),
            // ),
          ),
        );
        if (numberOfTabs == 2) {
          tabBarViewChildren.add(
            Scaffold(
              body: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  BattingScoreCardWidget(
                    inningsBatterScore: scoreCardDataState.innings2batterScore,
                    inningsScore: scoreCardDataState.innings2score,
                    inningsOver: scoreCardDataState.innings2over,
                    inningsBall: scoreCardDataState.innings2ball,
                    inningsWicket: scoreCardDataState.innings2wicket,
                    inningsExtra: scoreCardDataState.innings2extra,
                    inningsNoBall: scoreCardDataState.innings2noBall,
                    inningsWideBall: scoreCardDataState.innings2wideBall,
                  ),
                  BowlingScoreCardWidget(
                      inningsBowlerScore:
                          scoreCardDataState.innings2bowlerScore),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.darkBackgroundColor1,
            automaticallyImplyLeading: false,
            leading: IconButton(
              color: colors.darkBackgroundFontColor1,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: scoreCardDataState.disableButton
                  ? null
                  : () {
                      //BACK BUTTON LOGIC
                      //if match has ended, then open match completed page
                      //if match has not ended, then open match page new
                      final bool matchInProgress =
                          (!scoreCardDataState.innings1inProgress &&
                                  !scoreCardDataState.innings2inProgress)
                              ? false
                              : true;

                      bloc.add(OpenExistingMatchEvent(
                        scoreCardDataState.user,
                        scoreCardDataState.matchName,
                        scoreCardDataState.dateTime,
                        matchInProgress,
                      ));
                    },
            ),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Scorecard',
                  style: TextStyle(
                    color: colors.darkBackgroundFontColor1,
                    fontSize: fonts.fontSize1,
                    fontWeight: fonts.fontWeight1,
                  ),
                ),
                Text(
                  '${dateTimeParts.yyyyDotMmmDotDd}'
                  '  ${dateTimeParts.hhColonMmAm}',
                  style: TextStyle(
                    color: colors.darkBackgroundFontColor1,
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ],
            ),
            bottom: TabBar(controller: _tabController, tabs: tabs),
          ),
          body: TabBarView(
            controller: _tabController,
            children: tabBarViewChildren,
          ),
        );
      },
    );
  }
}

class BattingScoreCardWidget extends StatelessWidget {
  final int inningsScore;
  final int inningsOver;
  final int inningsBall;
  final int inningsWicket;
  final int inningsExtra;
  final int inningsNoBall;
  final int inningsWideBall;

  /// [
  ///   [batterName, catch/runOut/bowled, Runs, Balls, 4s, 6s, Strike Rate]
  /// ]
  final List<List<String>> inningsBatterScore;

  const BattingScoreCardWidget({
    super.key,
    required this.inningsBatterScore,
    required this.inningsScore,
    required this.inningsOver,
    required this.inningsBall,
    required this.inningsWicket,
    required this.inningsExtra,
    required this.inningsNoBall,
    required this.inningsWideBall,
  });

  static String _getBetterLookingBatterOutString(String outString) {
    switch (outString) {
      case 'bowledOut':
        return 'bowled';
      case 'notOut':
        return 'not out';
      case 'catchOut':
        return 'catch';
      case 'runOut':
        return 'run out';
      default:
        return ' ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final fonts = bloc.getRepository().getFonts();
    final dimensions = bloc.getRepository().getDimensions();

    Table table;
    Widget extras;

    List<TableRow> tableRows = [];
    for (List<String> eachBatterStats in inningsBatterScore) {
      List<Widget> tableRowWidgets = [];
      tableRowWidgets.add(const Text(' '));
      tableRowWidgets.add(Text(
        eachBatterStats.first,
        softWrap: true,
        style: TextStyle(
          fontSize: fonts.fontSize4,
          fontWeight: fonts.fontWeight4,
          color: colors.lightBackgroundFontColor2,
          fontFamily: fonts.fontFamily4,
        ),
      ));
      // tableRowWidgets.add(Row(children: [
      //   const SizedBox(width: 10),
      //   Text(
      //     eachBatterStats[1],
      //     softWrap: true,
      //     style: TextStyle(
      //       fontWeight: fonts.fontWeight2,
      //       fontSize: fonts.fontSize2,
      //       color: colors.lightBackgroundFontColor2,
      //     ),
      //   ),
      // ]));

      tableRowWidgets.add(
        Text(
          _getBetterLookingBatterOutString(eachBatterStats[1]),
          softWrap: true,
          style: TextStyle(
            fontSize: fonts.fontSize4,
            fontWeight: fonts.fontWeight4,
            color: colors.lightBackgroundFontColor2,
            fontFamily: fonts.fontFamily4,
          ),
        ),
      );

      for (int i = 2; i < eachBatterStats.length; ++i) {
        tableRowWidgets.add(Text(
          eachBatterStats[i],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fonts.fontSize4,
            fontWeight: fonts.fontWeight4,
            color: colors.lightBackgroundFontColor2,
            fontFamily: fonts.fontFamily4,
          ),
        ));
      }

      tableRows.add(TableRow(children: tableRowWidgets));
    }

    table = Table(
      columnWidths: const {
        0: FixedColumnWidth(10),
        1: FlexColumnWidth(6),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
        7: FixedColumnWidth(50),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: colors.lightBackgroundColor2,
        ),
        bottom: BorderSide(
          color: colors.lightBackgroundColor2,
        ),
      ),
      children: [
            TableRow(
              decoration: BoxDecoration(color: colors.lightBackgroundColor2),
              children: [
                const Text(' '),
                Text(
                  'Batter',
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  'B',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  '4s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  '6s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
                Text(
                  'SR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fonts.fontSize4,
                    fontWeight: fonts.fontWeight4,
                    color: colors.lightBackgroundFontColor2,
                    fontFamily: fonts.fontFamily4,
                  ),
                ),
              ],
            )
          ] +
          tableRows,
    );

    extras = Text(
      'Extras   $inningsExtra (WD $inningsWideBall, NB $inningsNoBall)',
      style: TextStyle(
        fontSize: fonts.fontSize4,
        fontWeight: fonts.fontWeight4,
        color: colors.lightBackgroundFontColor2,
        fontFamily: fonts.fontFamily4,
      ),
    );

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(
            dimensions.borderRadius / 2,
            dimensions.borderRadius / 2,
            dimensions.borderRadius / 2,
            dimensions.borderRadius / 2,
          ),
          child: table,
        ),
        extras,
      ],
    );
  }
}

class BowlingScoreCardWidget extends StatelessWidget {
  /// [
  ///   [bowlerName, Over, Maiden, Runs, Wicket, NoBall, WideBall, Economy]
  /// ]
  final List<List<String>> inningsBowlerScore;

  const BowlingScoreCardWidget({super.key, required this.inningsBowlerScore});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final fonts = bloc.getRepository().getFonts();
    final dimensions = bloc.getRepository().getDimensions();

    List<TableRow> tableRows = [];
    for (List<String> eachBowlerStats in inningsBowlerScore) {
      List<Widget> tableRowWidgets = [];
      tableRowWidgets.add(const Text(' '));
      tableRowWidgets.add(Text(
        eachBowlerStats.first,
        style: TextStyle(
          fontSize: fonts.fontSize4,
          fontWeight: fonts.fontWeight4,
          color: colors.lightBackgroundFontColor2,
          fontFamily: fonts.fontFamily4,
        ),
      ));

      tableRowWidgets.add(Container(
        alignment: Alignment.center,
        child: Text(
          eachBowlerStats[1],
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: fonts.fontSize4,
            fontWeight: fonts.fontWeight4,
            color: colors.lightBackgroundFontColor2,
            fontFamily: fonts.fontFamily4,
          ),
        ),
      ));

      for (int i = 2; i < eachBowlerStats.length; ++i) {
        tableRowWidgets.add(Text(
          eachBowlerStats[i],
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: fonts.fontSize4,
            fontWeight: fonts.fontWeight4,
            color: colors.lightBackgroundFontColor2,
            fontFamily: fonts.fontFamily4,
          ),
        ));
      }

      tableRows.add(TableRow(children: tableRowWidgets));
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        dimensions.borderRadius / 2,
        dimensions.borderRadius / 2,
        dimensions.borderRadius / 2,
        dimensions.borderRadius / 2,
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(10),
          1: FlexColumnWidth(5),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
          6: FlexColumnWidth(1),
          7: FlexColumnWidth(1),
          8: FixedColumnWidth(50),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: colors.lightBackgroundColor2,
          ),
          bottom: BorderSide(
            color: colors.lightBackgroundColor2,
          ),
        ),
        children: [
              TableRow(
                decoration: BoxDecoration(color: colors.lightBackgroundColor2),
                children: [
                  const Text(' '),
                  Text(
                    'Bowler',
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'O',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'M',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'R',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'W',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'NB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'WD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                  Text(
                    'ECO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      color: colors.lightBackgroundFontColor2,
                      fontFamily: fonts.fontFamily4,
                    ),
                  )
                ],
              )
            ] +
            tableRows,
      ),
    );
  }
}
