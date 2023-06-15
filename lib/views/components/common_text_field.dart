import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String? fieldName;
  final String? hintText;
  final TextEditingController? fieldController;
  final String? Function(String?)? validator;
  final bool filled;
  final int? maxLines;
  final Icon? icon;
  final bool? obscureText;
  const CommonTextField(
      {Key? key,
      this.fieldName,
      this.hintText,
      required this.fieldController,
      this.validator,
      this.filled = true,
      this.maxLines,
      this.icon,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: fieldController,
      obscureText: obscureText ?? false,
      // style: SizeConfig.kStyle14W500,
      // maxLines: maxLines,
      decoration: InputDecoration(
        // icon: icon,
        filled: filled,
        fillColor: Color(0xffF2F8FF),
        labelText: fieldName,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
