#include "ruby.h"

VALUE holdFor(VALUE self, VALUE rubyTimeToHold)
{
    sleep(NUM2CHR(rubyTimeToHold));
    return rubyTimeToHold;
}

void Init_hold()
{
    VALUE moduleMriGilLock = rb_define_module("MriGilLock");
    VALUE classHold = rb_define_class_under(moduleMriGilLock, "Hold", rb_cObject);
    rb_define_singleton_method(classHold, "for", holdFor, 1);
}
