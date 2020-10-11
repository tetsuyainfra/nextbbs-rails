module Nextbbs
  class Config
    DEFAULT_CURRENT_USER = proc { }
    DEFAULT_AUTHENTICATE = proc { }
    DEFAULT_AUTHORIZE_WITH = proc { }
    DEFAULT_AUDIT_WITH = proc { }
    DEFAULT_QUOTA_BOARD_WITHIN = proc { }

    attr_accessor :bbs_name
    attr_accessor :compatible_2ch
    attr_accessor :owner_model
    attr_accessor :auto_create_board
    attr_accessor :board_secret_hash
    attr_accessor :max_boards_count

    def initialize
      @bbs_name = "Nextbbs"
      @compatible_2ch = true
      @authenticate = DEFAULT_AUTHENTICATE
      @auto_create_board = false
      @board_secret_hash = SecureRandom.hex(64)
      @max_boards_count = 2
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

    ##################################################
    # Quota(容量制限)
    ##################################################
    # モデル内でinstance_evalで特異メソッドを参照させるの嫌だなっておもったので、
    # 変更するときはコントローラを継承してnew, createメソッドで作るモデルを変更してもらうことにする
    # もしくはFormModelでのカウントを制限する
    # def quota_board_within_limit(&block)
    #   @quota_board_within_limit = block if block
    #   @quota_board_within_limit || DEFAULT_QUOTA_BOARD_WITHIN
    # end
  end
end
