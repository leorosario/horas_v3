import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horas_v3/screens/register_screen.dart';
import 'package:horas_v3/screens/reset_password_modal.dart';
import 'package:horas_v3/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    FlutterLogo(size: 76),
                    SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: 'E-mail'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      controller: _senhaController,
                      decoration: InputDecoration(hintText: 'Senha'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        authService
                            .entrarUsuario(
                              email: _emailController.text,
                              senha: _senhaController.text,
                            )
                            .then((String? erro) {
                              if (erro != null) {
                                final snackBar = SnackBar(
                                  content: Text(erro),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              }
                            });
                      },
                      child: Text('Entrar'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: Text('Entrar com google'),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Ainda não tem uma conta, crie uma conta.'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PasswordresetModal();
                          },
                        );
                      },
                      child: Text('Esqueceu sua senha?'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // 1) Autentica o usuário (mostra a UI de login)
    final account = await GoogleSignIn.instance.authenticate(
      // Se quiser, sugira escopos básicos já aqui:
      scopeHint: const ['openid', 'email', 'profile'],
    );

    // 2) Pegue o idToken (na v7, accessToken não está aqui)
    final auth = await account.authentication; // tem apenas idToken na v7
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception(
        'idToken veio nulo. Verifique configuração do app/Firebase.',
      );
    }

    // 3) Crie a credencial do Firebase apenas com idToken (suficiente para login)
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}
