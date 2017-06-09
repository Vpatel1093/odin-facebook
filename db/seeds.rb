user = User.create!(email:                 "exampleuser@example.com",
                    password:              "foobar",
                    password_confirmation: "foobar")

# Create users and make friends with user
10.times do |n|
  email = "example-#{n+1}@railstutorial.org"
  password = "foobar"
  password_confirmation = "foobar"
  new_user = User.create!(email: email,
                          password: password,
                          password_confirmation: password_confirmation)
  FriendRequest.create!(user: user, friend: new_user, accepted: true)
end

# Create profiles
users = User.all
users.each do |user|
  user.profile.update({first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name})
end

# Create friendships
users = User.all
1.upto(9) do |n|
  FriendRequest.create!(user: users[n], friend: users[n+1], accepted: true)
end
8.downto(1) do |n|
  FriendRequest.create!(user: users[n+2], friend: users[n], accepted: true)
end

# Create posts
user = User.all
users.each do |user|
  content = Faker::Lorem.sentence(1)
  user.posts.create(content: content)
end

#Create comments
users = User.all
users.each do |user|
  if user.added_friends.any?
    post_of_friend = user.added_friends.sample.posts.first
    content = Faker::Lorem.sentence(1)
    user.comments.create(post_id: post_of_friend.id, content: content)
  end
end

# Create likes
users = User.all
users.each do |user|
  if user.received_friends.any?
    post_of_friend = user.received_friends.sample.posts.first
    user.likes.create(likeable: post_of_friend)
  end
end
