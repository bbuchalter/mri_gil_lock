require 'benchmark'

RSpec.describe MriGilLock do
  it "has a version number" do
    expect(MriGilLock::VERSION).not_to be nil
  end

  it "can hold the GIL" do
    # https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    MriGilLock::Hold.for_microseconds(1_000_000)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elasped_time = end_time - start_time
    expect(elasped_time).to be_between(1.0, 1.1)
  end
end
