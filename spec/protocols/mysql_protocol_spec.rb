require 'spec_helper'
require 'db_wrapper/protocols/mysql_protocol'

describe DBWrapper::MysqlProtocol do
  let(:protocol) { DBWrapper::MysqlProtocol }

  describe 'parse_command - removing non-sql data' do
    def test_parse(clean_string, dirty_string)
      expect(protocol.parse_command(dirty_string)).to eq clean_string
    end
    it 'parses a select command' do
      clean_string = 'select a from b'
      dirty_string = "\x10\x00\x00\x00\x03" + clean_string
      test_parse clean_string, dirty_string
    end

    it 'parses a insert command' do
      clean_string = 'insert into a(col1) values(1)'
      dirty_string = "\x1E\x00\x00\x00\x03" + clean_string
      test_parse clean_string, dirty_string
    end

    it 'parses a update command' do
      clean_string = "update a set col1 = 'val1' where col1 > 1"
      dirty_string = "*\x00\x00\x00\x03" + clean_string
      test_parse clean_string, dirty_string
    end
  end

end