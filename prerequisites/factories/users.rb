FactoryBot.define do
  factory :user do
    transient do
      ident { Gen.serial }
      place do
        [['Clissold House', 'London'], ['Harborne Golf Club', 'Birmingham'],
         ['Wharfedale Grange', 'Leeds'], ['Fifteen Ninety Nine', 'Glasgow'],
         ['Whirlowbrook Hall', 'Sheffield'], ['The Great Victoria Hotel', 'Bradford'],
         ['Sefton Park Hotel', 'Liverpool'], ['Melville Castle', 'Edinburgh'],
         ['The Place Aparthotel', 'Manchester'], ['Trinity Community Arts', 'Bristol']].sample
      end
    end

    email { "u#{ident}@#{Howitzer.mailgun_domain}" }
    password { Howitzer.app_test_pass }
    first_name { "FirstName#{ident}" }
    partner_name { "PartnerName#{ident}" }
    engage_date { rand(10..30).days.ago }
    wedding_date { rand(120..200).days.from_now }
    venue { place[0] }
    location { place[1] }
    guests { rand(3..20) * 10 }
    budget { rand(300) * 10 + 15_000 }

    trait :default do
      initialize_with { User.default || User.new }
    end
  end
end
