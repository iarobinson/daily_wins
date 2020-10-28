class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  include FriendlyId
  friendly_id :moniker, use: :slugged
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

   has_and_belongs_to_many :challenges
   has_one_attached :avatar, dependent: :destroy
   has_many :wins, dependent: :destroy

   def thumbnail
     return self.avatar.variant(resize: "150x150!").processed
   end

   enum payment_plan: [:free, :first_class, :partner_class]
   enum visibility: [:only_you, :the_whole_world]

   def win_count_for_the_day hoy
     hoy_formatted = [hoy.month, hoy.day]
     win_count = 0
     self.wins.each do |win|
       if hoy_formatted == [win.created_at.month, win.created_at.day]
         win_count += 1
       end
     end
     win_count
   end
end
