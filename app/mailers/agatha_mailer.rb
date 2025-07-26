class AgathaMailer < ApplicationMailer  
  layout 'mailer'
  def email
    agatha_email = params[:agatha_email]
    to_email = params[:to_email]
    email_subject = agatha_email.subject
    from_email = "<#{agatha_email.from_email.gsub(/\s+/,'').split(';')[0];}>"
    email_date = Time.now
    email_content_type = "multipart/mixed"
    @body_text = agatha_email.body
    Rails.logger.info("email body text = #{@body_text}");
    if agatha_email.person.html_email
        mail(to: to_email, from: from_email, subject: email_subject, date: email_date, content_type: "text/html") do |format|          
        format.html
        end
    else
        mail(to: to_email, from: from_email, subject: email_subject, date: email_date, content_type: "text/plain") do |format|  
        format.text     
        end
    end
=begin    
      (agatha_email, to_email)
    subject    agatha_email.subject
    recipients to_email
    from       "<#{agatha_email.from_email.gsub(/\s+/,'').split(';')[0];}>"
    sent_on    Time.now    
    content_type "multipart/mixed"
=end


=begin
    part(:content_type => "multipart/alternative") do |a|
      a.part "text/plain" do |p|
        plain_text = render_message("email.text.plain",:body_text => agatha_email.body)
        plain_text   = plain_text.gsub(/&nbsp;/," ")
        plain_text   =  plain_text.gsub(/<br>\s*/i,"\n")
        plain_text   =  plain_text.gsub(/<p\b[^>]*>(.*?)<\/p>/i,"\n" + '\1'+"\n")
        plain_text   =  plain_text.gsub(/<div\b[^>]*>(.*?)<\/div>/i,"\n" + '\1'+"\n")
        plain_text   =  plain_text.gsub(/<([A-z][A-z0-9]*)\b[^>]*>(.*?)<\/\1>/,'\2')
        plain_text   =  plain_text.gsub(/<([A-z][A-z0-9]*)\b[^>]*>(.*?)<\/\1>/,'\2')
        plain_text   =  plain_text.gsub(/<div\b[^>]*>/i,"")
        plain_text   =  plain_text.gsub(/<\/div>/i,"")
        p.body = plain_text
        Rails.logger.debug("plain email is #{p.body}")
      end

      a.part "text/html" do |p|
        p.body = render_message("email.text.html",:body_text => agatha_email.body)
        Rails.logger.debug("html email is #{p.body}")
      end
    end    
=end
=begin
    agatha_email.agatha_files.each do |agatha_file|
      if agatha_file.agatha_data_file_name != nil

  #    attachment  :content_type => agatha_file.agatha_data_content_type,
   #               :body => File.read(agatha_file.agatha_data.path),
  #                :filename =>  agatha_file.agatha_data_file_name
      attachment agatha_file.agatha_data_content_type do |a|
        a.body = File.read(agatha_file.agatha_data.path)
        a.filename = agatha_file.agatha_data_file_name
      end
      end
    end
=end    
  end
end

