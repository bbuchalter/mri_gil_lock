#include "ruby.h"
#include <unistd.h> // provides usleep
#include <ruby/thread.h> // provides rb_thread_call_without_gvl

VALUE holdFor(VALUE self, VALUE rubyTimeToHold)
{
    usleep(NUM2UINT(rubyTimeToHold)); // avoid possible collision with ruby sleep functions
    return rubyTimeToHold;
}

void* holdForTwoSeconds()
{
    usleep(2000000); // avoid possible collision with ruby sleep functions
    return NULL;
}

VALUE holdForTwoSecondsWithoutGil(VALUE self)
{
    // https://silverhammermba.github.io/emberb/c/#c-in-ruby-threads
    rb_thread_call_without_gvl(holdForTwoSeconds, NULL, RUBY_UBF_IO, NULL);
    return self;
}

void Init_hold()
{
    VALUE moduleMriGilLock = rb_define_module("MriGilLock");
    VALUE classHold = rb_define_class_under(moduleMriGilLock, "Hold", rb_cObject);
    rb_define_singleton_method(classHold, "for_microseconds", holdFor, 1);
    rb_define_singleton_method(classHold, "for_two_seconds_without_gil", holdForTwoSecondsWithoutGil, 0);
}
