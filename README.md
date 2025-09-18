#START

1.docker compose up -d

#SETUP

1.docker compose exec backend bash

2.rails db:create

3.rails db:migrate

4.rails app:setup -> {This creates-> Tenants: gmail, apple ; Users: user1@.com, user2@.com ; Demo board}
