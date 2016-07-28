require 'redis'
config = YAML.load(ERB.new(IO.read(File.join(Rails.root, 'config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
puts config
Redis.current = Redis.new(config.merge(thread_safe: true))
