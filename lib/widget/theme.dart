import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isura_system/services/size_config.dart';

const fontThin = 'Thin';
const fontLight = 'Light';
const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontBold = 'Bold';

/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeLarge = 24.0;
const textSizeXLarge = 30.0;

/* margin */
const spacing_control_half = 2.0;
const spacing_control = 4.0;
const spacing_standard = 8.0;
const spacing_middle = 10.0;
const spacing_standard_new = 16.0;
const spacing_large = 24.0;
const spacing_xlarge = 32.0;
const spacing_xxLarge = 40.0;

const profileImage = 'assets/images/profile.png';
const logo = "assets/images/logo.png";

const app_background = Color(0Xff323446);
const input_background_salon = Color(0XFF5D5D5D);
const AppDividerColor = Color(0xFFDADADA);

const colorPrimary = Color(0XffF9E420);
const colorPrimaryD = Color(0XffE0CD1C);
const colorSecondary = Color(0Xff2B2A29);
const colorAccent = Color(0Xff2a2c59);
const textColorPrimary = Color(0XFFf5f5f5);
const textColorSecondary = Color(0XFF777777);
const colorPrimary_light = Color(0XFFFFEEEE);
const colorPrimaryDark = Color(0XFF212121);
const shadow_color = Color(0X95E9EBF0);

const primary = Color(0Xff0047ba);
const red = Color(0XFFF10202);
const blue = Color(0XFF1D36C0);
const green = Color(0XFF4CAF50);
const grey = Color(0xFF808080);

Widget text(String text,
    {var fontSize = textSizeMedium,
    textColor = textColorPrimary,
    var fontFamily = fontRegular,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing,
    var textAllCaps = false,
    var isLongText = false,
    var fontWeight,
    var fontStyle,
    var textDecoration,
    var textOverflow}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: textOverflow,
    style: TextStyle(
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration: textDecoration,
    ),
  );
}

Widget formField(
  context,
  hint, {
  isEnabled = true,
  isDummy = false,
  TextEditingController controller,
  isPasswordVisible = false,
  isPassword = false,
  readOnly = false,
  keyboardType = TextInputType.text,
  FormFieldValidator<String> validator,
  onSaved,
  onTap,
  textInputAction = TextInputAction.next,
  ValueChanged<String> onChanged,
  List<TextInputFormatter> inputFormatters,
  FocusNode focusNode,
  FocusNode nextFocus,
  IconData suffixIcon,
  IconData prefixIcon,
  maxLine = 1,
  suffixIconSelector,
}) {
  return TextFormField(
    onTap: onTap,
    controller: controller,
    obscureText: isPassword ? isPasswordVisible : false,
    cursorColor: colorPrimary,
    readOnly: readOnly,
    maxLines: maxLine,
    keyboardType: keyboardType,
    validator: validator,
    onSaved: onSaved,
    onChanged: onChanged,
    textInputAction: textInputAction,
    focusNode: focusNode,
    onFieldSubmitted: (arg) {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    },
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(spacing_standard),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: prefixIcon == null ? 10 : 0),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      hintText: hint,
      errorStyle: TextStyle(
        fontSize: textSizeSMedium,
        fontFamily: fontBold,
      ),
      hintStyle: TextStyle(
        fontSize: textSizeMedium,
        color: textColorSecondary,
      ),
      prefixIcon: (prefixIcon != null)
          ? Icon(
              prefixIcon,
              color: textColorSecondary,
              size: 20,
            )
          : null,
      suffixIcon: isPassword
          ? GestureDetector(
              onTap: suffixIconSelector,
              child: new Icon(
                suffixIcon,
                color: textColorSecondary,
                size: 20,
              ),
            )
          : Icon(
              suffixIcon,
              color: textColorSecondary,
              size: 20,
            ),
    ),
    style: TextStyle(
      fontSize: textSizeLargeMedium,
      color: isDummy ? Colors.transparent : Colors.black,
      fontFamily: fontRegular,
    ),
  );
}

materialButton({
  var textContent,
  VoidCallback onPressed,
  var isStroked = false,
  var width,
  var height,
}) {
  return SizedBox(
    width: width ?? w(100),
    height: height ?? h(7),
    child: MaterialButton(
      elevation: 0,
      onPressed: () {
        onPressed();
      },
      shape: const StadiumBorder(),
      textColor: app_background,
      color: Colors.blue.withOpacity(0.6),
      child: text(
        textContent,
        textColor: app_background,
        fontFamily: fontBold,
      ),
    ),
  );
}
