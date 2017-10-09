# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
end

Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.
Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
  Movie.create!(movie)
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    arg1_list = arg1.split(/,\W/)
    arg1_list.each do |rating|
        check("ratings_#{rating}")
    end
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    arg1_list = arg1.split(/,\W/)
    arg1_list.each do |rating|
        movies = Movie.where("rating = ?", rating)
        movies.each do |movie|
            page.should have_content("#{movie.title}")
        end
    end
end

Then /^I should see all of the movies$/ do
    page.all("table tbody tr").count.should == Movie.count
    Movie.all.each do |movie|
		page.should have_content("#{movie.title}")
	end
end

When /I follow "Movie Title"/ do
     click_link('title_header')
end

When /I follow "Release Date"/ do
     click_link('release_date_header')
end

Then /I should see "(.*)" before "(.*)"/ do |movie1, movie2|
        (page.body.index(movie2) > page.body.index(movie1)).should be true
end



