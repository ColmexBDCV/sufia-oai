# Server Roles
# ==================

role :web,    %w(rails@lib-wit1rub-v03.lib.ohio-state.edu)
role :app,    %w(rails@lib-wit1rub-v04.lib.ohio-state.edu)
role :db,     %w(rails@lib-wit1rub-v03.lib.ohio-state.edu)

# Rails Environment
# ======================

set :rails_env, 'production'
set :assets_prefix, 'dc/assets'
set :paperclip_relative_root, 'dc'

namespace :deploy do
  before :publishing, 'paperclip:symlink_attachments'
end
