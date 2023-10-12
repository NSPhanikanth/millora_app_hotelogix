class ReportsMailer < ApplicationMailer
    default from: "notifications.millora@gmail.com"

    def send_report(report_date, output_file_path)
        recipients = ["usha.rani@millora.com"]
        subject = "Daily Report - #{report_date.strftime("%F")}"
        output_file_name = output_file_path.split("/")[-1]
        attachments[output_file_name] = File.read(output_file_path)
        mail(to: recipients ,bcc: ["phanikanth.nemani@gmail.com", "praveena.thantry@gmail.com"], subject: subject)
    end

end
