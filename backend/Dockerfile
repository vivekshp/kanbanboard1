FROM ruby:3.2

# Install dependencies including MySQL
RUN apt-get update -qq && \
    apt-get install -y build-essential default-libmysqlclient-dev curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn


# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 3000
EXPOSE 3035

# Start the server
CMD ["bin/dev"]
