import 'package:amazon/screens/animations_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String testEmail = 'anas@gmail.com';
  String password = '123456';
  final formKey = GlobalKey<FormState>();
  final passwordFoucsNode = FocusNode();
  Artboard? riverArtBoard;
  bool isLookingLeft = false;
  bool isLookingRight = false;
  late RiveAnimationController controllerIdel;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;

  void removeAllControllers() {
    riverArtBoard?.artboard.removeController(controllerIdel);
    riverArtBoard?.artboard.removeController(controllerHandsUp);
    riverArtBoard?.artboard.removeController(controllerHandsDown);
    riverArtBoard?.artboard.removeController(controllerSuccess);
    riverArtBoard?.artboard.removeController(controllerFail);
    riverArtBoard?.artboard.removeController(controllerLookDownRight);
    riverArtBoard?.artboard.removeController(controllerLookDownLeft);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdelController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerIdel);
    debugPrint('idel');
  }

  void addHandsUpController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerHandsUp);
    debugPrint('hands up');
  }

  void addHandsDownController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerHandsDown);
    debugPrint('hands down');
  }

  void addSuccessController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerSuccess);
    debugPrint('success');
  }

  void addFailController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerFail);
    debugPrint('fail');
  }

  void addLookDownRightController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerLookDownRight);
    debugPrint('look down right');
  }

  void addLookDownLeftController() {
    removeAllControllers();
    riverArtBoard?.artboard.addController(controllerLookDownLeft);
    debugPrint('look down left');
  }

  void checkForPasswordFoucsNode() {
    passwordFoucsNode.addListener(() {
      if (passwordFoucsNode.hasFocus) {
        addHandsUpController();
      } else {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    controllerIdel = SimpleAnimation(AnimationsEnum.idel.name);
    controllerHandsUp = SimpleAnimation(AnimationsEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationsEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationsEnum.success.name);
    controllerFail = SimpleAnimation(AnimationsEnum.fail.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationsEnum.Look_down_right.name);
    controllerLookDownLeft =
        SimpleAnimation(AnimationsEnum.Look_down_left.name);

    rootBundle.load('assets/login_animation.riv').then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(controllerIdel);
        setState(() {
          riverArtBoard = artboard;
        });
        checkForPasswordFoucsNode();
      },
    );
    super.initState();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: riverArtBoard == null
                          ? const SizedBox.shrink()
                          : Rive(artboard: riverArtBoard!)),
                  TextFormField(
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) =>
                        value != testEmail ? 'Email is not valid' : null,
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          value.length < 16 &&
                          !isLookingLeft) {
                        addLookDownLeftController();
                      } else if (value.isNotEmpty &&
                          value.length > 16 &&
                          !isLookingRight) {
                        addLookDownRightController();
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    focusNode: passwordFoucsNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) =>
                        value != password ? 'Email is not valid' : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.blue),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            passwordFoucsNode.unfocus();
                            validateEmailAndPassword();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
