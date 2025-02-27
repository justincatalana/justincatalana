# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'

Picture.destroy_all

dimensions = [ 200, 300, 400, 500 ]

50.times do |i|
  width = dimensions.sample
  height = dimensions.sample

  picture = Picture.create!(
    description: "This is a randomly generated photo with size #{width}x#{height}"
  )

  picture.image.attach(
    io: URI.open("https://picsum.photos/seed/#{SecureRandom.hex}/#{width}/#{height}"),
    filename: "photo_#{i + 1}.jpg",
    content_type: "image/jpeg"
  )
end

Post.destroy_all

20.times do |i|
  post = Post.create!(title: Faker::Book.title)

  paragraphs = Faker::Lorem.paragraphs(number: 4).map { |para| "<p>#{para}</p>" }.join

  image_url = "https://picsum.photos/seed/#{SecureRandom.hex}/800/400"
  image_tag = "<img src='#{image_url}' alt='Random Image'>"

  content = "#{image_tag}#{paragraphs}"

  post.description = ActionText::Content.new(content)
  post.save!
end
