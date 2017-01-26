require 'sidekiq/web'

Rails.application.routes.draw do
  Hydra::BatchEdit.add_routes(self)
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :oai_provider, BlacklightOaiProvider::Routes::Provider.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  mount CurationConcerns::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'sufia/homepage#index'
  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new
  resources :featured_collections
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  get '/gatekeeper/:ident', to: 'iiif_gatekeeper#show', as: 'gatekeeper', constraints: { ident: /[-A-Za-z0-9_\.\/]+/ }

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :import_field_mappings

  resources :imports do
    member do
      post 'start'
      post 'undo'
      post 'resume'
      post 'finalize'
      get 'report'
      get 'image_preview/:row', controller: 'imports', action: :image_preview, as: 'image_preview'
      get 'row-preview/:row_num', controller: 'imports', action: :row_preview, as: 'row_preview'
    end

    collection do
      post 'browse'
    end
  end

  Hydra::BatchEdit.add_routes(self)

  resources :units
  resources :memberships, only: :destroy

  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => '/jobs'
  end

  # Handle routes that existed in Sufia < 7
  #   e.g. https://library.osu.edu/ims/files/gm80hv36p
  get '/files/:id', to: redirect('concern/generic_works/%{id}')

  # Disable Sufia contact, help, and about pages
  get '/about', to: 'application#not_found'
  get '/contact', to: 'application#not_found'
  get '/help', to: 'application#not_found'

  # API
  namespace :api, defaults: { format: :json }, constraints: { format: /(json|xml)/ } do
    api_version(module: "v1",
                path: { value: "v1" },
                header: { name: "Accept", value: "application/vnd.library.osu.edu; version=1" },
                default: true) do

      concerns :oai_provider, path: '/oai', controller: 'oai', format: 'xml'
    end
  end

  # This must be the very last route in the file because it has a catch-all route for 404 errors.
  # This behavior seems to show up only in production mode.
  mount Sufia::Engine => '/'

  # Add Units tab to the dashboard
  Sufia::Engine.routes.draw do
    scope :dashboard do
      get '/units',            controller: 'my/units', action: :index, as: 'dashboard_units'
      get '/units/page/:page', controller: 'my/units', action: :index
      get '/units/facet/:id',  controller: 'my/units', action: :facet, as: 'dashboard_units_facet'
    end
  end
end
