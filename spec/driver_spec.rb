require 'spec_helper'
require 'capybara/driver/webkit'

describe Capybara::Driver::Webkit do
  let(:hello_app) do
    lambda do |env|
      body = <<-HTML
        <html><body>
          <script type="text/javascript">
            document.write("<p id='greeting'>he" + "llo</p>");
          </script>
        </body></html>
      HTML
      [200,
        { 'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s },
        [body]]
    end
  end

  before(:all) { @@browser = Capybara::Driver::Webkit::Browser.new }
  subject { Capybara::Driver::Webkit.new(hello_app, :browser => @@browser) }
  before { subject.visit("/hello") }
  after do
    subject.reset!
  end

  it "finds content after loading a URL" do
    subject.find("//*[contains(., 'hello')]").should_not be_empty
  end

  it "has an empty page after reseting" do
    subject.reset!
    subject.find("//*[contains(., 'hello')]").should be_empty
  end

  it "raises an error for an invalid xpath query" do
    expect { subject.find("totally invalid salad") }.
      to raise_error(Capybara::Driver::Webkit::WebkitError, /xpath/i)
  end

  it "returns an attribute's value" do
    subject.find("//p").first["id"].should == "greeting"
  end

  it "parses xpath with quotes" do
    subject.find('//*[contains(., "hello")]').should_not be_empty
  end

  it "returns a node's text" do
    subject.find("//p").first.text.should == "hello"
  end
end
