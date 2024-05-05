import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/home_page.dart';
import 'package:gully_cricket_scorer/ui/match_completed_page.dart';
import 'package:gully_cricket_scorer/ui/scorecard_page.dart';

class EachBallScoreWidget extends StatelessWidget {
  const EachBallScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color chosenButtonColor = Colors.green;
    Color defaultButtonColor = Colors.white;
    Color disabledButtonColor = Colors.grey.shade400;
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    return BlocBuilder<HomescreenBloc, HomescreenState>(
      buildWhen: (previous, current) => current.runtimeType == MatchPageState,
      builder: (context, state) {
        final matchPageState = state as MatchPageState;

        List<Widget> runOutBatterButtons = [];
        final batter1Name = matchPageState.batter1Name;
        final batter2Name = matchPageState.batter2Name;
        if (batter1Name != null) {
          runOutBatterButtons.add(
            TextButton(
              onPressed: (matchPageState.currentBowler == null ||
                      matchPageState.batterOnStrikeName == null)
                  ? null
                  : () {
                      bloc.add(OutRunBatter1Event());
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? disabledButtonColor
                      : matchPageState.runOutBatter1
                          ? chosenButtonColor
                          : defaultButtonColor,
                ),
              ),
              child: Text('Run Out\n$batter1Name'),
            ),
          );
        }
        if (batter2Name != null) {
          runOutBatterButtons.add(
            TextButton(
              onPressed: (matchPageState.currentBowler == null ||
                      matchPageState.batterOnStrikeName == null)
                  ? null
                  : () {
                      bloc.add(OutRunBatter2Event());
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? disabledButtonColor
                      : matchPageState.runOutBatter2
                          ? chosenButtonColor
                          : defaultButtonColor,
                ),
              ),
              child: Text('Run Out\n$batter2Name'),
            ),
          );
        }

        bool updateScoreButtonIsDisabled = false;
        if (matchPageState.currentBowler == null ||
            matchPageState.batterOnStrikeName == null) {
          updateScoreButtonIsDisabled = true;
        } else if (matchPageState.innings1isInProgress) {
          if (matchPageState.innings1overs == matchPageState.maxOvers &&
              matchPageState.innings1balls == 0) {
            updateScoreButtonIsDisabled = true;
          }
        } else if (!matchPageState.innings1isInProgress) {
          if (matchPageState.innings2overs == matchPageState.maxOvers &&
              matchPageState.innings2balls == 0) {
            updateScoreButtonIsDisabled = true;
          }
        } else if (matchPageState.batter1Name == null &&
            matchPageState.batter2Name == null) {
          updateScoreButtonIsDisabled = true;
        }

        return Column(
          children: [
            Row(
              children: <Widget>[
                    TextButton(
                      onPressed: (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? null
                          : () {
                              bloc.add(OutBowledEvent());
                            },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          (matchPageState.currentBowler == null ||
                                  matchPageState.batterOnStrikeName == null)
                              ? disabledButtonColor
                              : matchPageState.bowled == true
                                  ? chosenButtonColor
                                  : defaultButtonColor,
                        ),
                      ),
                      child: const Text('bowled'),
                    ),
                    TextButton(
                      onPressed: (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? null
                          : () {
                              bloc.add(OutCatchEvent());
                            },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          (matchPageState.currentBowler == null ||
                                  matchPageState.batterOnStrikeName == null)
                              ? disabledButtonColor
                              : matchPageState.catchOut
                                  ? chosenButtonColor
                                  : defaultButtonColor,
                        ),
                      ),
                      child: const Text('Catch Out'),
                    ),
                  ] +
                  runOutBatterButtons,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(NoBallEvent());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.noBall == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('No ball'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(WideBallEvent());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.wideBall == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('Wide ball'),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run0Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.zero == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('0'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run1Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.one == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('1'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run2Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.two == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('2'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run3Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.three == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('3'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run4Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.four == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('4'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run5Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.five == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('5'),
                ),
                TextButton(
                  onPressed: (matchPageState.currentBowler == null ||
                          matchPageState.batterOnStrikeName == null)
                      ? null
                      : () {
                          bloc.add(Run6Event());
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (matchPageState.currentBowler == null ||
                              matchPageState.batterOnStrikeName == null)
                          ? disabledButtonColor
                          : matchPageState.six == true
                              ? chosenButtonColor
                              : defaultButtonColor,
                    ),
                  ),
                  child: const Text('6'),
                ),
              ],
            ),
            TextButton(
              onPressed: updateScoreButtonIsDisabled
                  ? null
                  : () {
                      bloc.add(UpdateScoreEvent());
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  updateScoreButtonIsDisabled
                      ? disabledButtonColor
                      : matchPageState.updateScore
                          ? chosenButtonColor
                          : defaultButtonColor,
                ),
              ),
              child: const Text('Update Score'),
            ),
          ],
        );
      },
    );
  }
}

class AddNewBatterDialog extends StatefulWidget {
  const AddNewBatterDialog({super.key});

  @override
  State<AddNewBatterDialog> createState() => _AddNewBatterDialogState();
}

