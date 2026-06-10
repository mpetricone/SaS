namespace :quotes do
  desc "Expire any draft/sent quotes whose expires_at is in the past."
  task expire_due: :environment do
    count = Quote.expire_due!
    puts "Expired #{count} quote(s)."
  end
end
