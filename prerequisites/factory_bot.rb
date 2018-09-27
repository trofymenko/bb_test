require 'factory_bot'

FactoryBot.definition_file_paths = [File.join(__dir__, 'factories')]
FactoryBot.find_definitions

module FactoryBot
  def self.given_by_number(factory, num)
    data = Howitzer::Cache.extract(factory, num.to_i)
    return data if data.present?
    Howitzer::Cache.store(factory, num.to_i, build(factory))
  end
end

module Gen
  def self.serial
    Time.now.strftime('%s%L').to_i.to_s(36)[2..-1] + ('a'..'z').to_a.sample(2).join
  end
end