class _AddNewBatterDialogState extends State<AddNewBatterDialog> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();

    return BlocBuilder<HomescreenBloc, HomescreenState>(
      bloc: bloc,
      builder: (context, state) {
        final widthOfDialog =
            bloc.getRepository().getDimensions().dialogBoxWidth;
        return Container(
          width: widthOfDialog,
          height: dimensions.heightOfButton * 3 + 4 * dimensions.borderRadius,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
          ),
          child: Column(
            children: [
              SizedBox(height: dimensions.borderRadius),
              Container(
                height: dimensions.heightOfButton,
                width: widthOfDialog,
                alignment: Alignment.center,
                child: Text(
                  'Enter new Batter',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ),
              SizedBox(height: dimensions.borderRadius),
              Container(
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  0,
                  dimensions.borderRadius,
                  0,
                ),
                height: dimensions.heightOfButton,
                child: TextField(
                  controller: textEditingController,
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      dimensions.borderRadius,
                      0,
                      dimensions.borderRadius,
                      0,
                    ),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(dimensions.borderRadius)),
                  ),
                ),
              ),
              SizedBox(height: dimensions.borderRadius),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: dimensions.heightOfButton,
                        decoration: BoxDecoration(
                          color: colors.buttonColor,
                          borderRadius:
                              BorderRadius.circular(dimensions.borderRadius),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: fonts.fontSize2,
                            fontWeight: fonts.fontWeight2,
                            color: colors.buttonFontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        bloc.add(AddBatterEvent(textEditingController.text));

                        Navigator.pop(context);
                      },
                      child: Container(
                        height: dimensions.heightOfButton,
                        decoration: BoxDecoration(
                          color: colors.buttonColor,
                          borderRadius:
                              BorderRadius.circular(dimensions.borderRadius),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add Batter',
                          style: TextStyle(
                            fontSize: fonts.fontSize2,
                            fontWeight: fonts.fontWeight2,
                            color: colors.buttonFontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
              SizedBox(height: dimensions.borderRadius),
            ],
          ),
        );
      },
    );
  }
}

class SelectBowlerDialog extends StatelessWidget {
  const SelectBowlerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final homescreenBloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = homescreenBloc.getRepository().getColors();
    final dimensions = homescreenBloc.getRepository().getDimensions();
    final fonts = homescreenBloc.getRepository().getFonts();

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      bloc: homescreenBloc,
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
        } else if (state.runtimeType == BowlerNameListState) {
          final bowlerNameListState = state as BowlerNameListState;
          if (bowlerNameListState.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(bowlerNameListState.errorMessage!),
                duration:
                    homescreenBloc.getRepository().getTimers().snackBarTime1,
              ),
            );
          }
        }
      },
      buildWhen: (previous, current) {
        if (current.runtimeType == BowlerNameListState) {
          final bowlerNameListState = current as BowlerNameListState;
          if (bowlerNameListState.errorMessage == null) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        final bowlerNameListState = state as BowlerNameListState;

        List<Widget> existingBowlerNamesWidget = [];

        for (String bowlerName in bowlerNameListState.bowlerNames) {
          existingBowlerNamesWidget.add(GestureDetector(
            onTap: bowlerNameListState.disableButton
                ? null
                : () {
                    homescreenBloc.add(SelectFixedBowlerEvent(bowlerName,
                        bowlerNameListState.previousMatchPageState));
                  },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dimensions.borderRadius)),
              margin: EdgeInsets.fromLTRB(
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
                dimensions.borderRadius,
                dimensions.borderRadius / 2,
              ),
              child: Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  Container(
                    height: dimensions.heightOfButton,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bowlerName,
                      softWrap: true,
                      style: TextStyle(
                        color: bowlerNameListState.disableButton
                            ? colors.lightBackgroundFontColorDisabled1
                            : colors.lightBackgroundFontColor1,
                        fontSize: fonts.fontSize2,
                        fontWeight: fonts.fontWeight2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: colors.darkBackgroundColor1,
            centerTitle: true,
            title: Text(
              'Select Bowler for new over',
              style: TextStyle(
                color: colors.darkBackgroundFontColor1,
                fontSize: fonts.fontSize1,
                fontWeight: fonts.fontWeight1,
              ),
            ),
          ),
          backgroundColor: colors.lightBackgroundColor1,
          body: SingleChildScrollView(
            child: Column(
              children: existingBowlerNamesWidget +
                  <Widget>[
                    GestureDetector(
                      onTap: bowlerNameListState.disableButton
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => BlocProvider.value(
                                  value: homescreenBloc,
                                  child: const Dialog(
                                      child: BowlerNameAddDialog()),
                                ),
                              );
                            },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(dimensions.borderRadius)),
                        color: bowlerNameListState.disableButton
                            ? colors.disabledButtonColor
                            : colors.buttonColor,
                        margin: EdgeInsets.fromLTRB(
                          dimensions.borderRadius,
                          dimensions.borderRadius / 2,
                          dimensions.borderRadius,
                          dimensions.borderRadius / 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: dimensions.heightOfButton,
                                alignment: Alignment.center,
                                child: Text(
                                  'Add Bowler',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: bowlerNameListState.disableButton
                                        ? colors.disabledButtonFontColor
                                        : colors.buttonFontColor,
                                    fontSize: fonts.fontSize2,
                                    fontWeight: fonts.fontWeight2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
            ),
          ),
        );
      },
    );
  }
}

class BowlerNameAddDialog extends StatefulWidget {
  const BowlerNameAddDialog({super.key});

  @override
  State<BowlerNameAddDialog> createState() => _BowlerNameAddDialogState();
}

