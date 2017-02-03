require_relative '../email_paragraph_parser'

RSpec.describe EmailParagraphParser do
  subject { described_class }

  describe 'class interface' do
    it { is_expected.to respond_to(:parse).with(1).argument }
  end

  describe "ClassMethod#parse" do
    xit 'returns a hash with :valid, :invalid keys' do
      expect( subject.parse("") ).to have_key(:invalid)
      expect( subject.parse("") ).to have_key(:valid)
    end
    xit 'returns an empty array when there are no valid emails in the paragraph' do
      expect( subject.parse("nonsense") ).to eq({ valid: [], invalid: ["nonsense"]})
    end
    xit 'returns an array of valid emails when contained in paragraph' do
      expect( subject.parse("j@ap.co") ).to eq({ valid: ["j@ap.co"], invalid: []})
    end
    xit 'returns an array of valid emails: comma-separated list' do
      paragraph = "j@ap.co,d@ap.co,t@ascension.com"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ascension.com"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: pipe-separated list' do
      paragraph = "j@ap.co|d@ap.co|t@ascension.com"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ascension.com"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: semicolon-separated list' do
      paragraph = "j@ap.co;d@ap.co; t@ascension.com"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ascension.com"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: colon-separated list' do
      paragraph = "j@ap.co:d@ap.co: t@ascension.com"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ascension.com"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: space-separated list' do
      paragraph = "j@ap.co d@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: comma-space-separated list' do
      paragraph = "j@ap.co, d@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: paragraph-separated list' do
      paragraph = "j@ap.co\nd@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails: return-separated list' do
      paragraph = "j@ap.co\rd@ap.co\rt@a.com"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@a.com"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given inconsistently separated list' do
      paragraph = "j@ap.co, d@ap.co,t@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when mixed with valid ones' do
      paragraph = "j@ap.co, david@ascensioncom, t@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "t@ap.co"],
        invalid: ["david@ascensioncom"]
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: commas' do
      paragraph = ",j@ap.co,, ,d@ap.co,t@ap.co,"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: new-lines' do
      paragraph = "\n\n\nj@ap.co\n\n\n\n\n\n\n\n\nd@ap.co\n\nt@ap.co\n"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: returns' do
      paragraph = "\r\r\rj@ap.co\r\r\r\r\r\r\r\r\rd@ap.co\r\rt@ap.co\r"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: spaces' do
      paragraph = "j@ap.co,   d@ap.co,t@ap.co  "
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: spaces' do
      paragraph = "   j@ap.co   d@ap.co t@ap.co  "
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns an array of valid emails when given extra punctuation: spaces+commas' do
      paragraph = " ,  j@ap.co ,,,  ,d@ap.co , ,,"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'returns valid emails when given extra punctuation: returns+new-lines' do
      paragraph = "\n\n\rj@ap.co\n\r\n\r\r\r\n\r\rd@ap.co\r\nt@ap.co\r"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns valid emails when given extra punctuation: returns+new-lines+commas' do
      paragraph = "\n,\n\rj@ap.co,\n\r\n\r,,,\r\r\n\r\rd@ap.co,\r\nt@ap.co,,,,\r"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'returns valid emails when given extra punctuation: returns + new-lines + commas + spaces' do
      paragraph = "    \n,\n\r   j@ap.co,    \n\r \n\r,  ,,\r\r  \n\r\r    d@ap.co,\r\nt@ap.co     ,,       ,,\r"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co", "t@ap.co"],
        invalid: []
      )
    end
    xit 'removes duplicate emails' do
      paragraph = "j@ap.co d@ap.co j@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'removes duplicate emails: multiple repeats' do
      paragraph = "j@ap.co d@ap.co j@ap.co d@ap.co j@ap.co j@ap.co"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: []
      )
    end
    xit 'removes duplicate emails: invalid repeats' do
      paragraph = "j@ap.co d@ap.co j@apco d@ap.co j@apco j@apco"
      expect(
        subject.parse(paragraph)
      ).to eq(
        valid: ["j@ap.co", "d@ap.co"],
        invalid: ["j@apco"]
      )
    end
  end

end
