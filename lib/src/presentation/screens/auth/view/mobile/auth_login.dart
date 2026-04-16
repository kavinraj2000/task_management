import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/presentation/screens/auth/controller/auth_controller.dart';

enum AuthMode { login, signup }

class AuthLoginPage extends StatelessWidget {
  AuthLoginPage({super.key});

  final AuthController controller = getIt<AuthController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final Rx<AuthMode> mode = AuthMode.login.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Obx(() {
                  final isLogin = mode.value == AuthMode.login;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLogin ? "Welcome Back " : "Create Account ",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            isLogin
                                ? "Login to continue"
                                : "Sign up to get started",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),

                          const SizedBox(height: 25),

                          FormBuilderTextField(
                            name: 'email',
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),

                          const SizedBox(height: 15),

                          FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: controller.isLoading ? null : _submit,
                              child: Text(
                                isLogin ? "Login" : "Sign Up",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () {
                              mode.value = isLogin
                                  ? AuthMode.signup
                                  : AuthMode.login;
                            },
                            child: Text(
                              isLogin
                                  ? "New user? Create account"
                                  : "Already have an account? Login",
                            ),
                          ),

                          Obx(() {
                            if (controller.errorMessage.value.isEmpty) {
                              return const SizedBox();
                            }
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller.errorMessage.value,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          Obx(() {
            if (!controller.isLoading) return const SizedBox();
            return Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            );
          }),
        ],
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final data = _formKey.currentState!.value;

    if (mode.value == AuthMode.login) {
      controller.login(
        data['email'].toString().trim(),
        data['password'].toString().trim(),
      );
    } else {
      controller.signin(
        data['email'].toString().trim(),
        data['password'].toString().trim(),
      );
    }
  }
}
