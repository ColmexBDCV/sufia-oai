# Server Roles
# ==================

role :web,    %w(rails@lib-wit2rub-v03.lib.ohio-state.edu)
role :app,    %w(rails@lib-wit2rub-v04.lib.ohio-state.edu)
role :db,     %w(rails@lib-wit2rub-v03.lib.ohio-state.edu)

# Rails Environment
# ======================

set :rails_env, 'production'
