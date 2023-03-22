import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/login/bloc/login_bloc.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/homeview.dart';
import '../shopping/dashbaord/dashbaord_view.dart';
import '../shopping/home_shopping/home_shopping_view.dart';
import '../signup/sign_up_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            Util.showToast(state.msg);
          }
          if (state is LoginSuccess) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                return const HomeView();
              //return DashBoardView();
            }), (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(width: 20, height: 50),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20, height: 200),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration().deco.copyWith(
                            hintText: "Enter email",
                          ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration().deco.copyWith(
                            hintText: "Enter password",
                          ),
                    ),
                    const SizedBox(height: 30),
                    state is LoginLoadedState && state.loader
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MaterialButton(
                            minWidth: double.maxFinite,
                            onPressed: () {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(LoginBtnTapEvent(email: emailController.text, pwd: passwordController.text));
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      minWidth: double.maxFinite,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return SignupView();
                        }));
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Don\'t have account signup",
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
