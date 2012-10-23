Rails.application.routes.draw do
  mount Emerson::Engine     => "/emerson"
  mount Jasminerice::Engine => "/jasmine"

  get 'jasmine/:suite' => 'jasminerice/spec#index'
end
