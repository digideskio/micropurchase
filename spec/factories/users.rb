FactoryGirl.define do
  sequence(:github_id) { |n| n }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :user do
    duns_number { Faker::Company.duns_number }
    name { Faker::Name.name }
    email
    github_id 123_456
    sam_status :duns_blank
    credit_card_form_url 'https://some-website.com/pay'

    factory :admin_user do
      github_id { Admins.github_ids.first }

      factory :contracting_officer do
        contracting_officer true
      end
    end
  end
end
