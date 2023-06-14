import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

class TextInputFieldBuilder extends StatefulWidget {
  const TextInputFieldBuilder({
    required this.tag,
    required this.builder,
    this.initialValue,
    this.autoValidate = false,
    super.key,
  });

  final Object tag;
  final Widget Function(
    BuildContext,
    TextFieldController,
    TextEditingController,
  ) builder;
  final String? initialValue;
  final bool autoValidate;

  @override
  State<TextInputFieldBuilder> createState() => _TextInputFieldBuilderState();
}

class _TextInputFieldBuilderState extends State<TextInputFieldBuilder> {
  TextFieldController? _controller;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller = TextFieldController(
        tag: widget.tag,
        parent: InputForm.controllerOf(context),
        initialValue: widget.initialValue,
        autoValidate: widget.autoValidate,
      );
      _controller!.addListener(() {
        final text = _controller!.value ?? '';

        if (_controller!.isIMEInput) {
          _textController.value = _textController.value.copyWith(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        } else {
          _textController.value = _textController.value.copyWith(text: text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller!,
      builder: (context, child) {
        return widget.builder(context, _controller!, _textController);
      },
    );
  }

  @override
  void deactivate() {
    InputForm.controllerOf(context).remove(widget.tag);
    super.deactivate();
  }
}
