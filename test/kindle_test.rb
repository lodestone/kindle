require_relative "../lib/kindle"

describe "Kindle" do

  def login; "jo@nx.is"; end
  def password; "seekrut1"; end

  it "should be doing generally okay" do
    expect { Kindle::HighlightsParser.new(login: login, password: password) }.not_to raise_error
  end

  it 'does something' do
    khp = Kindle::HighlightsParser.new(login: login, password: password)
    expect { khp.get_highlights }.to_not raise_error
  end

end
