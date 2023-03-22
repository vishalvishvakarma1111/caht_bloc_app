import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/login/login_view.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/homeview.dart';
import 'bloc/signup_bloc.dart';
import 'bloc/signup_event.dart';
import 'bloc/signup_state.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupErrorState) {
            Util.showToast(state.msg);
          }
          if (state is SignupSuccess) {
             Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const HomeView();
                }), (route) => false);
          }
        },
        builder: (context, state) {
          print("-----print-----   ${state}");
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(width: 20, height: 50),
                    const Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20, height: 200),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration().deco.copyWith(
                            hintText: "Enter name",
                          ),
                    ),
                    const SizedBox(width: 20, height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration().deco.copyWith(
                            hintText: "Enter email",
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration().deco.copyWith(
                            hintText: "Enter password",
                          ),
                    ),
                    const SizedBox(height: 30),
                    state is SignupLoadedState && state.loader
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MaterialButton(
                            minWidth: double.maxFinite,
                            onPressed: () {
                              BlocProvider.of<SignupBloc>(context).add(
                                BtnTapEvent(
                                  email: emailController.text,
                                  pwd: passwordController.text,
                                  name: nameController.text.trim(),
                                ),
                              );
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Signup",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    MaterialButton(
                      minWidth: double.maxFinite,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return const LoginView();
                        }));
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Already have account Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
