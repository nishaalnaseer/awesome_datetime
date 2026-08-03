import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:awesome_datetime/src/awesome_datetime_base.dart';

JSObject _mapToJSObject(Map<String, dynamic> map) {
  final obj = JSObject();

  for (final entry in map.entries) {
    obj.setProperty(entry.key.toJS, _dartValueToJS(entry.value));
  }

  return obj;
}

JSAny? _dartValueToJS(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.toJS;
  if (value is bool) return value.toJS;
  if (value is int) return value.toJS;
  if (value is double) return value.toJS;
  if (value is Map<String, dynamic>) return _mapToJSObject(value);
  if (value is List) {
    final jsArray = JSArray();
    for (var i = 0; i < value.length; i++) {
      jsArray.setProperty(i.toString().toJS, _dartValueToJS(value[i]));
    }
    return jsArray;
  }
  throw ArgumentError('Unsupported type for JS conversion: ${value.runtimeType}');
}

void main() {
  final ctor = _constructor.toJS;
  ctor.setProperty('dateDiff'.toJS, _dateDiff.toJS);
  globalContext.setProperty('AwesomeDateTime'.toJS, ctor);
}

JSObject _constructor(JSObject opts) {
  final dtString = (opts.getProperty('dtString'.toJS) as JSString).toDart;
  final instance = AwesomeDateTime(dtString: dtString);
  return _wrap(instance);
}

JSObject _dateDiff(JSString fromDate, JSString toDate) {
  final result = AwesomeDateTime.dateDiff(fromDate.toDart, toDate.toDart);
  return _mapToJSObject(result);
}

JSObject _wrap(AwesomeDateTime instance) {
  final obj = JSObject();

  obj.setProperty(
    'toUTCTime'.toJS,
    (() => instance.toUTCTime().toJS).toJS,
  );
  obj.setProperty(
    'toLocalTime'.toJS,
    (() => instance.toLocalTime().toJS).toJS,
  );
  obj.setProperty(
    'setTimeZone'.toJS,
    ((JSString tz) => instance.setTimeZone(tz.toDart)).toJS,
  );
  obj.setProperty(
    'getLocalOffset'.toJS,
    (() => instance.getLocalOffset().toJS).toJS,
  );
  obj.setProperty(
    'isTzAware'.toJS,
    (() => instance.tzAware.toJS).toJS,
  );

  return obj;
}