require 'redis'
redis_config = YAML.load(ERB.new(IO.read(File.join(Rails.root, 'config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
Redis.current = Redis.new(redis_config.merge(thread_safe: true))

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Redis.current.client.location}/#{Redis.current.client.db}" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Redis.current.client.location}/#{Redis.current.client.db}" }
end