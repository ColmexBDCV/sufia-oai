# Server Roles
# ==================

role :app,    %w(rails@lib-wit3rub-v02.lib.ohio-state.edu)
role :web,    %w(rails@lib-wit3rub-v02.lib.ohio-state.edu)
role :db,     %w(rails@lib-wit3rub-v02.lib.ohio-state.edu)

# Rails Environment
# ======================

set :rails_env, 'production'
