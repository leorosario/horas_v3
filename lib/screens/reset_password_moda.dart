import 'package:flutter/material.dart';
import 'package:horas_v3/services/auth_service.dart';

class PasswordresetModal extends StatefulWidget {
  const PasswordresetModal({super.key});

  @override
  State<PasswordresetModal> createState() => _PasswordresetModalState();
}

class _PasswordresetModalState extends State<PasswordresetModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recuperar senha'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Endereço de e-mail'),
          validator: (value) {
            if(value!.isEmpty){
              return 'Por favor, informe um endereço de e-mail válido';
            }
            return null;
          },
        ),

      )
    );
  }
}