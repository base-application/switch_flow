import 'package:flutter/services.dart';

///输入内容不能解析成double
bool isToDoubleError(String value) {
  try {
    double.parse(value);
  } catch (e) {
    return true;
  }
  return false;
}

class XNumberTextInputFormatter extends TextInputFormatter {
  final int? _maxIntegerLength;
  final int? _maxDecimalLength;
  final bool _isAllowDecimal;

  /// [maxIntegerLength]限定整数的最大位数，为null时不限
  /// [maxDecimalLength]限定小数点的最大位数，为null时不限
  /// [isAllowDecimal]是否可以为小数，默认是可以为小数，也就是可以输入小数点
  XNumberTextInputFormatter(
      {int? maxIntegerLength, int? maxDecimalLength, bool isAllowDecimal = true})
      : _maxIntegerLength = maxIntegerLength,
        _maxDecimalLength = maxDecimalLength,
        _isAllowDecimal = isAllowDecimal;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text.trim(); //去掉前后空格
    int selectionIndex = newValue.selection.end;
    if (_isAllowDecimal) {
      if (value == '.') {
        value = '0.';
        selectionIndex++;
      } else if (value != '' && isToDoubleError(value)) {
        //不是double输入数据
        return _oldTextEditingValue(oldValue);
      }
      //包含小数点
      if (value.contains('.')) {
        int pointIndex = value.indexOf('.');
        String beforePoint = value.substring(0, pointIndex);
//      print('$beforePoint');
        String afterPoint = value.substring(pointIndex + 1, value.length);
//      print('$afterPoint');
        //小数点前面没内容补0
        if (beforePoint.isEmpty) {
          value = '0.$afterPoint';
          selectionIndex++;
        } else {
          //限定整数位数
          if (null != _maxIntegerLength) {
            if (beforePoint.length > _maxIntegerLength!) {
              return _oldTextEditingValue(oldValue);
            }
          }
        }
        //限定小数点位数
        if (null != _maxDecimalLength) {
          if (afterPoint.length > _maxDecimalLength!) {
            return _oldTextEditingValue(oldValue);
          }
        }
      } else {
        //限定整数位数
        if (null != _maxIntegerLength) {
          if (value.length > _maxIntegerLength!) {
            return _oldTextEditingValue(oldValue);
          }
        }
      }
    } else {
      if (value.contains('.') ||
          (value != '' && isToDoubleError(value)) ||
          (null!=_maxIntegerLength&&value.length > _maxIntegerLength!)) {
        return _oldTextEditingValue(oldValue);
      }
    }

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  ///返回旧的输入内容
  TextEditingValue _oldTextEditingValue(TextEditingValue oldValue) {
    return TextEditingValue(
      text: oldValue.text,
      selection: TextSelection.collapsed(offset: oldValue.selection.end),
    );
  }


}


class MaxMinTextInputFormatter extends TextInputFormatter {
  final double max;
  final double min;

  MaxMinTextInputFormatter(this.max, this.min);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if(newValue.text == "") return newValue;
    if (isToDoubleError(newValue.text)) return oldValue;

    if (double.parse(newValue.text) > max || double.parse(newValue.text) < min) {
      return oldValue;
    }
    return newValue;
  }
}
