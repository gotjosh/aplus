Rails.application.config.middleware.use OmniAuth::Builder do
  # Keep keys out of your Git repository! This uses environment variables from your
  # shell's configuration file (e.g., .zshrc if you're using zsh). You'll need lines
  # like
  # export WANTADS_TWITTER_KEY=a2dfOXZJgdfdsb888asdf
  # export WANTADS_TWITTER_SECRET=asdfabaj8834AFJDKFasdfasjjksdfsdlkljsdfsd
  # in your .zshrc file. In order to obatin your Twitter Key and Twitter Secret,
  # you need to first log into https://dev.twitter.com/ and create a new application
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end
