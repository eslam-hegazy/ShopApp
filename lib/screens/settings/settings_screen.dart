import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_cubit.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_states.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        var loginModel = ShopCubit.get(context).userModel;
        nameController.text = loginModel.data.name;
        emailController.text = loginModel.data.email;
        phoneController.text = loginModel.data.phone;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      label: 'Name',
                      prefix: Icons.person),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Email must not be empty';
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Phone must not be empty';
                        }
                        return null;
                      },
                      label: 'Phone',
                      prefix: Icons.phone),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                      function: () {
                        if (formKey.currentState.validate()) {
                          ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text);
                        }
                      },
                      text: 'update'),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                      function: () {
                        signOut(context);
                      },
                      text: 'logout'),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
