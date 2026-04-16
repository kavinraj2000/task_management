import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';

class AuthSignInPage extends StatelessWidget {
  AuthSignInPage({super.key});

  final AuthController controller = getIt<AuthController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Future<void> _signin(BuildContext context) async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (!isValid) return;

    final data = _formKey.currentState!.value;

    await controller.signin(
      data['email'].toString().trim(),
      data['password'].toString().trim(),
    );

    if (controller.status.value == AuthStatus.success && context.mounted) {
      context.goNamed(RouteName.taskmanagement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SIGN IN",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// EMAIL
                FormBuilderTextField(
                  name: 'email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),

                const SizedBox(height: 15),

                /// PASSWORD
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),

                const SizedBox(height: 20),

                /// BUTTON
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () => _signin(context),
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Sign In"),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                /// ERROR MESSAGE
                Obx(() {
                  if (controller.status.value != AuthStatus.error) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
