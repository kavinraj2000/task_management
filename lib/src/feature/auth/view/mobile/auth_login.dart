import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  final controller = getIt<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// LOADING BUTTON (REACTIVE)
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading ? null : _login,
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),
                );
              }),

              const SizedBox(height: 10),

              /// ERROR UI (REACTIVE)
              Obx(() {
                if (controller.errorMessage.isEmpty) {
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
    );
  }
}
