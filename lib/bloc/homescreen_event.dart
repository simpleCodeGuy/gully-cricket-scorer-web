part of 'homescreen_bloc.dart';

@immutable
sealed class HomescreenEvent {}

// final class NewMatchEvent extends HomescreenEvent {}

// final class AddNewBatter extends HomescreenEvent {}

// final class AddNewBowler extends HomescreenEvent {}

// final class SelectBatter1AsCurrentBatter extends HomescreenEvent {}

// final class SelectBatter2AsCurrentBatter extends HomescreenEvent {}

// final class ViewBatter1Score extends HomescreenEvent {}

// final class ViewBatter2Score extends HomescreenEvent {}

// final class EditBatter extends HomescreenEvent {}

// final class EditBolwer extends HomescreenEvent {}

// final class ScoreSingleRun extends HomescreenEvent {}

// final class ScoreDoubleRun extends HomescreenEvent {}

// final class ScoreTripleRun extends HomescreenEvent {}

// final class ScoreFourRun extends HomescreenEvent {}

// final class ScoreFiveRun extends HomescreenEvent {}

// final class ScoreSixRun extends HomescreenEvent {}

// final class BoundaryFour extends HomescreenEvent {}

// final class BoundarySix extends HomescreenEvent {}

// final class Wide extends HomescreenEvent {}

// final class NoBall extends HomescreenEvent {}

// final class Bye extends HomescreenEvent {}

// final class LegBye extends HomescreenEvent {}

// final class LoginEvent extends HomescreenEvent {
//   final String loginId;
//   final String password;
//   LoginEvent(this.loginId, this.password)
//   @override
//   String toString() {
//     return '$loginId, $password';
//   }
// }

// final class CreateAccountEvent extends HomescreenEvent {
//   final String loginId;
//   final String password;

//   CreateAccountEvent(this.loginId, this.password);
// }

// final class HomescreenInitialEvent extends HomescreenEvent {}

final class SignOutEvent extends HomescreenEvent {}

final class UserPageCreateEvent extends HomescreenEvent {
  final User user;
  UserPageCreateEvent(this.user);
}

final class CreateNewMatchEvent extends HomescreenEvent {
  // final String userEmail;
  final User user;
  final String teamBattingFirstName;
  final String teamBattingSecondName;
  final int maxOvers;

  CreateNewMatchEvent(
    this.user,
    this.teamBattingFirstName,
    this.teamBattingSecondName,
    this.maxOvers,
  );
}

final class OpenExistingMatchEvent extends HomescreenEvent {
  // final String userEmail;
  final User user;
  final String matchName;

  final DateTime dateTime;
  final bool matchInProgress;
  OpenExistingMatchEvent(
    // this.userEmail,
    this.user,
    this.matchName,
    this.dateTime,
    this.matchInProgress,
  );
}

class AddBatterEvent extends HomescreenEvent {
  final String batterName;
  AddBatterEvent(this.batterName);
}

class ChangeStrikeEvent extends HomescreenEvent {}

class AddBowlerEvent extends HomescreenEvent {
  final String bowlerName;
  AddBowlerEvent(this.bowlerName);
}

class Run0Event extends HomescreenEvent {}

class Run1Event extends HomescreenEvent {}

class Run2Event extends HomescreenEvent {}

class Run3Event extends HomescreenEvent {}

class Run4Event extends HomescreenEvent {}

class Run5Event extends HomescreenEvent {}

class Run6Event extends HomescreenEvent {}

class OutCatchEvent extends HomescreenEvent {}

class OutBowledEvent extends HomescreenEvent {}

class OutRunBatter1Event extends HomescreenEvent {}

class OutRunBatter2Event extends HomescreenEvent {}

class WideBallEvent extends HomescreenEvent {}

class NoBallEvent extends HomescreenEvent {}

class UpdateScoreEvent extends HomescreenEvent {}

class SelectNewBowlerEvent extends HomescreenEvent {
  final bool innings1inProgress;
  final MatchPageState previousMatchPageState;
  SelectNewBowlerEvent(
    this.innings1inProgress,
    this.previousMatchPageState,
  );
}

class SelectFixedBowlerEvent extends HomescreenEvent {
  final String selectedBowlerName;
  final MatchPageState previousMatchPageState;
  SelectFixedBowlerEvent(
    this.selectedBowlerName,
    this.previousMatchPageState,
  );
}

class AddNewBowlerEvent extends HomescreenEvent {
  final String newBowlerName;
  final bool innings1inProgress;
  final MatchPageState previousMatchPageState;
  AddNewBowlerEvent(
    this.newBowlerName,
    this.innings1inProgress,
    this.previousMatchPageState,
  );
}

class OpenAddNewBatterPageEvent extends HomescreenEvent {
  final bool addingBatter1;
  final MatchPageState previousMatchPageState;
  OpenAddNewBatterPageEvent(this.addingBatter1, this.previousMatchPageState);
}

class AddNewBatterEvent extends HomescreenEvent {
  final bool addingBatter1;
  final String newBatterName;
  final bool innings1inProgress;
  final MatchPageState previousMatchPageState;
  AddNewBatterEvent(
    this.addingBatter1,
    this.newBatterName,
    this.innings1inProgress,
    this.previousMatchPageState,
  );
}

class OpenMatchStatePageAfterBatterAddingEvent extends HomescreenEvent {
  final bool addingBatter1;
  final String newBatterName;
  final MatchPageState previousMatchPageState;
  final String? errorOrNullIfSuccess;
  OpenMatchStatePageAfterBatterAddingEvent(
    this.addingBatter1,
    this.newBatterName,
    this.previousMatchPageState,
    this.errorOrNullIfSuccess,
  );
}

class EndInningsEvent extends HomescreenEvent {
  final bool endInnings1;
  EndInningsEvent(this.endInnings1);
  bool get endInnings2 => !endInnings1;
}

class MatchAbandonedEvent extends HomescreenEvent {
  MatchAbandonedEvent();
}

class ShowScoreCardEvent extends HomescreenEvent {
  final User user;
  final String documentIdOfMatch;
  ShowScoreCardEvent(this.user, this.documentIdOfMatch);
}

class OpenUserPageFromMatchCompletedPageEvent extends HomescreenEvent {}

class OpenUserPageFromMatchPageEvent extends HomescreenEvent {}

// class BackButtonPressedInCreateMatchPageEvent extends HomescreenEvent {}
class GetOTPevent extends HomescreenEvent {
  final String phoneNumber;
  GetOTPevent(this.phoneNumber);
}

class SendOtpToUserEvent extends HomescreenEvent {
  final String phoneNumber;
  SendOtpToUserEvent(this.phoneNumber);
}

class VerifyOtpEvent extends HomescreenEvent {
  final String otp;
  final ConfirmationResult confirmationResult;
  VerifyOtpEvent({
    required this.otp,
    required this.confirmationResult,
  });
}

class GetOtpForAccountCreationEvent extends HomescreenEvent {
  final String phoneNumber;
  GetOtpForAccountCreationEvent(this.phoneNumber);
}

class CreatePhoneNumberAccountEvent extends HomescreenEvent {
  final String phoneNumber;
  final String otp;
  final String verificationId;
  CreatePhoneNumberAccountEvent(
      this.phoneNumber, this.otp, this.verificationId);
}

class ChangePasswordEvent extends HomescreenEvent {
  final UserCredential userCredential;
  final String password;
  ChangePasswordEvent(this.userCredential, this.password);
}

class AppStartedForFirstTimeEvent extends HomescreenEvent {}
