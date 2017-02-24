# Server Roles
# ==================

# role :web,    %w(rails@lib-wit1rub-v03.lib.ohio-state.edu)
# role :app,    %w(rails@lib-wit1rub-v04.lib.ohio-state.edu rails@lib-wit1rub-v05.lib.ohio-state.edu)
# role :db,     %w(rails@lib-wit1rub-v03.lib.ohio-state.edu)

role :web,    %w(root@174.138.73.166)
role :app,    %w(root@174.138.73.166)
role :db,     %w(root@174.138.73.166)

root@174.138.73.166
# Rails Environment
# ======================

set :rails_env, 'production'
