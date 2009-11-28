xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "shanghaionrails recommandations feeds"
    xml.body "Recent recommandation items from shanghaionrails"
    xml.link jobs_url(:rss)
    
    for recommandation in @recommandations
      xml.item do    
        xml.user nickname_of(recommandation.user)
        xml.title recommandation.recommand.title
        xml.url recommandation.recommand.url
        xml.pubDate recommandation.recommand.created_at.to_s(:rfc822)
        xml.link recommand_url(recommandation.recommand)
        xml.guid recommandation.recommand.url
      end
    end
  end
end