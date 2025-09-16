namespace :app do
  desc "Create demo tenants with users and board"
  task setup: :environment do
    puts "Seeding tenants and demo data..."

    tenants = [
      {
        name: "gmail",
        domain: "gmail.local",
        db_name: "kanban_gmail"
      },
      {
        name: "apple",
        domain: "apple.local",
        db_name: "kanban_apple"
      }
    ]

    tenants.each do |t|
      tenant = Tenant.find_or_create_by!(name: t[:name]) do |tenant|
        tenant.domain = t[:domain]
        tenant.db_name = t[:db_name]
        tenant.db_config = {
          "host"     => "db",
          "adapter"  => "mysql2",
          "encoding" => "utf8mb4",
          "pool"     => 5,
          "username" => "root",
          "password" => "root"
        }
        tenant.active = true
      end

      puts "✅ Created tenant #{tenant.name}"

      unless ActiveRecord::Base.connection.execute("SHOW DATABASES LIKE '#{tenant.db_name}'").any?
         Apartment::Tenant.create(tenant.db_name)
      end


      Apartment::Tenant.switch(tenant.db_name) do
        ActiveRecord::MigrationContext.new("db/migrate").migrate
        puts "🚚 Migrated tenant #{tenant.db_name}"
        user1 = User.find_or_create_by!(email: "user1@#{tenant.name}.com") do |u|
          u.name = "User One"
          u.password = "Password123"
          u.password_confirmation = "Password123"
        end

        user2 = User.find_or_create_by!(email: "user2@#{tenant.name}.com") do |u|
          u.name = "User Two"
          u.password = "Password123"
          u.password_confirmation = "Password123"
        end

        puts "👤 Created users #{user1.email}, #{user2.email} in #{tenant.db_name}"

        board = Board.find_or_create_by!(title: "Demo Board", user: user1) do |b|
         b.description = "Default board for #{tenant.name}"
        end

        puts "📋 Created demo board in #{tenant.db_name}"
      end
    end

    puts "🎉 Setup completed!"
  end
end
