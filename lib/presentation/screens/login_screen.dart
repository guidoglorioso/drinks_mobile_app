import 'package:drinks_mobile_app/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userNotifier = ref.read(appUserProvider.notifier);

    final textStyle = Theme.of(context).textTheme;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController pswController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            SizedBox(
              height: 60,
              child: Text('APP LOGIN', style: textStyle.displayLarge),
            ),
            SizedBox(height: 250),
            Text('Email', style: textStyle.bodyMedium),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 45,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'pepito@ejemplo.com',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Password', style: textStyle.bodyMedium),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: pswController,
                decoration: InputDecoration(
                  hintText: 'user password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),

            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      pswController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please, fill all the fields')),
                    );
                    return;
                  }
                  try {
                    await userNotifier.loginUser(
                      emailController.text,
                      pswController.text,
                    );

                    // Si por alguna razon no se recibio la respuesta a tiempo y el usuario salio de la ventana se evita continuar.
                    if (!context.mounted) return;

                    context.go('/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'User not found, please register an account',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
            SizedBox(height: 10),
            Text("Don't have an account?", style: textStyle.bodySmall),
            TextButton(
              onPressed: () => context.push('/register'),

              child: const Text(
                'Register',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
