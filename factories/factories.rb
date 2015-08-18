FactoryGirl.define do

  factory :user do
    sequence(:full_name) { |n| "#{Faker::Name.name} #{n}" }
    email { Faker::Internet.email(full_name) }
    password { 'trainerjim' }
    password_confirmation { password }
    confirmed_at Date.today

    trait :trainer do
      is_trainer true
    end

    trait :admin do
      is_administrator true
    end
  end

  factory :training do
    sequence(:name) { |n| "#{Faker::Name.name}'s Training #{n}" }
  end

  factory :exercise do
    guidance_type 'manual'

    trait :duration do
      guidance_type 'duration'
    end
  end

  factory :series do
    repeat_count { rand(100) }
    weight { rand(100) }
    rest_time { rand(100) }
  end

  factory :measurement do
    start_time { DateTime.now.ago(rand(180).days) }
    end_time { start_time + rand(180).minutes }
    rating { rand(3) }
    comment { Faker::Lorem.sentence }
  end

  factory :series_execution do
    num_repetitions { rand(100) }
    weight { rand(100) }
    rest_time { rand(100) }
    duration_seconds { rand(300) }
    rating { rand(3) }
  end
end