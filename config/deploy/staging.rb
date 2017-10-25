# Server Roles
# ==================

role :web,    %w(rails@colmex.staging.server)
role :app,    %w(rails@colmex.staging.server)
role :db,     %w(rails@colmex.staging.server)

# Rails Environment
# ======================

set :rails_env, 'production'
