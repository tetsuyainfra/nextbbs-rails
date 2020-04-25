require 'nextbbs/extensions/pundit/authorization_adapter'

Nextbbs.add_extension(:pundit, Nextbbs::Extensions::Pundit, authorization: true)