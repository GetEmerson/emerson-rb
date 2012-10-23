module Support
  module ResourceHelpers
    def record
      @_record ||= records[0]
    end

    def records(count = 1)
      @_records ||= [].tap do |a|
        count.times { a << OpenStruct.new(:name => Faker::Name.name) }
      end
    end
  end
end
