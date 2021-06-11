import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/login_cubit/cubit.dart';
import 'package:shopappwithapi/cubit/login_cubit/states.dart';
import 'package:shopappwithapi/network/local/cache_helper.dart';
import 'package:shopappwithapi/screens/register_screen.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:shopappwithapi/screens/shop_layout.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
    var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
             
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data.token)
                  .then((value) {
                    token=state.loginModel.data.token;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ShopLayout()));
              });
            } else {
              print(state.loginModel.message);
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Login now to get our hot offers',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your email';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              ShopLoginCubit.get(context)
                                  .changePassWordVisibilaty();
                            },
                            onSubmit: (val) {
                              if (formKey.currentState.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'password is too short';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'login'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dont have an account?'),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                text: 'register')
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
