class SendMessageJob

  def performin(transaction, subscribers, message)
    sent_messages = 0
    failed_messages = 0

    puts "duke" + transaction.inspect

    10.times do
      subscribers.each do |subscriber|
        #request = Typhoeus::Request.new("http://smsplus3.route.guru:8080/bulksms/bulksms?username=ngser1&password=abcd1234&type=0&dlr=1&destination=#{subscriber.msisdn}&source=LONACI&message=#{URI.escape(message)}", followlocation: true, method: :get)
        request = Typhoeus::Request.new("http://smsplus3.routesms.com:8080/bulksms/bulksms?username=ngser1&password=abcd1234&type=0&dlr=1&destination=#{subscriber.msisdn}&source=LONACI&message=#{URI.escape(message)}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            result = response.body.strip.split("|") rescue nil
            if result[0] == "1701"
              sent_messages += 1
              transaction.message_logs.create(subscriber_id: subscriber.id, msisdn: subscriber.msisdn, profile_id: subscriber.profile_id, period_id: subscriber.period_id, message: message, status: result[0], message_id: result[2])
            else
              failed_messages += 1
              transaction.message_logs.create(subscriber_id: subscriber.id, msisdn: subscriber.msisdn, profile_id: subscriber.profile_id, period_id: subscriber.period_id, message: message, status: result[0])
            end
          end
        end

        request.run
      end
      transaction.update_attributes(ended_at: DateTime.now, send_messages: sent_messages, failed_messages: failed_messages)
    end
  end
  #handle_asynchronously :performin

end
