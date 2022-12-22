import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/utils/colors.dart';

class Utils{
  static Widget commonText(
      {required String text,
        double? fontSize,
        Color? fontColor,
        FontWeight? fontWeight,
        TextAlign? textAlign,
        TextOverflow? overflow,
        TextDecoration? textDecoration,
        int? maxLine,
        String? fontFamily}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      maxLines: maxLine ?? 1,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
  static TextStyle commonTextStyle() {
    return TextStyle(

      fontSize: 15,
      color: AppColors.grey,
      fontWeight: FontWeight.normal,
    );
  }
  static Widget commonTextField({
    required TextEditingController textEditingController,
    String? hintText,
    TextStyle? hintStyle,
    int? maxLine,
    Function? validator,
    Function? onChanged,
    Function? onTap,
    bool? readOnly,
    TextAlign? textAlign,
    FocusNode? focusNode,
    Widget? prefix,
    String? prefixText,
    TextStyle? prefixStyle,
    Widget? prefixIcon,
    Widget? suffix,
    TextInputType? textInputType,
    TextStyle? textStyle,
    List<TextInputFormatter>? inputFormatter,
    TextInputAction? textInputAction,
    double? heights,
    double? widths,
    BoxBorder? border,
    BorderRadius? borderRadius,
  }) {
    return TextFormField(
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
      inputFormatters: inputFormatter,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      style: textStyle ??
          TextStyle(
            fontSize: 15,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
      decoration: InputDecoration(
        prefix: prefix,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: AppColors.white,
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle:  TextStyle(
          fontSize: 14,
          color: AppColors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      cursorColor: AppColors.black,
      maxLines: maxLine ?? 1,
      controller: textEditingController,
      validator: (value) {
        if (validator != null) {
          return validator(value);
        }
        return null;
      },
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      readOnly: readOnly ?? false,
      textAlign: textAlign ?? TextAlign.start,
      focusNode: focusNode,
    );
  }

  static commonButton({
    Function? onTap,
    required String buttonText,
  //  Color? buttonColor,
    double? width,
    double? heights,
    Color? fontColor,
    FontWeight? fontWeight,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: heights,
        //
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: width ?? Get.width,
        alignment: Alignment.center,
        padding: heights == null
            ? const EdgeInsets.symmetric(
          vertical: 20,
        )
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.blue,
        ),
        child: Utils.commonText(text: buttonText, fontColor: fontColor ?? AppColors.white, fontWeight: fontWeight ?? FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(this);
  }
}