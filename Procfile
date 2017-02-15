# Foreman startup scripts
# For use in development ONLY!

redis: bin/redis_dev
sidekq: sleep 5; bundle exec sidekiq -e development
solr: solr_wrapper -d solr/config/ --collection_name hydra-development
fedora: fcrepo_wrapper -p 8984
