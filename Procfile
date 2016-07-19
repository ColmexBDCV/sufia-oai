# Foreman startup scripts
# For use in development ONLY!

redis: bin/redis_dev
sidekq: sleep 5; bundle exec sidekiq -e development
solr: bundle exec bin/solr_dev
fcrepo: bundle exec fcrepo_wrapper -p 8984
