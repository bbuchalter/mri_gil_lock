require 'benchmark'

RSpec.describe MriGilLock do
  it "has a version number" do
    expect(MriGilLock::VERSION).not_to be nil
  end

  it "can hold the GIL" do
    expect(Benchmark.measure { MriGilLock::Hold.for(1) }.real).to be_between(1.0, 1.1)
  end
end
