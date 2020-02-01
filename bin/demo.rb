#!/usr/bin/env ruby
require 'bundler/setup'
require 'mri_gil_lock'
require 'timeout'

Thread.abort_on_exception=true

def test_gil_lock
 start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 sleep(1)
 end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 elapsed_time = end_time - start_time

 if elapsed_time > 1.1
  puts "GIL locking, time elapsed #{elapsed_time}"
 else
   puts "NO GIL locking, time elapsed #{elapsed_time}"
 end
end

puts "First, let's demo a non blocking thread that uses Ruby's sleep:"
ruby_sleep_thread = Thread.new do
  while(true) do
    sleep(2)
  end
end

monitoring_thread = Thread.new do
  while(true) do
    test_gil_lock
  end
end

begin
  Timeout.timeout(10) do
    [ruby_sleep_thread, monitoring_thread].each(&:join)
  end
rescue Timeout::Error
  ruby_sleep_thread.kill
end

puts "Now let's demo a blocking thread that uses a C extension:"
c_extension_sleep_thread = Thread.new do
  while(true) do
    MriGilLock::Hold.for_microseconds(2_000_000)
  end
end
begin
  Timeout::timeout(10) do
    [c_extension_sleep_thread, monitoring_thread].each(&:join)
  end
rescue Timeout::Error
  c_extension_sleep_thread.kill
end

puts "Now let's demo a non blocking thread that uses a C extension which releases the GIL:"
c_extension_sleep_thread_that_releases_the_gil = Thread.new do
  while(true) do
    MriGilLock::Hold.for_two_seconds_without_gil
  end
end
begin
  Timeout::timeout(10) do
    [c_extension_sleep_thread_that_releases_the_gil, monitoring_thread].each(&:join)
  end
rescue Timeout::Error
  c_extension_sleep_thread_that_releases_the_gil.kill
end

monitoring_thread.kill # And we're done
puts "Done!"
