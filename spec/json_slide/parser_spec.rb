require 'spec_helper'
require 'json_slide/parser'

describe JsonSlide::Parser do

  describe '.parse' do

    it 'raises argument error if no argument is provided' do
      expect { JsonSlide::Parser.parse }.to raise_error(ArgumentError)
    end

    context 'json string is given as argument' do
      context 'and its valid' do
        it 'parses the json string' do
          expect(JsonSlide::Parser.parse("{\"slide1\":{},\"slide2\":{}}")).to eq({slide1: {}, slide2: {}})
        end
      end
      context 'and its invalid' do
        it 'raises Invalid json error' do
          expect { JsonSlide::Parser.parse("invalid_json") }.to raise_error("Invalid JSON Format!! Please enter a valid json string or json file with path or json file url.")
        end
      end
    end

    context 'json file is given as argument' do
      context 'and its valid' do
        it "parses the json file" do
          allow(File).to receive(:exist?).with('test.json').and_return(true)
          allow(File).to receive(:file?).with('test.json').and_return(true)
          expect(File).to receive(:read).with('test.json').and_return("{\"slide1\":{},\"slide2\":{}}")
          expect(JsonSlide::Parser.parse("test.json")).to eq({slide1: {}, slide2: {}})
        end
      end
      context 'and its invalid' do
        it 'raises Invalid json error' do
          expect { JsonSlide::Parser.parse("invalid_json_file.json") }.to raise_error("Invalid JSON Format!! Please enter a valid json string or json file with path or json file url.")
        end
      end
    end

    context 'json url is given as argument' do
      context 'and its valid' do
        it "parses the json content in the specified url" do
          allow(RestClient).to receive(:get).with('http://my_awesome_slides.json').and_return("{\"slide1\":{},\"slide2\":{}}")
          expect(JsonSlide::Parser.parse("http://my_awesome_slides.json")).to eq({slide1: {}, slide2: {}})
        end
      end
      context 'and its invalid' do
        it 'raises Invalid json error' do
          expect { JsonSlide::Parser.parse("http://do_not_exist/some.json") }.to raise_error("Invalid JSON url!! Please enter a valid json string or json file with path or json file url.")
        end
      end
    end

  end

end