class _BowlerNameAddDialogState extends State<BowlerNameAddDialog> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();

    return BlocBuilder<HomescreenBloc, HomescreenState>(
      bloc: bloc,
      builder: (context, state) {
        final bowlerNameListState = state as BowlerNameListState;

        const widthOfDialog = 300.0;

        return Container(
          width: widthOfDialog,
          height: dimensions.heightOfButton * 3 + 4 * dimensions.borderRadius,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
          ),
          child: Column(
            children: [
              SizedBox(height: dimensions.borderRadius),
              Container(
                height: dimensions.heightOfButton,
                width: widthOfDialog,
                alignment: Alignment.center,
                child: Text(
                  'Enter new Bowler Name',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ),
              SizedBox(height: dimensions.borderRadius),
              Container(
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  0,
                  dimensions.borderRadius,
                  0,
                ),
                height: dimensions.heightOfButton,
                child: TextField(
                  controller: textEditingController,
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      dimensions.borderRadius,
                      0,
                      dimensions.borderRadius,
                      0,
                    ),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(dimensions.borderRadius)),
                  ),
                ),
              ),
              SizedBox(height: dimensions.borderRadius),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: dimensions.heightOfButton,
                        decoration: BoxDecoration(
                          color: colors.buttonColor,
                          borderRadius:
                              BorderRadius.circular(dimensions.borderRadius),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: fonts.fontSize2,
                            fontWeight: fonts.fontWeight2,
                            color: colors.buttonFontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        bloc.add(AddNewBowlerEvent(
                          textEditingController.text,
                          bowlerNameListState
                              .previousMatchPageState.innings1isInProgress,
                          bowlerNameListState.previousMatchPageState,
                        ));

                        Navigator.pop(context);
                      },
                      child: Container(
                        height: dimensions.heightOfButton,
                        decoration: BoxDecoration(
                          color: colors.buttonColor,
                          borderRadius:
                              BorderRadius.circular(dimensions.borderRadius),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add Bowler',
                          style: TextStyle(
                            fontSize: fonts.fontSize2,
                            fontWeight: fonts.fontWeight2,
                            color: colors.buttonFontColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
              SizedBox(height: dimensions.borderRadius),
            ],
          ),
        );
      },
    );
  }
}

