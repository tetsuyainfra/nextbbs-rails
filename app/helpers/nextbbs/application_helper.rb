module Nextbbs
  module ApplicationHelper

    # Layoutにページタイトルを送る
    def full_title(page_title = '')
      base_title = Nextbbs.config.bbs_name
      if page_title.empty?
        base_title
      else
        page_title + " | " + base_title
      end
    end

    # 改行を<br>に変換する
    def newline2br(str)
      # htmlエスケープした後、改行コードをbrタグにする
      # 出力するときはraw()関数に投げ込むこと
      h(str).gsub(/\R/, "<br>")
    end

    # Ajax用のredirectスクリプトを返すメソッド
    def ajax_redirect_to(redirect_uri)
      { js: "window.location.replace('#{redirect_uri}');" }
    end

  end
end
