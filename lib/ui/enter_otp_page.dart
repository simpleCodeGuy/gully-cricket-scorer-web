import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gully_cricket_scorer/bloc/homescreen_bloc.dart';
import 'package:gully_cricket_scorer/data/logging.dart';
import 'package:gully_cricket_scorer/ui/home_page.dart';
import 'package:gully_cricket_scorer/ui/phone_login_page.dart';

class EnterOtpPage extends StatefulWidget {
  final String phoneNumber;
  const EnterOtpPage({super.key, required this.phoneNumber});

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  late final TextEditingController otpController;

  @override
  void initState() {
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomescreenBloc>(context);
    final colors = bloc.getRepository().getColors();
    final fonts = bloc.getRepository().getFonts();

    return BlocConsumer<HomescreenBloc, HomescreenState>(
      listener: (context, state) {
        if (state.runtimeType == WaitingForOtpPageState) {
          final waitingForOtpPageState = state as WaitingForOtpPageState;
          if (waitingForOtpPageState.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(waitingForOtpPageState.errorMessage!),
                duration: bloc.getRepository().getTimers().snackBarTime1,
              ),
            );
          }
        } else if (state.runtimeType == UserPageState) {
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
        }
      },
      buildWhen: (previous, current) {
        return current.runtimeType == WaitingForOtpPageState;
      },
      builder: (context, state) {
        final waitingForOtpPageState = state as WaitingForOtpPageState;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Gully Cricket Scorer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.darkBackgroundFontColor1,
                fontWeight: fonts.fontWeight1,
              ),
            ),
            backgroundColor: colors.darkBackgroundColor1,
            leading: waitingForOtpPageState.disableButton
                ? null
                : IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: const PhoneLoginPage(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: colors.darkBackgroundFontColor1,
                  ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Enter SMS OTP sent on mobile number ${widget.phoneNumber}',
                    style: TextStyle(
                      color: colors.lightBackgroundFontColor1,
                      fontWeight: fonts.fontWeight2,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '          Enter OTP',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          suffixIcon: const Icon(Icons.sms),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: waitingForOtpPageState.disableButton
                            ? MaterialStatePropertyAll(
                                colors.disabledButtonColor)
                            : MaterialStatePropertyAll(colors.buttonColor),
                      ),
                      onPressed: waitingForOtpPageState.disableButton
                          ? null
                          : () {
                              final waitingForOtpPageState =
                                  bloc.state as WaitingForOtpPageState;

                              bloc.add(VerifyOtpEvent(
                                otp: otpController.text,
                                confirmationResult:
                                    waitingForOtpPageState.confirmationResult!,
                              ));
                            },
                      child: Text(
                        'Sign-in',
                        style: waitingForOtpPageState.disableButton
                            ? TextStyle(
                                color: colors.disabledButtonFontColor,
                                fontWeight: fonts.fontWeight2,
                                fontSize: fonts.fontSize2,
                              )
                            : TextStyle(
                                color: colors.buttonFontColor,
                                fontWeight: fonts.fontWeight2,
                                fontSize: fonts.fontSize2,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
