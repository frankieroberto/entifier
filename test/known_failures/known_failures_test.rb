require 'test_helper'

class KnownFailuresTest < Test::Unit::TestCase
  
  should "not extract 'Hawaii' as we don't know that this is a proper known" do
    assert !Entifier.extract("Hawaii basketball coach Bob Nash has agreed to a one-year").include?('Hawaii')
  end  
  
  should "not extract Vietnam" do
    assert !Entifier.extract("Around the country, Masses at Catholic churches are heavily attended.  Vietnam has often come under international criticism for its record on religious and human rights.").include?('Vietnam')
  end  

end