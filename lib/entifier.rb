%w(extensions).each do |file|
  require File.join(File.dirname(__FILE__), 'entifier', file)
end

class Entifier

  DAY_NAMES = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
  MONTH_NAMES = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  INDEXICALS_PRECEDING_APOSTROPHE_S = ["Here", "There", "He", "She", "It", "Now", "Who"]

  def self.extract(string, options = {})
    options.nested_stringify_keys!
    
    entities = []
    
    # HACK! This allows comma separated entities to be picked up.
    # string.gsub!(/\,\s/, ",  ")  

    # HACK! This allows entities to be at the end and start of conjoining sentences.
    # string.gsub!(/\./, ".")   No longer needed

    # HACK! Remove extra spaces between sentences.
    #string.gsub!(/([\.\?\!])\s\s+/, "\1")    

    # Pre-processor: remove extra spaces (this shouldn't affect which entities are detected, 
    # it just makes the output look better)
    string.gsub!(/[[:blank:]]+/, "\s")

    # HACK! This allows parenthesized entity following other entity to be picked up.
    string.gsub!(/\s\(/, "  (")
     
    
     capitalised_word = /[ÄÅÖA-Z](?:[a-zA-ZÄÅÖÜàâæçéèêëîïôøöûùüÿñ\-\d\&]+|\.(?:[A-Z]\.)*)/
     capitalised_word_phrase = %r{
      (?:\d{4}\s|Dr\.\s)?
      #{capitalised_word}
      (?:
        (?:
          (?:\s+(?:of|for|on|of\sthe|\&|d\'|du|de)|\'s)
        )?
        \s+#{capitalised_word})*
      (?:\s\d+)?
    }x
     
    
    regex = %r{
      (?:
        (?:
        (?:\A|[\.\?\!\:][\"\']?\s+|\n)             # At start of string, or starting new sentence...
          (?:[\"\'\(])?                       # ...optionally started with quote marks.
          )
          (
            (?:In\s(?:\d{4}\s)?)? 
            #{capitalised_word_phrase}(?:\'s)? 
          )
        |                                   # --- OR ---

        [^\.\n\?\!\:\"][[:blank:]][\"\'\(]?           # After any non-full-stop followed by a space...                     

          (#{capitalised_word_phrase})
      )
    }x

    
    #[\,\'\s\.\Z]
    
    string.scan(regex) do |match|
      #entity = match
      if match[0]
        word_count = match[0].split(" ").size
        if word_count > 1
          entity = match[0].gsub(/\A(In(?:\s\d{4})?|The|If|But|Two|(?:One|Two)\sof)\s/, "").gsub(/\'s\Z/, "")
        elsif match[0][-2,2] == "'s"
          entity = match[0].gsub(/\'s\Z/, "")  
        elsif match[0] =~ /\A[A-Z]+\Z/        
          entity = match[0]
        else
          entity = nil
        end
      else
        entity = match[1]
      end
      
      # HACK: These should really be filtered out by the regex.
      if entity
       # entity = entity.strip.gsub(/\'s\Z/, "").gsub(/\AIn\s/, "").gsub(/\AIf\s/, "")
      end
      entity = nil if DAY_NAMES.include?(entity)
      entity = nil if MONTH_NAMES.include?(entity)
      entity = nil if INDEXICALS_PRECEDING_APOSTROPHE_S.include?(entity)
   
      
      if entity
        entity.gsub!( /((I|i)n\s)(January|Feburary|March|April|May|June|July|August|September|October|November|December)/, "")
        entity.gsub!( /(January|Feburary|March|April|May|June|July|August|September|October|November|December)\s(\d{4}|\d{2})/, "")
        entity.gsub!(/(O|\so)n\s(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)/, "")

        entity.gsub!(/\A\d+\Z/, "")   # Make string blank if it's just numbers.
        entity = nil if entity == ""  # If there's nothing left, make it nil.

      end
      
      
      entities << entity unless entity.nil?  # Don't collect the entity if it's nil
    end
    entities.uniq!
    return entities
  end

end