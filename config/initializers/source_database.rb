SOURCE_DB = YAML.load_file(File.join(Rails.root, "config", "source_database.yml"))[Rails.env.to_s]