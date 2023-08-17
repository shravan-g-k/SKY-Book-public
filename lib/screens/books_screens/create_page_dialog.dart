import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/controller/page_controller.dart';

// Create Page Dialog a small AlertDialog that pops up when the user clicks on the add page button
class CreatePageDialog extends StatefulWidget {
  const CreatePageDialog({super.key, required this.bookId});
  final String bookId;

  @override
  State<CreatePageDialog> createState() => CreatePageDialogState();
}

class CreatePageDialogState extends State<CreatePageDialog> {
  final _formKey = GlobalKey<FormState>(); // Form key for the form validation
  late TextEditingController _pageIconController;
  late TextEditingController _pageTitleController;

  @override
  void initState() {
    _pageIconController = TextEditingController(
      text: '📄', //Initial value
    );
    _pageTitleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageIconController.dispose();
    _pageTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Create New Page'),
      // FORM
      content: Form(
        key: _formKey,
        // COLUMN - icon, title, create button
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ICON
            // constrained the width
            SizedBox(
              width: 50,
              child: TextFormField(
                controller: _pageIconController,
                maxLength: 1,
                decoration: const InputDecoration(
                  counter: SizedBox.shrink(), //hide the counter
                  errorStyle: TextStyle(fontSize: 10),
                ),
                style: const TextStyle(fontSize: 30),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a page icon';
                  }
                  return null;
                },
              ),
            ),
            // TITLE
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Page Title',
                errorStyle: TextStyle(fontSize: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a page title';
                }
                return null;
              },
            ),
            // SPACE
            const SizedBox(height: 16),
            // CREATE BUTTON
            // Consumer to get the PageController
            Consumer(builder: (context, ref, child) {
              return ElevatedButton(
                onPressed: () {
                  bool validated =
                      _formKey.currentState!.validate(); // Validate the form
                  if (validated) {
                    ref.read(pageControllerProvider).createPage(
                          title: _pageTitleController.text,
                          icon: _pageIconController.text,
                          data: '',
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          bookId: widget.bookId,
                          context: context,
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: const Size(double.infinity, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: Text(
                  'Create Page',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
