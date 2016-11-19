Rails.application.routes.draw do
  root 'code#index'

  get '/',          to: 'code#index'
  post '/',         to: 'code#index'
  get '/:id',       to: 'code#show'
  post '/save',     to: 'code#save'
end
