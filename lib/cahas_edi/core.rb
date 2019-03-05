module CahasEdi
    require 'faraday'
    require 'json'
    require 'date'

    class Template
        attr_accessor :id,
                        :description
    end

    class Partner
        attr_accessor :id,
                        :name,
                        :intercahnge_id,
                        :interchange_qualifier
    end

    class Message
        attr_accessor :template, 
                        :id, 
                        :partner,
                        :status,
                        :date,
                        :interchange_control_number,
                        :group_control_number,
                        :transaction_control_number,
                        :raw_content
        def content
            if @raw_content
                return @raw_content
            end
            @raw_content = Core.message(@id).content
        end


        def unpack_content cont
        end

        def to_s
            content
        end
    end

    class Core
        @@connection = Faraday.new(:url => 'http://localhost:8080')
        
        def self.status_hash
            {
                0 => "received",
                2 => "send",
                3 => "sent",
                5 => "received but not ack",
                6 => "received and ack",
                7 => "received but ack failed"
            }
        end

        def self.process_partner json_obj
            p = Partner.new
            p.id = json_obj['id']
            p.name = json_obj['name']
            p.intercahnge_id = json_obj['interchange id']
            p.interchange_qualifier = json_obj['interchange qualifier']
            p
        end

        def self.partners
            @@connection.get '/partners'
        end

        def self.partner id
            partner = @@connection.get("/partners/#{id}")
            if partner.status == 200
                self.process_partner JSON.parse(partner.body)
            end
        end

        def self.process_message message
            m = Message.new
            m.raw_content = message['content'] if message['content']
            m.template = self.template message["template id"]
            m.id = message["message id"]
            m.partner = self.partner message["partner id"]
            m.status = self.status_hash[message['status']]
            m.date = DateTime.strptime(message['date'].to_s, '%s')
            m.interchange_control_number = message["interchange control number"]
            m.group_control_number = message["group control number"]
            m.transaction_control_number = message["transaction control number"]
            m
        end

        # If status 200 return array of Message objects
        def self.messages
            begin
                response = @@connection.get '/messages'
            rescue Faraday::ConnectionFailed
                return
            end
            if response.status == 200
                messages = JSON.parse(response.body)
                processed_messages = []
                messages.each do |message|
                    processed_messages.push(self.process_message message)
                end
                processed_messages
            end
        end

        def self.message id
            begin
                response = @@connection.get "/messages/#{id}"
            rescue Faraday::ConnectionFailed
                return
            end
            self.process_message(JSON.parse(response.body))
            
        end

        def self.process_template json_obj
            t = Template.new
            t.id = json_obj["id"]
            t.description = json_obj["description"]
            t
        end

        def self.templates
            @@connection.get '/templates'
        end

        def self.template id
            template = @@connection.get "templates/#{id}"
            if template.status == 200
                self.process_template JSON.parse(template.body)
            end

        end

    end
end