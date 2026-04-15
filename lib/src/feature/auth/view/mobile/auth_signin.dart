import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final controller = getIt<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (controller.status.value == AuthStatus.success) {
      await controller.signin(email, password);
      if (context.mounted) {
        context.goNamed(RouteName.taskmanagement);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SIGN IN",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
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
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign In"),
                ),
              );
            }),

            const SizedBox(height: 10),

            /// ERROR (FIXED)
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
    );
  }
}
