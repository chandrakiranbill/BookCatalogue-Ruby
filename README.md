# BookCatalogue-Ruby

To run the web interface version of the Book Catalog System: 

1. Make sure you have ruby(3<=) and required dependencies installed

      brew install rbenv ruby-build
      rbenv init
      add this line to your .zshrc : eval "$(rbenv init - zsh)"
      source ~/.zshrc

      rbenv install 3.2.2
      rbenv global 3.2.2
      ruby -v (To verify the version)
      gem install bundler
      gem install sinatra
      gem install rack
      bundle add rackup puma


2. Navigate to the directory containing the project files and install required gems (first time only): 

     bundle install 

3. Start the web server: 

      ruby web_app.rb 

4. Open a web browser and navigate to: 

      http://localhost:8080 

5. Use the web interface to interact with the catalog system 
