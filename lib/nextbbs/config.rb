
module Nextbbs
  class Config
    DEFAULT_CURRENT_USER = proc { }
    DEFAULT_AUTHENTICATE = proc { }
    DEFAULT_AUTHORIZE_WITH = proc { }
    DEFAULT_AUDIT_WITH = proc { }

    attr_accessor :bbs_name
    attr_accessor :compatible_2ch
    attr_accessor :owner_model

    def initialize
      @bbs_name = "Nextbbs"
      @compatible_2ch = true
      @authenticate = DEFAULT_AUTHENTICATE
    end

    ##################################################
    # Authenticate(認証)
    ##################################################
    # @example Nextbbs
    #   Nextbbs.configure do |config|
    #     config.current_user_method do
    #       current_user
    #     end
    #   end
    def current_user_method(&block)
      @current_user = block if block
      @current_user || DEFAULT_CURRENT_USER
    end

    # @example Nextbbs
    #   Nextbbs.configure do |config|
    #     config.authenticate_with do
    #       authenticate_user!
    #     end
    #   end
    #   OR..
    #   Nextbbs.configure do |config|
    #     config.authenticate_with do
    #       warden.authenticate! scope: :user
    #     end
    #   end
    def authenticate_with(&block)
      @authenticate = block if block
      @authenticate || DEFAULT_AUTHENTICATE
    end

    ##################################################
    # Authorization(認可)
    ##################################################
    # @example Nextbbs
    #   Nextbbs.configure do |config|
    #     config.authorize_with do
    #           redirect_to main_app.root_path unless current_user.is_admin?
    #     end
    #   end
    #   OR..
    #   Nextbbs.configure do |config|
    #     config.authorize_with :pundit
    #   end
    #
    # def authorize_with(*args, &block)
    #   extension = args.shift
    #   if extension
    #     # シンボルで指定された場合
    #     klass = Nextbbs::AUTHORIZATION_ADAPTERS[extension]
    #     klass.setup if klass.respond_to? :setup
    #     @authorize = proc do
    #       @authorization_adapter = klass.new(*([self] + args).compact)
    #     end
    #   elsif block
    #     # ブロックで指定された場合
    #     @authorize = block
    #   end
    #   @authorize || DEFAULT_AUTHORIZE
    # end

    ##################################################
    # Auditing(監査)
    ##################################################
    # def audit_with(&block)
    #   @audit_with = block if block
    #   @audit_with || DEFAULT_AUDIT_WITH
    # end
  end
end
