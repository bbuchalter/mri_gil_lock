require 'benchmark'

RSpec.describe MriGilLock::Hold do
  describe "#for_microseconds" do
    it "can hold the GIL for a specified amount of time" do
      # https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      MriGilLock::Hold.for_microseconds(1_000_000)
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elasped_time = end_time - start_time
      expect(elasped_time).to be_between(1.0, 1.1)
    end
  end

  describe "#for_two_seconds_without_gil" do
    it "does not hold the GIL" do
      # https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      MriGilLock::Hold.for_two_seconds_without_gil
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elasped_time = end_time - start_time
      expect(elasped_time).to be_between(2.0, 2.1)
    end
  end
end
