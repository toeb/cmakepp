## Events

Events are often usefull when working with modules. CMake of course has no need for events generally. Some of my projects (cutil/cps) needed them however. For example the package manager cps uses them to allow hooks on package install/uninstall/load events which the packages can register.


## Example


```
# create an event handler
function(my_event_handler arg)
 message("${event_name} called: ${arg}")
 return("answer1")
endfunction()

# add an event handler
event_addhandler(irrelevant_event_name my_event_handler)
# add lambda event handler
event_addhandler(irrelevant_event_name "(arg)->return($arg)")
# anything callable can be used as an event handler (even a cmake file containing a single function)

# emit event calls all registered event handlers in order
# and concatenates their return values
# side effects: prints irrelevent_event_name called: i am an argument
event_emit(irrelevant_event_name "i am an argument")
ans(result)


assert(EQUALS ${result} answer1 "i am an argument")
```

## Functions and Datatypes

* `<event id>` a globally unique identifier for an event (any name you want except `on_event` )
* `on event` a special event that gets fired on all events (mainly for debugging purposes)
* `event_addhandler(<event id> <callable>)` registers an event handler for the globally unique event identified by `<event id>` see definition for callable in [functions section](#functions)
* `event_removehandler(<event id> <callable>)` removes the specified event handler from the handler list (it is no longer invoked when event is emitted)
* `event_emit(<event id> [arg ...]) -> any[]` invokes the event identified by `<event id>` calls every handler passing along the argument list. every eventhandler's return value is concatenated and returned.  It is possible to register event handlers during call of the event itself the emit routine continues as long as their are uncalled registered event handlers but does not call them twice.
* ... (functions for dynamic events, access to all available events)




### Function List


* [event](#event)
* [events](#events)
* [events_track](#events_track)
* [event_addhandler](#event_addhandler)
* [event_cancel](#event_cancel)
* [event_clear](#event_clear)
* [event_emit](#event_emit)
* [event_get](#event_get)
* [event_handler](#event_handler)
* [event_handlers](#event_handlers)
* [event_handler_call](#event_handler_call)
* [event_new](#event_new)
* [event_removehandler](#event_removehandler)
* [is_event](#is_event)


### Function Descriptions

## <a name="event"></a> `event`





## <a name="events"></a> `events`





## <a name="events_track"></a> `events_track`





## <a name="event_addhandler"></a> `event_addhandler`





## <a name="event_cancel"></a> `event_cancel`





## <a name="event_clear"></a> `event_clear`





## <a name="event_emit"></a> `event_emit`





## <a name="event_get"></a> `event_get`





## <a name="event_handler"></a> `event_handler`





## <a name="event_handlers"></a> `event_handlers`





## <a name="event_handler_call"></a> `event_handler_call`





## <a name="event_new"></a> `event_new`





## <a name="event_removehandler"></a> `event_removehandler`





## <a name="is_event"></a> `is_event`






