import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horas_v3/services/auth_service.dart';

class Menu extends StatelessWidget {
  final User user;
  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.manage_accounts_rounded, size: 48),
            ),
            accountName: Text(
              (user.displayName != null) ? user.displayName! : '',
            ),
            accountEmail: Text(user.email!),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              AuthService().deslogar();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Excluir Conta',
              style: TextStyle(
                color: Colors.red, // Texto vermelho
                fontWeight: FontWeight.bold, // opcional
              ),
            ),

            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController senhaController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text('Tem certeza?'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Digite sua senha para confirmar a exclusão da conta:',
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: senhaController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final senha = senhaController.text.trim();

                          if (senha.isNotEmpty) {
                            AuthService().excluirConta(senha: senha);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
