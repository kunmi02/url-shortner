class Url < ApplicationRecord
  validates :original_url, presence: true

  before_validation :generate_token

  private

  def generate_token
    self.token = TokenGenerator.generate(original_url) if token.nil?
  end
end
