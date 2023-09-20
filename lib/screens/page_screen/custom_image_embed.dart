
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';

// Custom Embed for the Images in the Quill Editor
class ImageBlockEmbed extends CustomBlockEmbed {
  ImageBlockEmbed(super.type, super.data);
  //              ^key         ^value
}

// Custom Builder for the Images in the Quill Editor
class ImageBlockBuilder extends EmbedBuilder {
  final Function(Embed node)
      onDelete; //used to delete the image from the editor
  // called from the parent widget (PageScreen)

  ImageBlockBuilder(this.onDelete);
  @override
  String get key => "image"; //key for the image
  // used to identify the image in the editor
  @override
  Widget build(BuildContext context, QuillController controller, Embed node,
      bool readOnly, bool inline, TextStyle textStyle) {
    final imageBytes = Uint8List.fromList((node.value.data).codeUnits);
    // STACK - Image + Delete Button
    return Stack(
      children: [
        // IMAGE
        Image.memory(
          imageBytes,
          gaplessPlayback: true,
        ),
        // DELETE BUTTON
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black54),
            ),
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete(node); //call the function to delete the image
            },
          ),
        ),
      ],
    );
  }
}
