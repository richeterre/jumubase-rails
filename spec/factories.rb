Factory.define :user do |u|
  u.username               "user"
  u.password               "user"
  u.password_confirmation  "user"
  u.admin                  false
end

Factory.define :admin, :class => :user do |a|
  a.username               "admin"
  a.password               "admin"
  a.password_confirmation  "admin"
  a.admin                  true
end