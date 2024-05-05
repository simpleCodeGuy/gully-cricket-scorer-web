import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/enter_otp_page.dart';
import 'package:gully_cricket_scorer/ui/home_page.dart';

class PhoneLoginPage extends StatefulWidget {
  final bool appStartedForFirstTime;
  const PhoneLoginPage({
    super.key,
    this.appStartedForFirstTime = false,
  });

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  late bool _appStartedForFirstTime;
  late final TextEditingController phoneNumberController;

  @override
  void initState() {
    _appStartedForFirstTime = widget.appStartedForFirstTime;
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();

    if (_appStartedForFirstTime) {
      log.i('1 _appStartedForFirstTime: $_appStartedForFirstTime');
      _appStartedForFirstTime = false;
      bloc.add(AppStartedForFirstTimeEvent());
    }

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listener: (context, state) {
        if (state.runtimeType == UserPageState) {
          final userPageState = state as UserPageState;

          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: MyHomePage(user: userPageState.user),
              ),
            ),
          );
        } else if (state.runtimeType == WaitingForOtpPageState) {
          final waitingForOtpPageState = state as WaitingForOtpPageState;
          if (waitingForOtpPageState.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(waitingForOtpPageState.errorMessage!),
                duration: bloc.getRepository().getTimers().snackBarTime1,
              ),
            );
          } else if (waitingForOtpPageState.confirmationResult != null) {
            Navigator.popUntil(context, (route) => route.isFirst);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: bloc,
                  child: EnterOtpPage(
                    phoneNumber: '+91${phoneNumberController.text}',
                  ),
                ),
              ),
            );
          }
        }
      },
      buildWhen: (previous, current) {
        if (current.runtimeType == WaitingForOtpPageState) {
          final waitingForOtpPageState = current as WaitingForOtpPageState;
          return waitingForOtpPageState.confirmationResult == null;
        }
        return false;
      },

      builder: (context, state) {
        log.i('2 _appStartedForFirstTime: $_appStartedForFirstTime');
        bool disableGetOtpButton = false;

        if (state.runtimeType == WaitingForOtpPageState) {
          final waitingForOtpPageState = state as WaitingForOtpPageState;
          disableGetOtpButton = waitingForOtpPageState.disableButton;
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Gully Cricket Scorer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.darkBackgroundFontColor1,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: colors.darkBackgroundColor1,
          ),
          backgroundColor: colors.lightBackgroundColor1,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Sign-in using mobile number and OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.lightBackgroundFontColor1,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter phone number    ',
                          prefixText: '+91 - ',
                          suffixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 280,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: disableGetOtpButton
                              ? MaterialStatePropertyAll(
                                  colors.disabledButtonColor)
                              : MaterialStatePropertyAll(colors.buttonColor),
                          foregroundColor: disableGetOtpButton
                              ? MaterialStatePropertyAll(
                                  colors.disabledButtonFontColor)
                              : MaterialStatePropertyAll(
                                  colors.buttonFontColor),
                        ),
                        onPressed: disableGetOtpButton
                            ? null
                            : () {
                                // log.i('Phone Sign-in button pressed');
                                final phoneNumber = phoneNumberController.text;
                                bool textIsInPhoneNumberFormat = true;
                                if (phoneNumber.length != 10) {
                                  textIsInPhoneNumberFormat = false;
                                }

                                final characters = phoneNumber.runes
                                    .toList()
                                    .map((e) => String.fromCharCode(e));

                                for (var ch in characters) {
                                  if (!(ch.contains(RegExp(r'[0-9]')))) {
                                    textIsInPhoneNumberFormat = false;
                                    break;
                                  }
                                }

                                if (textIsInPhoneNumberFormat) {
                                  bloc.add(
                                      SendOtpToUserEvent('+91$phoneNumber'));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'phone number should be 10 in length, and all numbers'),
                                      duration: bloc
                                          .getRepository()
                                          .getTimers()
                                          .snackBarTime1,
                                    ),
                                  );
                                }
                              },
                        child: Text(
                          'Get OTP',
                          style: TextStyle(
                            fontWeight:
                                bloc.getRepository().getFonts().fontWeight2,
                            fontSize: bloc.getRepository().getFonts().fontSize2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 220,
                    height: 220,
                    child: Image(
                      image: AssetImage('assets/bat-ball.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ),
        );
      },
      // ),
    );
  }
}
