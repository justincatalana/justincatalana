# lib/tasks/list_media_info.rake

namespace :import do
  desc "List unique file extensions and root directories from media URIs"
  task list_media_info: :environment do
    require "json"
    require "set"

    # Path to your JSON file (adjust as needed)
    json_file = Rails.root.join("import_data", "instagram_posts.json")
    unless File.exist?(json_file)
      puts "JSON file not found: #{json_file}"
      exit
    end

    posts = JSON.parse(File.read(json_file))

    # Use sets to store unique extensions and root directories
    extensions = Set.new
    root_directories = Set.new

    posts.each do |post|
      next unless post["media"].is_a?(Array)

      post["media"].each do |media|
        uri = media["uri"]

        # Extract file extension (without the dot) and downcase it
        ext = File.extname(uri).delete(".").downcase
        extensions.add(ext) unless ext.empty?

        # Split the URI by "/" and add the first segment as the root directory
        parts = uri.split("/")
        root_directories.add(parts.first) if parts.any?
      end
    end

    puts "Unique File Extensions:"
    extensions.each { |ext| puts ext }

    puts "\nUnique Root Directories:"
    root_directories.each { |dir| puts dir }
  end
end
