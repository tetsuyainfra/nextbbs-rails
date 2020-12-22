module Nextbbs
  module CommentStateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: "status", enum: true do
        state :submitted, initial: true
        state :published
        state :rejected
        state :removed

        event :publish, guards: [:have_publish_grant?] do
          transitions from: :submitted, to: :published
        end
        event :reject, guards: [:have_reject_grant?] do
          transitions from: :submitted, to: :rejected
        end
        event :submit, guards: [:have_submit_grant?] do
          transitions from: :rejected, to: :submitted
        end

        event :remove, guards: [:have_remove_grant?] do
          transitions from: [:submitted, :published, :rejected], to: :removed
        end
      end

      def have_publish_grant?(user)
        topic.board.owner_id == user.id
      end

      def have_reject_grant?(user)
        topic.board.owner_id == user.id
      end

      def have_submit_grant?(user)
        owner_id == user.id
      end

      def have_remove_grant?(user)
        topic.board.owner_id == user.id
      end
    end
  end
end
