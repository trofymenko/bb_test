Transform /FACTORY_([A-Z_]+)(\d*)(?:\[\:(.+)\])?/ do |factory, num, property|
  res = FactoryBot.given_by_number(factory.downcase, num)
  res = res.send(property) if property
  res
end

Transform /^([A-Z]+)(\d+)$/ do |name, num|
  Howitzer::Cache.extract(name.downcase, num.to_i)
end

Transform /FUTURE_(\d+)_MONTHS?/ do |num|
  num.to_i.months.from_now
end

Transform /^table:.*$/ do |table|
  raw = table.raw.map do |array|
    array.map do |el|
      data = /FACTORY_(?<factory>[A-Z_]+)(?<num>\d*)(?:\[\:(?<property>.+)\])?/.match(el)
      if data
        res = FactoryBot.given_by_number(data[:factory].downcase, data[:num])
        res = res.send(data[:property]) unless data[:property].blank?
        next(res)
      end
      future_date = /FUTURE_(?<num>\d+)_MONTHS?/.match(el)
      next(el) unless future_date
      future_date[:num].to_i.months.from_now
    end
  end
  location = Cucumber::Core::Ast::Location.of_caller
  ast_table = Cucumber::Core::Ast::DataTable.new(raw, location)
  Cucumber::MultilineArgument::DataTable.new(ast_table)
end
