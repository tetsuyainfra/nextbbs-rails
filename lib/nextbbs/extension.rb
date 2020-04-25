
module Nextbbs
  EXTENSIONS = []
  AUTHORIZATION_ADAPTERS = {}

  def self.add_extension(extension_key, extension_definition, options = {})
    options.assert_valid_keys(:authorization)

    EXTENSIONS << extension_key

    if options[:authorization]
      AUTHORIZATION_ADAPTERS[extension_key] = extension_definition::AuthorizationAdapter
    end
  end

end # module Nextbbs

