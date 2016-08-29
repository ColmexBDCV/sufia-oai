namespace :load do
  task :defaults do
    set :paperclip_role, :web
    set :paperclip_relative_root, false
    set :paperclip_directory, 'system'
  end
end

namespace :paperclip do
  task :symlink_attachments do
    on roles(fetch(:paperclip_role)) do
      if fetch(:paperclip_relative_root)
        paperclip_path = File.join(release_path, 'public', fetch(:paperclip_directory))
        relative_path = File.join(release_path, 'public', fetch(:paperclip_relative_root), fetch(:paperclip_directory))
        execute :ln, "-s", paperclip_path, relative_path
      end
    end
  end
end
