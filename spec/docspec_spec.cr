require "./spec_helper"

describe Docspec do
  it "compiles properly" do
    Docspec.doctest("./spec/docspec_spec.cr")
  end
end