class MatchPageNew extends StatelessWidget {
  const MatchPageNew({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listenWhen: (previous, current) {
        // previousMatchPageState = previous as MatchPageState;
        if (current.runtimeType == MatchPageState) {
          final matchPageState = current as MatchPageState;
          return matchPageState.snackBarMessage != null;
        } else if (current.runtimeType == BowlerNameListState) {
          return true;
        } else if (current.runtimeType == OpenAddNewBatterPageState) {
          return true;
        } else if (current.runtimeType == MatchCompletedPageState) {
          return true;
        } else if (current.runtimeType == ScoreCardDataState) {
          return true;
        } else if (current.runtimeType == UserPageState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        final homescreenBloc = BlocProvider.of<HomescreenBloc>(context);
        if (state.runtimeType == MatchPageState) {
          final matchPageState = state as MatchPageState;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(matchPageState.snackBarMessage ?? ''),
              duration:
                  homescreenBloc.getRepository().getTimers().snackBarTime1,
            ),
          );
        } else if (state.runtimeType == BowlerNameListState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const SelectBowlerDialog(),
              ),
            ),
          );
        } else if (state.runtimeType == MatchCompletedPageState) {
          // pop all pages
          Navigator.popUntil(context, (route) => route.isFirst);
          // push on replacement route, match completed page state
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: homescreenBloc,
                child: const MatchCompletedPage(),
              ),
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
                child: MyHomePage(
                  user: userPageState.user,
                ),
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.runtimeType == MatchPageState,
      builder: (context, state) {
        // final bloc = BlocProvider.of<HomescreenBloc>(context);
        final colors = bloc.getRepository().getColors();
        final matchPageState = state as MatchPageState;
        var teamNames = matchPageState.matchName.split('vs');
        var team1Name = teamNames.first;
        var team2Name = teamNames[1];

        final bool disableBackButton;
        if (state.runtimeType == MatchPageState) {
          final matchPageState = state;
          if (matchPageState.disableBackButton == true) {
            disableBackButton = true;
          } else {
            disableBackButton = false;
          }
        } else {
          disableBackButton = false;
        }

        return Scaffold(
          backgroundColor:
              bloc.getRepository().getColors().lightBackgroundColor1,
          body: Column(
            children: [
              MatchAppBarTitle(
                disableBackButton: disableBackButton,
                innings1inProgress: matchPageState.innings1isInProgress,
                maxOver: matchPageState.maxOvers,
                innings1name: team1Name,
                innings1score: matchPageState.innings1runs,
                innings1over: matchPageState.innings1overs,
                innings1ball: matchPageState.innings1balls,
                innings1wicket: matchPageState.innings1wickets,
                innings2name: team2Name,
                innings2score: matchPageState.innings2runs,
                innings2over: matchPageState.innings2overs,
                innings2ball: matchPageState.innings2balls,
                innings2wicket: matchPageState.innings2wickets,
                disableButton: matchPageState.disableButton,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    BatterCard(
                      pathOfImage: 'assets/bat-nnn.png',
                      matchPageState: matchPageState,
                    ),
                    BowlerCard(
                      pathOfImage: 'assets/ball-n.png',
                      currentBowler: matchPageState.currentBowler,
                      thisOverStats: matchPageState.thisOverStats,
                      innings1inProgress: matchPageState.innings1isInProgress,
                      innings1ball: matchPageState.innings1balls,
                      innings2ball: matchPageState.innings2balls,
                      matchPageState: matchPageState,
                    ),
                    ScoringCard(
                      matchPageState: matchPageState,
                    ),
                    InningsEndCard(matchPageState: matchPageState),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MatchAppBarTitle extends StatelessWidget {
  final bool disableBackButton;
  final bool disableButton;
  final bool innings1inProgress;
  final int maxOver;

  final String innings1name;
  final int innings1score;
  final int innings1wicket;
  final int innings1over;
  final int innings1ball;

  final String innings2name;
  final int innings2score;
  final int innings2wicket;
  final int innings2over;
  final int innings2ball;

  const MatchAppBarTitle({
    super.key,
    required this.disableBackButton,
    required this.disableButton,
    required this.innings1inProgress,
    required this.maxOver,
    required this.innings1name,
    required this.innings1score,
    required this.innings1wicket,
    required this.innings1over,
    required this.innings1ball,
    required this.innings2name,
    required this.innings2score,
    required this.innings2wicket,
    required this.innings2over,
    required this.innings2ball,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();

    const double heightOfStatsBox = 80;
    const double borderRadius = 20;
    const double minimumWidthOfStatsBox = 100;
    const double sizeOfBackButton = 30;

    final flex1 = Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        height: heightOfStatsBox,
        constraints: const BoxConstraints(minWidth: minimumWidthOfStatsBox),
        decoration: BoxDecoration(
          color: innings1inProgress
              ? colors.lightBackgroundColor1
              : colors.darkBackgroundColor2,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(borderRadius),
            bottomLeft: const Radius.circular(borderRadius),
            topRight: innings1inProgress
                ? const Radius.circular(borderRadius)
                : Radius.zero,
            bottomRight: innings1inProgress
                ? const Radius.circular(borderRadius)
                : Radius.zero,
          ),
        ),
        child: Column(
          children: [
            Text(
              innings1name,
              style: TextStyle(
                color: innings1inProgress
                    ? colors.lightBackgroundFontColor1
                    : colors.darkBackgroundFontColor2,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              '$innings1score/$innings1wicket ($innings1over.$innings1ball/$maxOver)',
              style: TextStyle(
                color: innings1inProgress
                    ? colors.lightBackgroundFontColor1
                    : colors.darkBackgroundFontColor2,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );

    final flex2 = Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        height: heightOfStatsBox,
        constraints: const BoxConstraints(minWidth: minimumWidthOfStatsBox),
        decoration: BoxDecoration(
          color: !innings1inProgress
              ? colors.lightBackgroundColor1
              : colors.darkBackgroundColor2,
          borderRadius: BorderRadius.only(
            topLeft: !innings1inProgress
                ? const Radius.circular(borderRadius)
                : Radius.zero,
            bottomLeft: !innings1inProgress
                ? const Radius.circular(borderRadius)
                : Radius.zero,
            topRight: const Radius.circular(borderRadius),
            bottomRight: const Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          children: [
            Text(
              innings2name,
              style: TextStyle(
                color: !innings1inProgress
                    ? colors.lightBackgroundFontColor1
                    : colors.darkBackgroundFontColor2,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              innings1inProgress
                  ? 'Yet to bat'
                  : '$innings2score/$innings2wicket ($innings2over.$innings2ball/$maxOver)',
              style: TextStyle(
                color: !innings1inProgress
                    ? colors.lightBackgroundFontColor1
                    : colors.darkBackgroundFontColor2,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );

    final backButton = SizedBox(
      width: sizeOfBackButton,
      height: sizeOfBackButton,
      child: disableBackButton || disableButton
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: colors.darkBackgroundFontColor1,
              onPressed: () {
                bloc.add(OpenUserPageFromMatchPageEvent());
              },
            ),
    );

    const rightMostSpace = SizedBox(width: sizeOfBackButton);

    return Container(
      color: colors.darkBackgroundColor1,
      height: heightOfStatsBox + 20,
      child: Row(
        children: [
          backButton,
          Expanded(
            child: Container(
              height: heightOfStatsBox,
              decoration: BoxDecoration(
                color: colors.darkBackgroundColor2,
                borderRadius: BorderRadius.circular(borderRadius),
                shape: BoxShape.rectangle,
              ),
              child: Row(children: [flex1, flex2]),
            ),
          ),
          rightMostSpace,
        ],
      ),
    );
  }
}

class BatterCard extends StatelessWidget {
  final String pathOfImage;
  final MatchPageState matchPageState;

  const BatterCard({
    super.key,
    required this.pathOfImage,
    required this.matchPageState,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();
    final Widget changeStrikeWidget;

    if (matchPageState.batter1Name != null &&
        matchPageState.batter2Name != null) {
      changeStrikeWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          color: matchPageState.disableButton
              ? colors.disabledButtonColor
              : colors.buttonColor,
        ),
        width: 2 * dimensions.borderRadius,
        height: 2 * dimensions.borderRadius,
        alignment: Alignment.center,
        child: IconButton(
          alignment: Alignment.center,
          color: matchPageState.disableButton
              ? colors.disabledButtonColor
              : colors.buttonFontColor,
          onPressed: matchPageState.disableButton
              ? null
              : () {
                  bloc.add(ChangeStrikeEvent());
                },
          icon: const Icon(Icons.swap_vert),
        ),
      );
    } else {
      changeStrikeWidget = SizedBox(width: 2 * dimensions.borderRadius);
    }

    final addBatterButton = Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: matchPageState.disableButton
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: const Dialog(child: AddNewBatterDialog()),
                      ),
                    );
                  },
            child: Container(
              height: dimensions.heightOfButton,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: matchPageState.disableButton
                      ? colors.disabledButtonColor
                      : colors.buttonColor,
                  borderRadius: BorderRadius.circular(dimensions.borderRadius)),
              child: Text(
                'Add new batter',
                style: TextStyle(
                  color: matchPageState.disableButton
                      ? colors.disabledButtonFontColor
                      : colors.buttonFontColor,
                  fontSize: fonts.fontSize2,
                  fontWeight: fonts.fontWeight2,
                ),
              ),
            ),
            // ),
          ),
        ),
      ],
      // ),
    );
    final batter1score = matchPageState.batter1Name != null
        ? Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${matchPageState.batter1Name!}\n(STRIKER)',
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${matchPageState.batter1run}(${matchPageState.batter1ball})',
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
    final batter2score = matchPageState.batter2Name != null
        ? Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '${matchPageState.batter2Name!}\n(RUNNER)',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${matchPageState.batter2run}(${matchPageState.batter2ball})',
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: fonts.fontSize4,
                      fontWeight: fonts.fontWeight4,
                      fontFamily: fonts.fontFamily4,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();

    final List<Widget> lastColumnWidgets = [];

    lastColumnWidgets.add(SizedBox(height: dimensions.borderRadius));
    if (matchPageState.batter1Name == null) {
      lastColumnWidgets.add(Expanded(child: addBatterButton));
    } else {
      lastColumnWidgets.add(Expanded(child: batter1score));

      if (matchPageState.batter2Name == null) {
        lastColumnWidgets.add(Expanded(child: addBatterButton));
      } else {
        lastColumnWidgets.add(Expanded(child: batter2score));
      }
    }
    lastColumnWidgets.add(SizedBox(height: dimensions.borderRadius));

    return Card(
      margin: EdgeInsets.fromLTRB(
        dimensions.horizontalMargin,
        dimensions.verticalMargin,
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: dimensions.borderRadius),
          SizedBox(
            width: dimensions.widthOfBatterIcon,
            height: 2.5 * dimensions.heightOfButton,
            child: Image.asset(pathOfImage),
          ),
          changeStrikeWidget,
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 2 * dimensions.heightOfButton +
                  2 * dimensions.borderRadius +
                  20,
              child: Column(
                children: lastColumnWidgets,
              ),
            ),
          ),
          SizedBox(width: dimensions.borderRadius),
        ],
      ),
    );
  }
}

