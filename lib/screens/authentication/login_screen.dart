import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_auth_methods.dart';
import '../home/home_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: phoneController,
                hintText: 'Enter phone number',
              ),
              context.read<FirebaseAuthMethods>().isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      onTap: () {
                        context
                            .read<FirebaseAuthMethods>()
                            .phoneSignIn(context, phoneController.text);
                      },
                      text: 'Sign-In',
                    ),
              CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                text: "Skip",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
