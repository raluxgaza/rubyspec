require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../shared/constants', __FILE__)

describe "Digest::MD5.file" do

  describe "when passed a path to a file that exists" do
    before :each do
      @file = tmp("md5_temp")
      touch(@file) {|f| f.write MD5Constants::Contents }
    end

    after :each do
      rm_r @file
    end

    it 'returns a Digest::MD5 object' do
      Digest::MD5.file(@file).should be_kind_of(Digest::MD5)
    end
  
    it 'returns a Digest::MD5 object with the correct digest' do
      Digest::MD5.file(@file).digest.should == MD5Constants::Digest
    end

    it "calls #to_str on an object and returns the Digest::MD5 with the result" do
      obj = mock("to_str")
      obj.should_receive(:to_str).and_return(@file)
      Digest::MD5.file(obj).should be_kind_of(Digest::MD5)
    end
  end

  it 'raises a Errno::EISDIR when passed a path that is a directory' do
    lambda { Digest::MD5.file(".") }.should raise_error(Errno::EISDIR)
  end

  it 'raises a Errno::ENOENT when passed a path that does not exist' do
    lambda { Digest::MD5.file("") }.should raise_error(Errno::ENOENT)
  end

  it 'raises a TypeError when passed nil' do
    lambda { Digest::MD5.file(nil) }.should raise_error(TypeError)
  end
end
