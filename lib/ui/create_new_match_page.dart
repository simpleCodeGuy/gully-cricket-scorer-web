import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/match_page.dart';

class CreateNewMatchDialog extends StatefulWidget {
  const CreateNewMatchDialog({super.key});

  @override
  State<CreateNewMatchDialog> createState() => _CreateNewMatchDialogState();
}

class _CreateNewMatchDialogState extends State<CreateNewMatchDialog> {
  late final TextEditingController maxOversController;
  late final TextEditingController innings1nameController;
  late final TextEditingController innings2nameController;

  @override
  void initState() {
    innings1nameController = TextEditingController();
    innings2nameController = TextEditingController();
    maxOversController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    innings1nameController.dispose();
    innings2nameController.dispose();
    maxOversController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final dimensions = bloc.getRepository().getDimensions();
    final fonts = bloc.getRepository().getFonts();

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      bloc: bloc,
      listenWhen: (previous, current) => current.runtimeType == MatchPageState,
      listener: (context, state) {
        Navigator.popUntil(context, (route) => route.isFirst);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: bloc,
              child: const MatchPageNew(),
            ),
          ),
        );
      },
      buildWhen: (previous, current) => current.runtimeType == UserPageState,
      builder: (context, state) {
        final userPageState = state as UserPageState;

        final timers = bloc.getRepository().getTimers();

        const widthOfDialog = 300.0;

        return Container(
          width: widthOfDialog,
          height: dimensions.heightOfButton * 7 + 3 * dimensions.borderRadius,
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
                  'Enter name of team batting first',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  0,
                  dimensions.borderRadius,
                  0,
                ),
                height: dimensions.heightOfButton,
                child: TextField(
                  controller: innings1nameController,
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Team Batting First',
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
              Container(
                height: dimensions.heightOfButton,
                width: widthOfDialog,
                alignment: Alignment.center,
                child: Text(
                  'Enter name of team batting second',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  0,
                  dimensions.borderRadius,
                  0,
                ),
                height: dimensions.heightOfButton,
                child: TextField(
                  controller: innings2nameController,
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Team batting second',
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
              Container(
                height: dimensions.heightOfButton,
                width: widthOfDialog,
                alignment: Alignment.center,
                child: Text(
                  'Enter max overs',
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  dimensions.borderRadius,
                  0,
                  dimensions.borderRadius,
                  0,
                ),
                height: dimensions.heightOfButton,
                child: TextField(
                  controller: maxOversController,
                  style: TextStyle(
                    fontSize: fonts.fontSize2,
                    fontWeight: fonts.fontWeight2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Maximum overs of match',
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
                        try {
                          int maxOvers = int.parse(maxOversController.text);

                          if (innings1nameController.text == '') {
                            throw Exception('1');
                          }
                          if (innings1nameController.text == '') {
                            throw Exception('2');
                          }

                          bloc.add(CreateNewMatchEvent(
                            userPageState.user,
                            innings1nameController.text,
                            innings2nameController.text,
                            maxOvers,
                          ));
                          Navigator.pop(context);
                        } catch (e) {
                          if (e.toString() == '1') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Team batting first name should not be empty'),
                                duration: timers.snackBarTime1,
                              ),
                            );
                          } else if (e.toString() == '2') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Team batting first name should not be empty'),
                                duration: timers.snackBarTime1,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Maximum number of overs are not in integer format'),
                                duration: timers.snackBarTime1,
                              ),
                            );
                          }
                        }
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
                          'Add match',
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
