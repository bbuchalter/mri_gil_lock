#include "ruby.h"
#include <unistd.h> // provides usleep

VALUE holdFor(VALUE self, VALUE rubyTimeToHold)
{
    usleep(NUM2UINT(rubyTimeToHold)); // avoid possible collision with ruby sleep functions
    return rubyTimeToHold;
}

void holdForTwoSeconds(VALUE self)
{
    usleep(2000000); // avoid possible collision with ruby sleep functions
}

void Init_hold()
{
    VALUE moduleMriGilLock = rb_define_module("MriGilLock");
    VALUE classHold = rb_define_class_under(moduleMriGilLock, "Hold", rb_cObject);
    rb_define_singleton_method(classHold, "for_microseconds", holdFor, 1);
    rb_define_singleton_method(classHold, "for_two_seconds", holdForTwoSeconds, 0);
}
