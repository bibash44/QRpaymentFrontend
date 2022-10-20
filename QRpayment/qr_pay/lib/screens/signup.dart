import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  int primaryColor = 0xFFCF2027;
  int _currentstep = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color(primaryColor))),
        home: Scaffold(
          backgroundColor: Color(primaryColor),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Center(
                child: SizedBox(
                  height: 400,
                  child: Card(
                    elevation: 5,
                    child: Stepper(
                      steps: getSteps(),
                      type: StepperType.vertical,
                      currentStep: _currentstep,
                      onStepContinue: () {
                        final lastStep = _currentstep == getSteps().length - 1;
                        if (lastStep) {
                          print("completed");
                        } else {
                          setState(() {
                            _currentstep += 1;
                          });
                        }
                      },
                      onStepCancel: () {
                        _currentstep == 0
                            ? null
                            : setState(() {
                                _currentstep -= 1;
                              });
                      },
                      onStepTapped: (step) {
                        setState(() {
                          _currentstep = step;
                        });
                      },
                      controlsBuilder: (context, details) {
                        final islastStep =
                            _currentstep == getSteps().length - 1;
                        return Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.all(15),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  child: Text(islastStep ? "Confirm" : "Next"),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              if (_currentstep != 0)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.all(15),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        side: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    child: const Text(
                                      "Back",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  List<Step> getSteps() => [
        Step(
          state: _currentstep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 0,
          title: const Text("Account"),
          content: Container(),
        ),
        Step(
          state: _currentstep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 1,
          title: const Text("Address"),
          content: Container(),
        ),
        Step(
          state: _currentstep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 2,
          title: const Text("Password"),
          content: Container(),
        ),
        Step(
          state: _currentstep > 3 ? StepState.complete : StepState.indexed,
          isActive: _currentstep >= 3,
          title: const Text("Complete"),
          content: Container(),
        ),
      ];
}
