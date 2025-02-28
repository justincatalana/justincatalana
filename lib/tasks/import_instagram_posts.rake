# lib/tasks/import_instagram_posts.rake

namespace :import do
  desc "Import Instagram posts from JSON file"
  task instagram: :environment do
    require "json"

    json_file = Rails.root.join("import_data", "instagram_posts.json")
    unless File.exist?(json_file)
      puts "JSON file not found: #{json_file}"
      exit
    end

    Picture.destroy_all

    posts = JSON.parse(File.read(json_file))

    posts.each do |post|
      post["media"].each do |media|
        title = media["title"]
        creation_timestamp = media["creation_timestamp"]
        created_at = Time.at(creation_timestamp)
        media_uri = media["uri"]

        picture = Picture.create!(
          description: title,
          created_at: created_at
        )

        # Assuming the images/videos are in the 'public/media' directory.
        file_path = Rails.root.join("import_data", media_uri)
        unless File.exist?(file_path)
          puts "File not found: #{file_path}"
          next
        end

        File.open(file_path, "rb") do |file|
          ext = File.extname(file_path).delete(".").downcase
          content_type = case ext
          when "mp4"
                           "video/mp4"
          else
                           Rack::Mime::MIME_TYPES[".#{ext}"] || "application/octet-stream"
          end

          picture.image.attach(
            io: file,
            filename: File.basename(file_path),
            content_type: content_type
          )
        end

        puts "Imported Picture #{picture.id} from #{file_path}"
      end
    end

    puts "Import completed."
  end
end
