# Foreman startup scripts
# For use in development ONLY!

redis: bin/redis_dev
sidekq: sleep 5; bundle exec sidekiq -e development -q default -q ingest -q event -C ./config/sidekiq.yml
solr: solr_wrapper -d solr/config/ --collection_name hydra-development
fedora: fcrepo_wrapper -p 8984