class BowlerCard extends StatelessWidget {
  final String pathOfImage;
  final bool innings1inProgress;
  final int innings1ball;
  final int innings2ball;
  final String? currentBowler;
  final List<String> thisOverStats;
  final MatchPageState matchPageState;

  const BowlerCard({
    super.key,
    required this.pathOfImage,
    required this.currentBowler,
    required this.thisOverStats,
    required this.innings1inProgress,
    required this.innings1ball,
    required this.innings2ball,
    required this.matchPageState,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();
    final int ballsOfThisOver =
        innings1inProgress ? innings1ball : innings2ball;
    List<Widget> columnWidgets = [];

    String thisOverStatsAsString = '';
    for (String thisBall in thisOverStats) {
      thisOverStatsAsString = '$thisOverStatsAsString$thisBall  ';
    }

    if (currentBowler != null) {
      columnWidgets.add(
        Container(
          alignment: Alignment.centerLeft,
          constraints:
              BoxConstraints(minHeight: dimensions.heightOfButton * 1.5),
          child: Text(
            '${currentBowler!}\n$thisOverStatsAsString',
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: fonts.fontSize4,
              fontWeight: fonts.fontWeight4,
              fontFamily: fonts.fontFamily4,
            ),
          ),
        ),
      );
    }

    if (ballsOfThisOver == 0 || currentBowler == null) {
      columnWidgets.add(
        Container(
          height: dimensions.heightOfButton * 1.5,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: dimensions.heightOfButton,
                  decoration: BoxDecoration(
                    color: matchPageState.disableButton
                        ? colors.disabledButtonColor
                        : colors.buttonColor,
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius),
                  ),
                  child: OutlinedButton(
                    onPressed: matchPageState.disableButton
                        ? null
                        : () {
                            bloc.add(
                              SelectNewBowlerEvent(
                                  innings1inProgress, matchPageState),
                            );
                          },
                    child: Text(
                      'Select Bowler',
                      style: TextStyle(
                        color: matchPageState.disableButton
                            ? colors.disabledButtonFontColor
                            : colors.buttonFontColor,
                        fontSize: fonts.fontSize2,
                        fontWeight: fonts.fontWeight2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.fromLTRB(
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Row(
        children: [
          SizedBox(width: dimensions.borderRadius * 1.50),
          SizedBox(
            width: dimensions.widthOfBatterIcon * 0.75,
            height: dimensions.heightOfButton,
            child: Image.asset(pathOfImage),
          ),
          SizedBox(width: 2 * dimensions.borderRadius),
          const SizedBox(width: 10),
          Expanded(child: Column(children: columnWidgets)),
          SizedBox(width: dimensions.borderRadius),
        ],
      ),
    );
  }
}

class ScoringCard extends StatelessWidget {
  final MatchPageState matchPageState;

  const ScoringCard({
    super.key,
    required this.matchPageState,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();
    final buttonColorSelected = colors.accentColor;
    final buttonColorUnselected = colors.lightBackgroundColor1;
    final buttonColorDisabled = colors.disabledButtonColor;
    const double spaceBetweenRow = 10;
    final bool scoringButtonIsDisabled;
    final bool updateScoreButtonIsDisabled;
    List<Widget> runOutColumnElement = [];
    List<Widget> batterRunOutWidgets = [];

    //scoring button is disabled logic
    scoringButtonIsDisabled = matchPageState.currentBowler == null ||
        matchPageState.batterOnStrikeName == null ||
        matchPageState.disableButton;

    // log.e('SCORING BUTTON IS DISABLED : $scoringButtonIsDisabled');
    // log.e('CURRENT BOWLER : ${matchPageState.currentBowler}');
    // log.e('BATTER ON STRIKE : ${matchPageState.batterOnStrikeName}');

    //batter run out widget
    if (matchPageState.batter1Name != null) {
      runOutColumnElement.add(const SizedBox(height: spaceBetweenRow));

      final firstName = matchPageState.batter1Name!.split(' ').first;

      batterRunOutWidgets.add(SizedBox(width: dimensions.borderRadius));
      batterRunOutWidgets.add(const Expanded(child: SizedBox(height: 10)));
      batterRunOutWidgets.add(
        ButtonScoring(
          voidFunction: () {
            bloc.add(OutRunBatter1Event());
          },
          buttonColorUnselected: buttonColorUnselected,
          buttonColorSelected: buttonColorSelected,
          buttonColorDisabled: buttonColorDisabled,
          buttonIsDisabled: scoringButtonIsDisabled,
          buttonIsSelected: matchPageState.runOutBatter1,
          height: dimensions.heightOfButton + 10,
          borderRadius: dimensions.borderRadius,
          buttonText: '$firstName\nRun Out',
          fontSize: fonts.fontSize2,
        ),
      );
      batterRunOutWidgets.add(const Expanded(child: SizedBox(height: 10)));
    }
    if (matchPageState.batter2Name != null) {
      final firstName = matchPageState.batter2Name!.split(' ').first;
      if (runOutColumnElement.isEmpty) {
        runOutColumnElement.add(const SizedBox(height: spaceBetweenRow));
        batterRunOutWidgets.add(SizedBox(width: dimensions.borderRadius));
        batterRunOutWidgets.add(const Expanded(child: SizedBox(height: 10)));
      }
      batterRunOutWidgets.add(
        ButtonScoring(
          voidFunction: () {
            bloc.add(OutRunBatter2Event());
          },
          buttonColorUnselected: buttonColorUnselected,
          buttonColorSelected: buttonColorSelected,
          buttonColorDisabled: buttonColorDisabled,
          buttonIsDisabled: scoringButtonIsDisabled,
          buttonIsSelected: matchPageState.runOutBatter2,
          height: dimensions.heightOfButton + 10,
          borderRadius: dimensions.borderRadius,
          buttonText: '$firstName\nRun Out',
          fontSize: fonts.fontSize2,
        ),
      );
      batterRunOutWidgets.add(const Expanded(child: SizedBox(height: 10)));
    }
    if (runOutColumnElement.isNotEmpty) {
      batterRunOutWidgets.add(SizedBox(width: dimensions.borderRadius));
      runOutColumnElement.add(Row(children: batterRunOutWidgets));
    }

    if (matchPageState.currentBowler == null ||
        matchPageState.batterOnStrikeName == null) {
      updateScoreButtonIsDisabled = true;
    } else if (matchPageState.innings1isInProgress) {
      if (matchPageState.innings1overs == matchPageState.maxOvers &&
          matchPageState.innings1balls == 0) {
        updateScoreButtonIsDisabled = true;
      } else {
        updateScoreButtonIsDisabled = false;
      }
    } else if (!matchPageState.innings1isInProgress) {
      if (matchPageState.innings2overs == matchPageState.maxOvers &&
          matchPageState.innings2balls == 0) {
        updateScoreButtonIsDisabled = true;
      } else {
        updateScoreButtonIsDisabled = false;
      }
    } else if (matchPageState.batter1Name == null &&
        matchPageState.batter2Name == null) {
      updateScoreButtonIsDisabled = true;
    } else {
      updateScoreButtonIsDisabled = false;
    }

    return Card(
      margin: EdgeInsets.fromLTRB(
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Column(
        children: <Widget>[
              SizedBox(height: dimensions.borderRadius),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  const Expanded(child: SizedBox(height: 10)),
                  ButtonScoring(
                    voidFunction: () {
                      bloc.add(OutBowledEvent());
                    },
                    buttonColorUnselected: buttonColorUnselected,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.bowled,
                    height: dimensions.heightOfButton,
                    borderRadius: dimensions.borderRadius,
                    buttonText: 'Bowled Out',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  ButtonScoring(
                    voidFunction: () {
                      bloc.add(OutCatchEvent());
                    },
                    buttonColorUnselected: buttonColorUnselected,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.catchOut,
                    height: dimensions.heightOfButton,
                    borderRadius: dimensions.borderRadius,
                    buttonText: 'Catch Out',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
            ] +
            runOutColumnElement +
            <Widget>[
              const SizedBox(height: spaceBetweenRow / 2),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: Container(
                        height: 1, color: colors.darkBackgroundColor1),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
              const SizedBox(height: spaceBetweenRow / 2),
              Row(
                children: [
                  const Expanded(child: SizedBox(height: 10)),
                  ButtonScoring(
                    voidFunction: () {
                      bloc.add(NoBallEvent());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.noBall,
                    height: dimensions.heightOfButton,
                    borderRadius: dimensions.borderRadius,
                    buttonText: 'No ball',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  ButtonScoring(
                    voidFunction: () {
                      bloc.add(WideBallEvent());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.wideBall,
                    height: dimensions.heightOfButton,
                    borderRadius: dimensions.borderRadius,
                    buttonText: 'Wide ball',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                ],
              ),
              const SizedBox(height: spaceBetweenRow),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run0Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.zero,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '0',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run1Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.one,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '1',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run2Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.two,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '2',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run3Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.three,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '3',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run4Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.four,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '4',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run5Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.five,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '5',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  RunScoring(
                    voidFunction: () {
                      bloc.add(Run6Event());
                    },
                    buttonColorUnselected: colors.lightBackgroundColor1,
                    buttonColorSelected: buttonColorSelected,
                    buttonColorDisabled: buttonColorDisabled,
                    buttonIsDisabled: scoringButtonIsDisabled,
                    buttonIsSelected: matchPageState.six,
                    height: dimensions.borderRadius * 2,
                    width: dimensions.borderRadius * 2,
                    borderRadius: dimensions.borderRadius,
                    buttonText: '6',
                    fontSize: fonts.fontSize2,
                  ),
                  const Expanded(child: SizedBox(height: 10)),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
              const SizedBox(height: spaceBetweenRow),
              Row(
                children: [
                  SizedBox(width: dimensions.borderRadius),
                  Expanded(
                    child: UpdateScoreButtonWidget(
                      buttonIsDisabled: updateScoreButtonIsDisabled ||
                          matchPageState.disableButton,
                      voidFunction: () {
                        bloc.add(UpdateScoreEvent());
                      },
                      height: dimensions.heightOfButton,
                      borderRadius: dimensions.borderRadius,
                      buttonText: 'Update Score',
                      fontSize: fonts.fontSize2,
                    ),
                  ),
                  SizedBox(width: dimensions.borderRadius),
                ],
              ),
              SizedBox(height: dimensions.borderRadius),
            ],
      ),
    );
  }
}

class ButtonScoring extends StatelessWidget {
  final Color buttonColorUnselected;
  final Color buttonColorSelected;
  final Color buttonColorDisabled;
  final bool buttonIsDisabled;
  final bool buttonIsSelected;
  final Function voidFunction;
  final double height;
  final double borderRadius;
  final String buttonText;
  final double fontSize;
  const ButtonScoring({
    super.key,
    required this.voidFunction,
    required this.buttonColorUnselected,
    required this.buttonColorSelected,
    required this.buttonColorDisabled,
    required this.buttonIsDisabled,
    required this.buttonIsSelected,
    required this.height,
    required this.borderRadius,
    required this.buttonText,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();

    final buttonUnselected = GestureDetector(
      onTap: () {
        Function.apply(voidFunction, [], {});
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(borderRadius, 0, borderRadius, 0),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );

    final buttonDisabled = GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(borderRadius, 0, borderRadius, 0),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.lightBackgroundFontColorDisabled1,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
      // ),
    );
    final buttonSelected = GestureDetector(
      onTap: () {
        Function.apply(voidFunction, [], {});
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColorSelected,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(borderRadius, 0, borderRadius, 0),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
      // ),
    );

    return SizedBox(
      height: height,
      child: buttonIsDisabled
          ? buttonDisabled
          : buttonIsSelected
              ? buttonSelected
              : buttonUnselected,
    );
  }
}

class RunScoring extends StatelessWidget {
  final Color buttonColorUnselected;
  final Color buttonColorSelected;
  final Color buttonColorDisabled;
  final bool buttonIsDisabled;
  final bool buttonIsSelected;
  final Function voidFunction;
  final double height;
  final double width;
  final double borderRadius;
  final String buttonText;
  final double fontSize;
  const RunScoring({
    super.key,
    required this.voidFunction,
    required this.buttonColorUnselected,
    required this.buttonColorSelected,
    required this.buttonColorDisabled,
    required this.buttonIsDisabled,
    required this.buttonIsSelected,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.buttonText,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();

    final buttonUnselected = GestureDetector(
      onTap: () {
        Function.apply(voidFunction, [], {});
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );

    final buttonDisabled = GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.lightBackgroundFontColorDisabled1,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
      // ),
    );

    final buttonSelected = GestureDetector(
      onTap: () {
        Function.apply(voidFunction, [], {});
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColorSelected,
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );

    return SizedBox(
      height: height,
      width: width,
      child: buttonIsDisabled
          ? buttonDisabled
          : buttonIsSelected
              ? buttonSelected
              : buttonUnselected,
    );
  }
}

class UpdateScoreButtonWidget extends StatelessWidget {
  final bool buttonIsDisabled;
  final Function voidFunction;
  final double height;
  final double borderRadius;
  final String buttonText;
  final double fontSize;

  const UpdateScoreButtonWidget({
    super.key,
    required this.buttonIsDisabled,
    required this.voidFunction,
    required this.height,
    required this.borderRadius,
    required this.buttonText,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();

    final buttonUnselected = GestureDetector(
      onTap: () {
        Function.apply(voidFunction, [], {});
      },
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: colors.buttonColor,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(borderRadius, 0, borderRadius, 0),
          child: Text(
            buttonText,
            style: TextStyle(
              color: colors.buttonFontColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    final buttonDisabled = Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.disabledButtonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.disabledButtonBorderColor),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(borderRadius, 0, borderRadius, 0),
        child: Text(
          buttonText,
          style: TextStyle(
            color: colors.disabledButtonFontColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return buttonIsDisabled ? buttonDisabled : buttonUnselected;
  }
}

class InningsEndCard extends StatelessWidget {
  final MatchPageState matchPageState;
  const InningsEndCard({
    super.key,
    required this.matchPageState,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();

    final showScorecardButton = Row(
      children: [
        SizedBox(width: dimensions.borderRadius),
        Expanded(
          child: GestureDetector(
            onTap: matchPageState.disableButton
                ? null
                : () {
                    bloc.add(ShowScoreCardEvent(
                      matchPageState.user,
                      matchPageState.matchId,
                    ));
                  },
            child: Container(
              alignment: Alignment.center,
              height: dimensions.heightOfButton,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimensions.borderRadius),
                color: matchPageState.disableButton
                    ? colors.disabledButtonColor
                    : colors.buttonColor,
              ),
              child: Text(
                'Show Scorecard',
                style: TextStyle(
                  color: matchPageState.disableButton
                      ? colors.disabledButtonFontColor
                      : colors.buttonFontColor,
                  fontSize: fonts.fontSize2,
                  fontWeight: fonts.fontWeight2,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: dimensions.borderRadius),
      ],
    );

    final endInningsAndAbandonMatchWidget = Row(
      children: [
        SizedBox(width: dimensions.borderRadius),
        Expanded(
          child: GestureDetector(
            onTap: matchPageState.disableButton
                ? null
                : () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: Dialog(
                            child: EndInningsDialog(
                                matchPageState.innings1isInProgress)),
                      ),
                    );
                  },
            child: Container(
              alignment: Alignment.center,
              height: dimensions.heightOfButton,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimensions.borderRadius),
                color: matchPageState.disableButton
                    ? colors.disabledButtonColor
                    : colors.buttonColor,
              ),
              child: Text(
                'End Innings',
                style: TextStyle(
                  color: matchPageState.disableButton
                      ? colors.disabledButtonFontColor
                      : colors.buttonFontColor,
                  fontSize: fonts.fontSize2,
                  fontWeight: fonts.fontWeight2,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: dimensions.borderRadius),
        Expanded(
          child: GestureDetector(
            onTap: matchPageState.disableButton
                ? null
                : () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: const Dialog(child: AbandonMatchDialog()),
                      ),
                    );
                  },
            child: Container(
              alignment: Alignment.center,
              height: dimensions.heightOfButton,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimensions.borderRadius),
                color: matchPageState.disableButton
                    ? colors.disabledButtonColor
                    : colors.buttonColor,
              ),
              child: Text(
                'Abandon Match',
                style: TextStyle(
                  color: matchPageState.disableButton
                      ? colors.disabledButtonFontColor
                      : colors.buttonFontColor,
                  fontSize: fonts.fontSize2,
                  fontWeight: fonts.fontWeight2,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: dimensions.borderRadius),
      ],
    );

    return Card(
      margin: EdgeInsets.fromLTRB(
        dimensions.horizontalMargin,
        dimensions.verticalMargin / 2,
        dimensions.horizontalMargin,
        dimensions.verticalMargin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: dimensions.borderRadius),
          showScorecardButton,
          const SizedBox(height: 10),
          endInningsAndAbandonMatchWidget,
          SizedBox(height: dimensions.borderRadius),
        ],
      ),
    );
  }
}

class EndInningsDialog extends StatelessWidget {
  final bool innings1inProgress;
  const EndInningsDialog(this.innings1inProgress, {super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final dimensions = bloc.getRepository().getDimensions();
    final colors = bloc.getRepository().getColors();
    final fonts = bloc.getRepository().getFonts();

    return Container(
      width: dimensions.dialogBoxWidth,
      height: 3 * dimensions.heightOfButton + 2 * dimensions.borderRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Row(children: [
        SizedBox(width: dimensions.borderRadius),
        Column(children: [
          SizedBox(height: dimensions.borderRadius),
          Text(
            'End innings ${innings1inProgress ? 1 : 2}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.lightBackgroundFontColor1,
              fontSize: fonts.fontSize1,
              fontWeight: fonts.fontWeight1,
            ),
          ),
          SizedBox(height: dimensions.borderRadius / 2),
          Text(
            'Are you sure?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.lightBackgroundFontColor1,
              fontSize: fonts.fontSize2,
              fontWeight: fonts.fontWeight2,
            ),
          ),
          SizedBox(height: dimensions.borderRadius / 2),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: dimensions.heightOfButton,
                  width: (dimensions.dialogBoxWidth -
                          3 * dimensions.borderRadius) /
                      2,
                  decoration: BoxDecoration(
                    color: colors.buttonColor,
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: fonts.fontSize2,
                      fontWeight: fonts.fontWeight2,
                      color: colors.buttonFontColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: dimensions.borderRadius),
              GestureDetector(
                onTap: () {
                  if (innings1inProgress) {
                    bloc.add(EndInningsEvent(true));
                  } else {
                    bloc.add(EndInningsEvent(false));
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: dimensions.heightOfButton,
                  width: (dimensions.dialogBoxWidth -
                          3 * dimensions.borderRadius) /
                      2,
                  decoration: BoxDecoration(
                    color: colors.buttonColor,
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'End innings',
                    style: TextStyle(
                      fontSize: fonts.fontSize2,
                      fontWeight: fonts.fontWeight2,
                      color: colors.buttonFontColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: dimensions.borderRadius),
        ]),
        SizedBox(width: dimensions.borderRadius),
      ]),
    );
  }
}

class AbandonMatchDialog extends StatelessWidget {
  const AbandonMatchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final dimensions = bloc.getRepository().getDimensions();
    final colors = bloc.getRepository().getColors();
    final fonts = bloc.getRepository().getFonts();

    return Container(
      width: dimensions.dialogBoxWidth,
      height: 3 * dimensions.heightOfButton + 2 * dimensions.borderRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Row(children: [
        SizedBox(width: dimensions.borderRadius),
        Column(children: [
          SizedBox(height: dimensions.borderRadius),
          Text(
            'Abandon Match',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.lightBackgroundFontColor1,
              fontSize: fonts.fontSize1,
              fontWeight: fonts.fontWeight1,
            ),
          ),
          SizedBox(height: dimensions.borderRadius / 2),
          Text(
            'Are you sure?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.lightBackgroundFontColor1,
              fontSize: fonts.fontSize2,
              fontWeight: fonts.fontWeight2,
            ),
          ),
          SizedBox(height: dimensions.borderRadius / 2),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: dimensions.heightOfButton,
                  width: (dimensions.dialogBoxWidth -
                          3 * dimensions.borderRadius) /
                      2,
                  decoration: BoxDecoration(
                    color: colors.buttonColor,
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: fonts.fontSize2,
                      fontWeight: fonts.fontWeight2,
                      color: colors.buttonFontColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: dimensions.borderRadius),
              GestureDetector(
                onTap: () {
                  bloc.add(MatchAbandonedEvent());
                  Navigator.pop(context);
                },
                child: Container(
                  height: dimensions.heightOfButton,
                  width: (dimensions.dialogBoxWidth -
                          3 * dimensions.borderRadius) /
                      2,
                  decoration: BoxDecoration(
                    color: colors.buttonColor,
                    borderRadius:
                        BorderRadius.circular(dimensions.borderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'End innings',
                    style: TextStyle(
                      fontSize: fonts.fontSize2,
                      fontWeight: fonts.fontWeight2,
                      color: colors.buttonFontColor,
                    ),
                  ),
                ),
              ),
              // ),
            ],
          ),
          SizedBox(height: dimensions.borderRadius),
        ]),
        SizedBox(width: dimensions.borderRadius),
      ]),
    );
  }
}
