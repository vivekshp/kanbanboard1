FROM ruby:3.2

# Install dependencies including MySQL
RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev nodejs


# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]
