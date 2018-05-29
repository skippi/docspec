require "./spec_helper"

describe Docspec do
  it "compiles properly" do
    Docspec.doctest("./src/docspec.cr")
  end
end
