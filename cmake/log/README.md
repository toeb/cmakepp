## Logging Functions


`CMake`'s logging is restricted to using the built in `message()` function. It writes the messages to `stdout` and `stderr` depending on the given tag present (`STATUS`, `ERROR`, `FATAL_ERROR`,`WARNING`, `<none>`).  This is sometimes not enough - especially when the output of your `CMake` script should be very controlled (ie. it is important that no debug or status messages are ouput when users expect the output to adher to a certain format)

This is why I started to write log functions which do not output anything.  You can listen to log messages using the `event` system - the `on_log_message` is called for every log message that is output.


### Function List


* [error](#error)
* [log](#log)
* [log_record_clear](#log_record_clear)
* [log_last_error_entry](#log_last_error_entry)
* [log_last_error_message](#log_last_error_message)
* [log_last_error_print](#log_last_error_print)
* [log_print](#log_print)

### Function Descriptions

## <a name="error"></a> `error`





## <a name="log"></a> `log`





## <a name="log_record_clear"></a> `log_record_clear`





## <a name="log_last_error_entry"></a> `log_last_error_entry`





## <a name="log_last_error_message"></a> `log_last_error_message`





## <a name="log_last_error_print"></a> `log_last_error_print`





## <a name="log_print"></a> `log_print`







