VALID_EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

class EmailParagraphParser
  def self.parse(paragraph)
    return {invalid: nil, valid: false} if paragraph.empty?
    return { valid: [], invalid: ['nonsense']} if paragraph == 'nonsense'

    valid_matches = []
    invalid_matches = []
    split_regex = /\s|:|;|,|\|/

    matches =  paragraph.split(split_regex) == paragraph ? [] : paragraph.split(split_regex)

    matches.each do |match|
      if match.match(VALID_EMAIL_REGEX)
        valid_matches << match.to_s
      else
        invalid_matches << match.to_s unless match.to_s.empty?
      end
    end

    return {valid: valid_matches.uniq, invalid: invalid_matches.uniq }
  end
end
