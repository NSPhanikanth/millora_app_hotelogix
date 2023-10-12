task :send_daily_report => [:environment] do

    report_date = Time.now.to_date - 1.day
    data = ReportsHelper.daily_report(report_date)
    puts "data: #{data}"

    if Rails.env.development?
        filepath = Rails.root.join("public", "reports", "daily_report_#{report_date.strftime("%F").gsub("-", "")}.xlsx").to_s
    else
        filepath = File.join(Rails.root.to_s.split("releases")[0], "shared", "public", "reports", "daily_report_#{report_date.strftime("%F").gsub("-", "")}.xlsx").to_s
    end

    ReportsHelper.create_report(data, filepath, report_date)
    puts "Daily Report File Generated: #{filepath}"
    ReportsMailer.send_report(report_date,filepath).deliver_now
end