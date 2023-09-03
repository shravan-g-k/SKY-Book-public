import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:SkyBook/controller/book_controller.dart';

import '../../model/book_model.dart';
import '../../utils/routes.dart';

class CreateUpdatePasswordScreen extends ConsumerStatefulWidget {
  const CreateUpdatePasswordScreen(
      {super.key, required this.book, required this.isCreate});
  final Book book;
  final bool isCreate;
  @override
  ConsumerState<CreateUpdatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState
    extends ConsumerState<CreateUpdatePasswordScreen> {
  bool isConfirmPasswordVisible = false;
  bool isPasswordVisible = false;
  late TextEditingController _controller;
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      if (isConfirmPasswordVisible) {
        if (password == _controller.text) {
          Book book = widget.book.copyWith(password: password);
          ref
              .read(bookControllerProvider)
              .updateBook(context: context, book: book)
              .then((value) {
            if (value) {
              context.go(MyRouter.homeRoute);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password does not match'),
            ),
          );
        }
        return;
      }
      setState(() {
        password = _controller.text;
        isConfirmPasswordVisible = true;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.isCreate ? 'Create Password' : 'Update Password',
                    style: TextStyle(
                      fontSize: 30,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.book.icon,
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                widget.book.title,
                style: const TextStyle(
                  fontSize: 35,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${isConfirmPasswordVisible ? 'Confirm' : 'Enter'} 4 digit password",
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    obscureText: !isPasswordVisible,
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(4)],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      if (value.length != 4) {
                        return '4 digit required';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      submit();
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffix: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: const Size(200, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  splashFactory: InkRipple.splashFactory,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
