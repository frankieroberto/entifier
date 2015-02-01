require 'helper'

class TestEntifier < Test::Unit::TestCase


  should "test_simple_name_at_start_of_string" do
    assert_equal "Frankie Roberto", Entifier.extract("Frankie Roberto did blah.").first
  end
  
  def test_simple_name_at_end_of_sentence
    assert_equal "Frankie Roberto", Entifier.extract("It was Frankie Roberto.").first
  end

  def test_simple_name_in_middle_of_string
    assert_equal "Frankie Roberto", Entifier.extract("If it was Frankie Roberto who did it.").first
  end

  def test_name_with_apostrophe
    assert_equal "Samantha Harvey", Entifier.extract("Samantha Harvey's first novel is...").first
  end
  
  def test_name_before_comma
    assert_equal "Frankie Roberto", Entifier.extract("Call me Frankie Roberto, said the...").first
  end
  
  def test_single_word_name_at_start_with_apostrophe
    assert_equal "Britain", Entifier.extract("Britain's nuclear capabilities...").first
  end
  
  def test_name_at_start_of_sentence
    assert_equal "Frankie Roberto", Entifier.extract("First sentence. Frankie Roberto is fun.").first
  end
  
  def test_single_word_name_at_start_of_sentence
    assert_equal "Britain", Entifier.extract("First sentence. Britain's nuclear capabilities...").first
  end
    
  def test_list_of_countries
    entities = Entifier.extract("The US, Canada, Spain, Britain and Israel have confirmed cases of the virus, but no deaths have been reported outside Mexico.")
    assert_equal 6, entities.size
    assert_equal "US", entities.first
    assert_equal "Mexico", entities.last
  end
  
  def test_WHO_example
    entities = Entifier.extract("World Health Organization deputy chief Keiji Fukuda was speaking...")
    assert_equal 2, entities.size
    assert_equal "World Health Organization", entities.first
    assert_equal "Keiji Fukuda", entities.last
  end
  
  def test_three_word_name
    assert_equal "Dr Keiji Fukuda", Entifier.extract("The expert Dr Keiji Fukuda said it").first
  end
  
  def test_four_word_name_at_start_of_string
    assert_equal "Mr Bob Jones Robert", Entifier.extract("Mr Bob Jones Robert said...").first
    
  end
  
  def test_name_containing_umlaut
    assert_equal "Albrecht Dürer", Entifier.extract("Albrecht Dürer is a famous artist.").first
  end
  
  def test_dont_include_capitalised_sentence_starts
    assert_equal 0, Entifier.extract("How now brown cow. Knees up mother brown.").size
  end
  
  def test_dont_include_capitalised_new_paragraph_starts
    assert_equal 0, Entifier.extract("How now brown cow.\n\nKnees up mother brown.").size
  end
  
  def test_name_containing_of
    assert_equal "Department of Health", Entifier.extract("If Department of Health is looking").first
  end
  
  def test_name_containing_of_in_middle_of_string
    assert_equal "Department of Health", Entifier.extract("It has been reported that the Department of Health is looking").first
  end
  
  def test_name_continaing_in_in_middle_of_string
    assert_equal "Intergovernmental Panel on Climate Change", Entifier.extract("At the Intergovernmental Panel on Climate Change, experts said...").first
  end
  
  def test_sentence_starting_with_in
    assert_equal "Northern Ireland", Entifier.extract("In Northern Ireland the chief").first
  end
  
  def test_name_including_hypen
    assert_equal "Mr Rory-Jones", Entifier.extract("He said to Mr Rory-Jones that").first
  end

  def test_dont_include_day_names
    assert_equal 0, Entifier.extract("She was born on Thursday.").size
  end

  def test_dont_include_month_names
    assert_equal 0, Entifier.extract("She was born in September.").size
  end
  
  def test_dont_include_its
    assert_equal 0, Entifier.extract("It's not too late to...").size
  end
  
  def test_names_at_beginning_and_end_of_sentences
    entities = Entifier.extract("He lived in London. Frankie Roberto is his name.")
    assert_equal 2, entities.size
    assert_equal "London", entities.first
    assert_equal "Frankie Roberto", entities.last

  end
  
  def test_abbreviation_with_numeral
    assert_equal "G8", Entifier.extract("At the G8 meeting last week...").first
  end
  
  def test_event_preceeded_by_year
    assert_equal "2012 Olympics", Entifier.extract("At the 2012 Olympics, someone will win.").first
  end
  
  def dont_test_abbreviation_at_start_of_string_yet
    assert_equal "US", Entifier.extract("USA officials have urged...").first
  end  
  
  def test_name_with_of_followed_by_two_words
    assert_equal "Department of Clinical Health", Entifier.extract("At the Department of Clinical Health, people were...").first
  end
  
  should "double quoted name" do
    assert_equal "Demon Crossroads", Entifier.extract("At the place they call the \"Demon Crossroads\", two people met...").first
  end

  should "single quoted name" do
    assert_equal "Demon Crossroads", Entifier.extract("At the place they call the 'Demon Crossroads', two people met...").first
  end
  
  should "name starting paragraph after header" do
    assert_equal "Britain", Entifier.extract("Worrying times\n\nBritain's nuclear capabilities...").first
  end

  should "name after sentence ending in question mark" do
    assert_equal "Frankie Roberto", Entifier.extract("Who's the daddy? Frankie Roberto is.").first
  end
  
  should "don't include capitalised word after questions mark" do
    assert_equal 0, Entifier.extract("Who's the daddy? What a tricky question.").size
  end

  should "don't include capitalised word after exclaimation mark" do
    assert_equal 0, Entifier.extract("Oh look! How peculiar.").size
  end
  
  should "name including 'of the'" do
    assert_equal "Horseman of the Apocalypse", Entifier.extract("In the Horseman of the Apocalypse...").first
  end
  
  should "name included twice" do 
    assert_equal 1, Entifier.extract("Frankie Roberto was a man. Frankie Roberto was a mouse.").size
  end
    
  should "ignore extra spaces betwen capitalised words" do
    assert_equal "Schools Secretary", Entifier.extract("the Schools  Secretary is...").first
  end

  should "ignore space before two newlines" do
    assert_nil Entifier.extract("A sentence.\s\n\nA new sentence.").first
  end
  
  should "allow entity with 'for' in it" do
    assert_equal "Deputy Mayor for Government", Entifier.extract("The office of Deputy Mayor for Government is important.").first
  end
    
  should "ignore quote marks at the start of a sentence" do
    assert_nil Entifier.extract("\"Blindly, he walked forwards\"").first
  end    
    
  should "ignore 'if' at the beginning of a sentence" do
    assert_equal "Frankie Roberto", Entifier.extract("If Frankie Roberto can do something.").first
  end  
    
  should "allow entities to end in a number" do
    assert_equal "BBC 1", Entifier.extract("And now, on BBC 1, it's...").first
  end
    
  should "treat a double line break as starting a new sentence" do
    assert_nil Entifier.extract("the end\n\nThe start").first
  end

  should "treat a single line break as starting a new sentence" do
    assert_nil Entifier.extract("the end\nThe start").first
  end

  should "treat full-stop followed by quote mark as starting a new sentence" do
    assert_nil Entifier.extract("process.\"  'Emerging threats").first
  end

  should "not treat quote mark followed by a comma as ending a sentence" do
    assert_equal "Frankie", Entifier.extract("\"This should work\", Frankie said.").first
  end

  should "include words with accented e character" do
    assert_equal "Béarn", Entifier.extract("I live in Béarn.").first
  end
  
  should "include words with tilded n character" do 
    assert_equal "El Niño", Entifier.extract("He's called El Niño.").first
  end
  
  should "include words with funny characters" do
    assert_equal "Bjørn Dæhlie", Entifier.extract("He's called Bjørn Dæhlie").first
  end
  
  should "include words starting with haloed A" do
    assert_equal "Anders Jonas Ångström", Entifier.extract("His name is Anders Jonas Ångström.").first
  end
  
  should "include words starting with umlauted O" do
    assert_equal "Öland", Entifier.extract("I live in Öland.").first
  end
  
  should "pick out a phrases with 'for' in it at the start of a sentence" do
    assert_equal "Department for Transport", Entifier.extract("The Department for Transport has finished...").first
  end
  
  should "ignore but at the start of sentence" do 
    assert_equal "Foreign Secretary David Miliband", Entifier.extract("But Foreign Secretary David Miliband said that...").first
  end
  
  should "ignore months" do
    assert_nil Entifier.extract("In the month of April 2008 bad things happened.").first
  end
  
  should "pick out abbreviations including ampersand" do
    assert_equal "C&A", Entifier.extract("I used to shop at C&A.").first
  end
    
  should "not include 'on Tuesday' as part of a phrase" do 
    assert_equal "Commons", Entifier.extract("In the Commons on Tuesday, the...").first
  end  
  
  should "not include 'On Friday' as an entity" do
    assert_nil Entifier.extract("On Friday, something happened.").first
  end
    
  should "detect single word entities after 'If' at the start of a sentence" do
    assert_equal "Frankie", Entifier.extract("If Frankie can do something.").first
  end    
  
  should "extract 'Florida'" do
    assert Entifier.extract("In Florida, Lynn Orr was waiting").include?('Florida')
  end  

  # PA File : eAP-D979UQDG0.eAP-Officers-Indicted-1st-Ld-Writethru.nitf.xml
  should "extract 'Baltimore'" do
    assert_equal 'Baltimore', Entifier.extract("Two Baltimore police officers beat").first
  end

  # PA File : eAP-D979UPS01.eAP-NA-US-GM-Labor-Costs.nitf.xml
  should "extract 'GM'" do
    assert_equal "GM", Entifier.extract("GM submitted a progress report").first
  end

  # PA File : eAP-D979UHQ01.eAP-CB-Puerto-Rico-Agitated-Passenger.nitf.xml
  should "extract FBI" do
    assert_equal "FBI", Entifier.extract('The FBI has arrested').first
  end

  # PA File : eAP-D979U4P03.eAP-Wall-Street-19th-Ld-Writethru.nitf.xml
  should "extract Russell 2000" do
    assert_equal ["Russell 2000"], Entifier.extract("The Russell 2000 index of smaller companies")
  end

  # PA File : PRN-3869490en-1.PRN-GXX-HEALTH-HPV-Testing-Study.nitf.xml
  should "extract 'Bill & Melinda Gates Foundation'" do
    assert_equal ["Bill & Melinda Gates Foundation"], Entifier.extract("Funded by the Bill & Melinda Gates Foundation.")
  end

  should "not include year after 'in'" do
    assert_equal "Appleton", Entifier.extract("In 1924 Appleton began...").first
  end

  should "extract April Fool's Day" do
    assert_equal ["April Fool's Day"], Entifier.extract(" was being tracked throughout April Fool's Day, more ")
  end
  
  should "ignore 'One of' at start of sentence" do
    assert_equal ["Britain"], Entifier.extract("One of Britain's best-known...")
  end
  
  should "not extract numbers" do
    assert_equal [], Entifier.extract("The 2-1 victory over...")
  end  
  
  should "extract 'Cap d' Antibes" do
    assert_equal ["Cap d' Antibes"], Entifier.extract("In Cap d' Antibes, ...")
  end  
  
  should "find entities at start and end of sentences" do
    assert_equal ["Frankie Roberto", "United Kingdom"], Entifier.extract("name was Frankie Roberto. United Kingdom was...")
  end

  should "not extract 'Dr'" do
    assert_equal ["Dr. Christopher Ziebell"], Entifier.extract("\"It's a pretty significant issue,\" said Dr. Christopher Ziebell, chief of the emergency department...")
  end
    
  should "extract 'B.J. Upton'" do
    assert_equal ["B.J. Upton"], Entifier.extract("The move won't be made until Sunday, when injured outfielders B.J. Upton and ...")
  end    
  
  should "extract Richard E. Grant" do
    assert_equal ["Richard E. Grant"], Entifier.extract("The film starred Richard E. Grant as...")
  end

  should "extract 'Fourie du Prez'" do
    assert_equal ["Fourie du Prez"], Entifier.extract("...looking forward to pitting his wits against experienced opposite number Fourie du Prez when the...")
  end

    
end
