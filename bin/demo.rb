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
non_blocking_thread = Thread.new do
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
    [non_blocking_thread, monitoring_thread].each(&:join)
  end
rescue Timeout::Error
  non_blocking_thread.kill
end

puts "Now let's demo a blocking thread that uses a C extension sleep:"
blocking_thread = Thread.new do
  while(true) do
    MriGilLock::Hold.for_microseconds(2_000_000)
  end
end
begin
  Timeout::timeout(10) do
    [blocking_thread, monitoring_thread].each(&:join)
  end
rescue Timeout::Error
  blocking_thread.kill
  monitoring_thread.kill
end
