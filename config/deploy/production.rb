# Server Roles
# ==================

role :app,    %w(rails@lib-wit1rub-v02.lib.ohio-state.edu)
role :web,    %w(rails@lib-wit1rub-v02.lib.ohio-state.edu)
role :db,     %w(rails@lib-wit1rub-v02.lib.ohio-state.edu)

# Rails Environment
# ======================

set :rails_env, 'production'
set :assets_prefix, 'dcs/assets'
