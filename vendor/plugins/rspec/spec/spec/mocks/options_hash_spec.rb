require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    describe "calling :should_receive with an options hash" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @reporter = ::Spec::Runner::Reporter.new(@options)
        @example_group = Class.new(::Spec::Example::ExampleGroup).describe("Some Examples")
      end

      it "should report the file and line submitted with :expected_from" do
        example_definition = @example_group.it "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :expected_from => "/path/to/blah.ext:37")
          mock.rspec_verify
        end
        example = @example_group.new(example_definition)
        proxy = ::Spec::Example::ExampleRunner.new(@options, example)
        
        @reporter.should_receive(:example_finished) do |spec, error|
          error.backtrace.detect {|line| line =~ /\/path\/to\/blah.ext:37/}.should_not be_nil
        end
        proxy.run
      end

      it "should use the message supplied with :message" do
        example_definition = @example_group.it "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :message => "recebi nada")
          mock.rspec_verify
        end
        example = @example_group.new(example_definition)
        proxy = ::Spec::Example::ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |spec, error|
          error.message.should == "recebi nada"
        end
        proxy.run
      end
    end
  end
end
