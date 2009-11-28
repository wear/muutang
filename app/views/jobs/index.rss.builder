xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "shanghaionrails jobs feeds"
    xml.body "Recent jobs from shanghaionrails"
    xml.link jobs_url(:rss)
    
    for job in @jobs
      xml.item do
        xml.company job.company
        xml.position job.position
        xml.salary job.salary
        xml.address job.job_address
        xml.description simple_format(job.desc)
        xml.contact job.contact_name
        xml.contact_email job.contact_email
        xml.pubDate job.created_at.to_s(:rfc822)
        xml.link job_url(job)
        xml.guid job_url(job)
      end
    end
  end
end