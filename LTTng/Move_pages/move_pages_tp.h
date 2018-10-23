#undef TRACEPOINT_PROVIDER
#define TRACEPOINT_PROVIDER move_pages 

#undef TRACEPOINT_INCLUDE
#define TRACEPOINT_INCLUDE "./move_pages_tp.h"

#if !defined(_MOVE_PAGES_TP_H) || defined(TRACEPOINT_HEADER_MULTI_READ)
#define _MOVE_PAGES_TP_H

#include <lttng/tracepoint.h>

TRACEPOINT_EVENT(
    move_pages,
    numa_move_pages_tracepoint,
    TP_ARGS(
        int, my_integer_arg,
        char*, my_string_arg
    ),
    TP_FIELDS(
        ctf_string(my_string_field, my_string_arg)
        ctf_integer(int, my_integer_field, my_integer_arg)
    )
)

#endif /* _MOVE_PAGES_TP_H  */

#include <lttng/tracepoint-event.h>
