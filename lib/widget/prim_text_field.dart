import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prim_derma_app/widget/style.dart';

class PrimTextField extends StatefulWidget {
  const PrimTextField({
    super.key,
    required this.controller,
    required this.field,
    required this.hintText,
    required this.icon,
    required this.inputType,
    this.isObscureText = false,
    this.isRequired = true,
    this.customErrorMessage,
    this.validator,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String field;
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final bool isObscureText;
  final bool isRequired;
  final String? customErrorMessage;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<PrimTextField> createState() => _PrimTextFieldState();
}

class _PrimTextFieldState extends State<PrimTextField> {
  late bool _obscured = widget.isObscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            widget.field,
            style: TextStyle(
              color: PRIMARY_BLUE,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscured,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.inputType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.isObscureText
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return widget.isRequired
                  ? (widget.customErrorMessage ??
                      'Sila Masukkan ${widget.field} Anda')
                  : null;
            }
            return widget.validator?.call(value);
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
