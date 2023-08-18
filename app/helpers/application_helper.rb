module ApplicationHelper
  include ActionView::Helpers::NumberHelper
  def ist2(time)
    time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')).to_s.split("IST")[0].split("+")[0].split[1] rescue nil
  end

  def ist3(time)
    time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')).to_s.split("IST")[0].split("+")[0].split[0] rescue nil
  end

  def ist4(time)
    time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata')).strftime("%I:%M:%S %p") rescue nil
  end

  def change_to_inr(amount)
      amount_to_s = amount.to_s.split('.')
      amount_in_str = amount_to_s[0]
      amount_in_decimal = amount_to_s[1].nil? ? 0.0 : ('.' + amount_to_s[1]).to_f

      if (amount_in_str.length < 6)
          return amount.humanize.titleize.to_s.gsub("Point", "Rupees And Point") + (amount_in_decimal > 0 ? " Paise" : " Rupees")
      elsif (amount_in_str.length == 6) || (amount_in_str.length == 7)
          return to_lakhs(amount_in_str, amount_in_decimal).to_s.gsub("Point", "Rupees And Point") + (amount_in_decimal > 0 ? " Paise" : " Rupees")
      elsif (amount_in_str.length == 8) || (amount_in_str.length == 9)
          return to_crores(amount_in_str, amount_in_decimal).to_s.gsub("Point", "Rupees And Point") + (amount_in_decimal > 0 ? " Paise" : " Rupees")
      else
          return amount.humanize.titleize
      end

      rescue
          return amount.humanize.titleize
  end

  def to_lakhs(amount, amount_in_decimal=0.0)
    str = ''
    insert_to = amount.to_s.length == 6 ? 1 : 2
    amount_in_arr = amount.to_s.insert(insert_to, ',').split(',')

    amount_in_arr.each_with_index { |ele, index|
        str << ele.to_i.humanize + ( ele.to_i == 1 ? (' lakh') : (' lakhs') ) if (index == 0)
        str << ', ' + ele.to_i.humanize     if (index != 0 && ele.to_i != 0)
    }
    str << ' and ' + amount_in_decimal.humanize.gsub('zero point', 'point') if (amount_in_decimal != 0.0)

    return str.titleize
  end

  def to_crores(amount, amount_in_decimal=0.0)
      str = ''
      insert_to = amount.to_s.length == 8 ? 1 : 2
      amount_in_arr = amount.to_s.insert(insert_to, ',').split(',')

      amount_in_arr.each_with_index { |ele, index|
          str << ele.to_i.humanize + ( ele.to_i == 1 ? (' crore') : (' crores') ) if (index == 0)
          str << ', ' + to_lakhs(ele.to_i)     if (index != 0 && ele.to_i != 0)
      }
      str << ' and ' + amount_in_decimal.humanize.gsub('zero point', 'point') if (amount_in_decimal != 0.0)

      return str.titleize
  end

    def format_number_with_comma(number=0, precision = 2)
      number = number.round(0) if precision == 0
      number_string = number_with_delimiter(number, separator: '.', delimiter_pattern: /(\d+?)(?=(\d\d)+(\d)(?!\d))/)
      if precision == 0
        number_string = number_string[0..-2] if number_string.ends_with?(".")
      else
        whole_number, decimal_number = number_string.split(".")
        decimal_number = "" if decimal_number.nil?
        if decimal_number.length > precision
          decimal_number = ("0." + decimal_number).to_f.round(precision).to_s.split(".")[-1]
        end
        decimal_number = decimal_number.ljust(precision, "0")
        number_string = whole_number + "." + decimal_number
      end
      return number_string
    end

    def convert_to_lakh_and_crore(amount, precision=2)
      if amount >= 10000000
        crore = (amount.to_f / 10000000).round(precision)
        "#{crore} Cr"
      elsif amount >= 100000
        lakh = (amount.to_f / 100000).round(precision)
        "#{lakh} L"
      elsif amount >= 1000
        th = (amount.to_f / 1000).round(precision)
        "#{th} K"
      else
        amount.to_f.round(2)
      end
    end

    module_function :format_number_with_comma
end
