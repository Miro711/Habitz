class UserSerializer < ActiveModel::Serializer
  
  attributes(
    :id,
    :first_name,
    :last_name,
    :full_name,
    :email,
    :created_at,
    :updated_at
  )

  # has_many :habits
  # has_many :tackled_habits

end
