require 'test_helper'
require 'pp'
class PAErrorsTest < Test::Unit::TestCase



  # PA File : eAP-D979UPS01.eAP-NA-US-GM-Labor-Costs.nitf.xml
  should "extract 'Treasury Department'" do
    assert Entifier.extract("to the Treasury Department Tuesday").include?('Treasury Department')
  end

  # PA File : eAP-D979UI0O1.eAP-EU-Obama-Queen-apos-s-Song-List.nitf.xml
  should "treat quotes as one string ? i.e. we shouldn't extract Dolly here" do
    assert !Entifier.extract('Hello, Dolly!" Carol Channing').include?('Dolly')
  end

  should "not treat quote mark as ending a sentence" do
    assert_equal "Frankie", Entifier.extract("\"This should work\" Frankie said.").first
  end

# ----

  should "not extract Feb" do
    assert !Entifier.extract('Nazir had previously allied with the Pakistani government to fight Uzbeks partnered with the international terrorist group.  The Feb. 22 communique, a copy of which was obtained by The Associated Press, announced the ').include?('Feb')
  end

  should "not extract Die" do
    assert !Entifier.extract('FunnyOrDie.com, the comedy video Web site co-founded by Will Ferrell, announced that it had been bought by country star Reba McEntire. The site was temporarily renamed "Reba or Die" and its home page was populated entirely with videos featuring McEntire').include?('Die')
  end
  

text = <<PA
President Barack Obama's gift of an iPod to Queen Elizabeth II came loaded with 40 songs from popular Broadway productions, including "The King and I," "West Side Story" and "Dreamgirls." The iPod was given to accompany a rare coffee table book of songs by composers Richard Rodgers and Lorenz Hart, which Obama also gave the queen.  Songs on the iPod are:  "Oklahoma!"  "If I Loved You," Jan Clayton, "Carousel"  "You'll Never Walk Alone," Jan Clayton, "Carousel"  "There's No Business Like Show Business," Ethel Merman, "Annie Get Your Gun"  "Once in Love with Amy (Where's Charley?)," Ray Bolger  "Some Enchanted Evening," "South Pacific"  "Diamonds Are a Girl's Best Friend," Carol Channing, "Gentlemen Prefer Blondes"  "Getting to Know You," Gertrude Lawrence, "The King and I"  "Shall We Dance?" Gertrude Lawrence, "The King and I"  "I Could Have Danced All Night," Julie Andrews, "My Fair Lady"  "I've Grown Accustomed to Her Face," Rex Harrison, "My Fair Lady"  "The Party's Over (Bells Are Ringing)," Judy Holliday  "Maria," "West Side Story"  "Tonight," "West Side Story"  "Seventy Six Trombones," "The Music Man"  "Everything's Coming up Roses," Ethel Merman, "Gypsy"  "The Sound of Music"  "Try to Remember," Jerry Orbach, "The Fantasticks"  "Camelot," Richard Burton  "If Ever I Would Leave You," Robert Goulet, "Camelot"  "Hello, Dolly!" Carol Channing  "If I Were a Rich Man," Zero Mostel, "Fiddler on the Roof"  "People," Barbra Streisand, "Funny Girl"  "On a Clear Day (You Can See Forever)," John Cullum  "The Impossible Dream," Richard Kiley, "Man of La Mancha"  "Mame," Charles Braswell  "Cabaret," Liza Minnelli  "Aquarius, Ronald Dyson, "Hair'  "Send in the Clowns," Judy Collins, "A Little Night Music"  "All That Jazz," Chita Rivera, "Chicago"  "One," "A Chorus Line"  "Tomorrow," Andrea McArdle, "Annie"  "Don't Cry for Me Argentina," Patti LuPone, "Evita"  "And I Am Telling You I'm Not Going," Jennifer Holliday, "Dreamgirls"  "Memory," Elaine Paige, "Cats"  "The Best of Times," George Hearn, "La Cage Aux Folles"  "I Dreamed a Dream," Aretha Franklin, "Les Miserables"  "The Music of the Night," Michael Crawford, "The Phantom of the Opera"  "As If We Never Said Goodbye," Elaine Paige, "Sunset Blvd."  "Seasons of Love," "Rent"
PA

  should "extract 'Ethel Merman'" do
    assert Entifier.extract(text).include?('Ethel Merman')
  end


  should "extract 'Christine Lord'" do
    assert Entifier.extract('This would be an added extra, outside their legal framework." But he added it could also be a question of money. "It may well be that it could be done but for it to be done the coroners would have to be given more resources than they are presently being given" Christine Lord, whose son died nearly two years ago of vCJD, urged coroners to carry out the tests as it had the potential to "save lives".').include?('Christine Lord')
  end


  #The video, which is on YouTube and the website of the multimedia magazine Don't Panic, which Prowse edits, has become a hit. It is entitled "Pound Force — Alan Duncan MP gets a new garden feature".
  should "extract 'Don't Panic'" do
    assert Entifier.extract('The video, which is on YouTube and the website of the multimedia magazine Don\'t Panic, which Prowse edits, has become a hit.').include?("Don't Panic")
  end

  should "extract 'Pound Force'" do
    assert Entifier.extract('has become a hit. It is entitled \"Pound Force — Alan Duncan MP gets a new garden feature Panic').include?('Pound Force')
  end

  should "extract 'Ian Trow" do
    assert Entifier.extract('. Ian Trow, 42, of Deanshanger, Milton Keynes, Buckinghamshire, and a').include?('Ian Trow')
  end

end
