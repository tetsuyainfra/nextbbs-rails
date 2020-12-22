module Nextbbs
  module TopicStateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: "status", enum: true do
        state :unpublished, initial: true
        state :published
        state :archived
        state :removed

        event :publish, guards: [:have_publish_grant?] do
          transitions from: :unpublished, to: :published
        end
        event :unpublish, guards: [:have_publish_grant?] do
          transitions from: :published, to: :unpublished
        end

        event :archive do
          transitions from: :published, to: :archived
        end

        event :remove, guards: [:have_remove_grant?] do
          transitions from: [:unpublished, :published, :archived], to: :removed
        end
      end

      def have_publish_grant?(user)
        # owner_id == user.id
        board.owner_id == user.id
      end

      def have_remove_grant?(user)
        # owner_id == user.id
        board.owner_id == user.id
      end
    end
  end
end
