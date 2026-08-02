import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:awesome_datetime/src/awesome_datetime_base.dart';

void main() {
  globalContext.setProperty('AwesomeDateTime'.toJS, _constructor.toJS);
}

JSObject _constructor(JSObject opts) {
  final dtString = (opts.getProperty('dtString'.toJS) as JSString).toDart;
  final instance = AwesomeDateTime(dtString: dtString);
  return _wrap(instance);
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