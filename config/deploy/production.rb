# Server Roles
# ==================
# Colmex debería configurar un usuario de rieles en lugar de ejecutar todo como root. De los documentos de Capistrano: Capistrano está diseñado para implementarse utilizando un único usuario SSH no privilegiado, utilizando una sesión SSH no interactiva. Si su implementación requiere sudo, solicitudes interactivas, autenticarse como un usuario pero ejecutar comandos como otro, probablemente pueda lograr esto con Capistrano, pero puede ser difícil. Sus implementaciones automatizadas serán mucho más suaves si puede evitar tales requisitos.
# https://github.com/capistrano/capistrano/blob/master/README.md

# role :web,    %w(rails@repositorio.colmex.mx)
# role :app,    %w(rails@repositorio.colmex.mx rails@repositorio.colmex.mx)
# role :db,     %w(rails@repositorio.colmex.mx)

role :web,    %w(root@172.16.40.92)
role :app,    %w(root@172.16.40.92)
role :db,     %w(root@172.16.40.92)

# Rails Environment
# ======================

set :rails_env, 'production'
