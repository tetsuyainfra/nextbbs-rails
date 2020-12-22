module Nextbbs
  module CommentsHelper
    def comment_anchor(comment)
      "no_#{comment.no}"
    end

    def showable_comment(comment)
      case comment.status
      when "published"
        OpenStruct.new({
          id: comment.id,
          no: comment.no,
          date: comment.created_at,
          hashid: comment.hashid,
          anchor: comment_anchor(comment),
          cid_path: comment_path(comment),
          email: comment.email ? "mailto:#{comment.email}" : nil,
          name: comment.name.empty? ? "ななしさん" : comment.name,
          body: comment.body,
        })
      when "removed"
        OpenStruct.new({
          id: comment.id,
          no: comment.no,
          date: comment.created_at,
          hashid: comment.hashid,
          anchor: comment_anchor(comment),
          cid_path: comment_path(comment),
          email: :deleted,
          name: "削除済み",
          body: "削除済み",
        })
      when "unpublished", "banned"
        OpenStruct.new({
          id: comment.id,
          no: comment.no,
          date: comment.created_at,
          hashid: comment.hashid,
          anchor: comment_anchor(comment),
          cid_path: comment_path(comment),
          email: :deleted,
          name: "検閲済み",
          body: "検閲済み",
        })
      else
        raise NotImplementedError
      end
    end
  end
end
