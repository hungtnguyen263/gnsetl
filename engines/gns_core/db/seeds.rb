# Create default admin user for developing
puts "Create default admin user"
GnsCore::User.create(
  email: "hungnt.fit@gmail.com",
  password: "aA456321@"
) if GnsCore::User.where(email: "hungnt.fit@gmail.com").empty?