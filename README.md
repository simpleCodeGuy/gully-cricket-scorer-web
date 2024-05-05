# Gully Cricket Scorer  [[Click here to run this app]](https://gully-cricket-scorer.web.app/)
*Gully Cricket Scorer* is a web application for scoring in gully cricket matches.
It's main features are:
- open app in web browser
- sign in using mobile number & SMS OTP
- Do live scoring of a gully cricket match, score is saved online on server

# Cricket rules which are allowed in this app:
- In gully cricket, some rules of cricket are not followed, and some rules are tweaked for more convenience and flexibility.
- Batting opportunities
    - Runs can be scored in these ways only
        - single
        - double
        - triple
        - four
        - five
        - six
        - one extra run of noball 
        - one extra run of wide ball
    - Side change of a batter is allowed on any ball
    - Single batter is allowed to bat
- Bowling opportunities
    - Bowler can bowl two consecutive overs
    - Any batter can be out by only three ways
        - bowled out
        - catch out
        - run out

# Technology used to make this app
- flutter : 
    -   This application is completely written using Google's Flutter SDK for writing cross-platform application.
    -   Flutter SDK requires dart programming language, which is used in writing this application.
- flutter_bloc : 
    -   flutter_bloc is a library which implements BLoC architecture (Business Logic Component)
    -   This application uses flutter_bloc library for state management and BLoC architecture.
- Firebase :
    - Firebase is a serverless cloud technology by Google which provides user authentication, realtime database and other services.
    - Firebase is used in this application for user login using mobile number and SMS OTP (One Time Password). At present, mobile numbers starting from +91 i.e. from India are allowed.
    - Firebase is used for storing data of cricket matches of user.

# Architecture of this app
- UI layer contains all pages of app.
  - Widgets add event to bloc based on user interaction.
  - Widgets listen to one or few state of bloc. Whenever that state which is being listened to is emmited by bloc, widget updates itself.
- bloc layer contains Business Logic
  - It is the control centre ie. brain of the app.
  - Based on event added by UI, it interacts with data & then emits state
  - bloc does not hold any data of its own, it just contains reference of DataRepository
  - bloc contains event handlers for all events of that bloc.
  - When an event is added to bloc, then event handlers i.e. methods are triggered. These method may or may not emit a state.
- data layer holds data & its related logic
  - All firebase related methods are held in this layer & bloc layer calls  these methods to interact with data.
  - Data related to fonts, dimensions, colors. etc are made in this layer.


```
 ______             ________       ________
|  UI  | --Event-> |  bloc  | --> |  Data  |
|______| <-State-- |________| <-- |________|

```

- (UI) 
  - Pages
    - create_new_math_page
    - enter_otp_page
    - home_page
    - match_completed_page
    - match_page
    - phone_login_page
    - scorecard_page

- (bloc) 
  - HomescreenBloc
    - HomescreenEvent
        - NewMatchEvent
        - AddNewBatter
        - AddNewBowler
        - SelectBatter1AsCurrentBatter
        - SelectBatter2AsCurrentBatter
        - EditBatter
        - EditBolwer
        - ScoreSingleRun
        - ScoreDoubleRun
        - ScoreTripleRun
        - ScoreFourRun
        - ScoreFiveRun
        - ScoreSixRun
        - BoundaryFour
        - BoundarySix
        - Wide
        - NoBall
        - Bye
        - LegBye
        - LoginEvent
        - CreateAccountEvent
        - HomescreenInitialEvent
        - SignOutEvent
        - UserPageCreateEvent
        - CreateNewMatchEvent
        - OpenExistingMatchEvent
        - AddBatterEvent
        - ChangeStrikeEvent
        - AddBowlerEvent
        - Run0Event
        - Run1Event
        - Run2Event
        - Run3Event
        - Run4Event
        - Run5Event
        - Run6Event
        - OutCatchEvent
        - OutBowledEvent
        - OutRunBatter1Event
        - OutRunBatter2Event
        - WideBallEvent
        - NoBallEvent
        - UpdateScoreEvent
        - SelectNewBowlerEvent
        - SelectFixedBowlerEvent
        - AddNewBowlerEvent
        - OpenAddNewBatterPageEvent
        - AddNewBatterEvent
        - OpenMatchStatePageAfterBatterAddingEvent
        - EndInningsEvent
        - MatchAbandonedEvent
        - ShowScoreCardEvent
        - OpenUserPageFromMatchCompletedPageEvent
        - OpenUserPageFromMatchPageEvent
        - GetOTPevent
        - SendOtpToUserEvent
        - VerifyOtpEvent
        - GetOtpForAccountCreationEvent
        - CreatePhoneNumberAccountEvent
        - ChangePasswordEvent
    - HomescreenState
        - LoginWaitingState
        - LoginSuccessFul
        - AccountNotCreated
        - LoginError
        - CreateAccountErrorState
        - CreateAccountSuccessfulState
        - SignOutSuccessState
        - UserPageState
        - MatchPageState
        - BowlerNameListState
        - OpenAddNewBatterPageState
        - NewBatterAddedSuccessfulState
        - MatchCompletedPageState
        - ScoreCardDataState
        - WaitingForOtpPageState
        - CreatePasswordForAuthPageState


- (Data) 
  - DataRepository
    - AppColors
    - Dimensions
    - Fonts
    - Timers
    - static FirestoreData

- Injection of DataRepository & HomescreenBloc
  - Instance of DataRepository & HomescreenBloc is injected at level of MaterialApp
  - Repository is not accessed directly, instead reference of repo is passed while creation of bloc.
  - Repository is accessed as field of bloc.

  ```
  RepositoryProvider : DataRepository repo
  --BlocProvider : HomescreenBloc bloc(repo)
  ----MaterialApp
  ```

# Attribution
- ball ball png file is taken from
 <a href="https://www.flaticon.com/free-icons/cricket-bat" title="cricket bat icons">Cricket bat icons created by Design Circle - Flaticon</a>

# Files which contain firebase api key & related info is not put on github
- lib/firebase_options.dart
