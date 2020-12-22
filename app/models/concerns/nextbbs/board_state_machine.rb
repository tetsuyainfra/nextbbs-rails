module Nextbbs
  module BoardStateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: "status", enum: true do
        state :unpublished, initial: true
        state :published
        state :removed

        event :publish, guards: [:have_publish_grant?] do
          transitions from: :unpublished, to: :published
        end
        event :unpublish, guards: [:have_publish_grant?] do
          transitions from: :published, to: :unpublished
        end

        event :remove, guards: [:have_remove_grant?] do
          transitions from: [:unpublished, :published], to: :removed
        end
      end

      def have_publish_grant?(user)
        Rails.logger.debug("have_publishing_grant? #{owner_id} == #{user.inspect}")
        owner_id == user.id
      end

      def have_remove_grant?(user)
        Rails.logger.debug("have_remove_grant? #{owner_id} == #{user.inspect}")
        # TODO: admin権限の判定
        owner_id == user.id
      end
    end
  end
end
