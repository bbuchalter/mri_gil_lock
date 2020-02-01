#include "ruby.h"
#include <unistd.h> // provides usleep

VALUE holdFor(VALUE self, VALUE rubyTimeToHold)
{
    usleep(NUM2UINT(rubyTimeToHold)); // avoid possible collision with ruby sleep functions
    return rubyTimeToHold;
}

void Init_hold()
{
    VALUE moduleMriGilLock = rb_define_module("MriGilLock");
    VALUE classHold = rb_define_class_under(moduleMriGilLock, "Hold", rb_cObject);
    rb_define_singleton_method(classHold, "for_microseconds", holdFor, 1);
}
