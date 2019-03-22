module CahasEdi
    require 'faraday'
    require 'json'
    require 'ostruct'
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
        def initialize message
            @raw_content = message['content'] if message['content']
            @template = Core.template message["template id"]
            @id = message["message id"]
            @partner = Core.partner message["partner id"]
            @status = Core.status_hash[message['status']]
            @date = DateTime.strptime(message['date'].to_s, '%s')
            @interchange_control_number = message["interchange control number"]
            @group_control_number = message["group control number"]
            @transaction_control_number = message["transaction control number"]
        end
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

    class Invoice < Message
        attr_accessor :raw_invoice, :invoice_id

        def initialize message
            super
            @raw_invoice = message['invoice'] if message['invoice']
            @invoice_id = message['invoice id']
        end

        def invoice
            return @raw_invoice if @raw_invoice
            @raw_invoice = Core.invoice(@id).invoice
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
            begin
                response = @@connection.get '/partners'
            rescue Faraday::ConnectionFailed
                return
            end
            if response.status == 200
                partners = JSON.parse(response.body)
                processed_partners = []
                partners.each do |partner|
                    processed_partners.push(self.process_partner partner)
                end
                processed_partners
            end
        end

        def self.partner id
            partner = @@connection.get("/partners/#{id}")
            if partner.status == 200
                self.process_partner JSON.parse(partner.body)
            end
        end

        def self.process_message message
            m = Message.new message
        end

        # If status 200 return array of Message objects
        def self.messages page=1
            out_messages = OpenStruct.new
            out_messages.pages = 0
            out_messages.content = nil
            out_messages.page = 0
            begin
                response = @@connection.get do |req|
                    req.url '/messages'
                    req.params['page'] = page
                end
            rescue Faraday::ConnectionFailed
                return out_messages
            end
            if response.status == 200
                messages = JSON.parse(response.body)
                processed_messages = []
                messages.each do |message|
                    processed_messages.push(self.process_message message)
                end
                out_messages.pages = response.headers['x-pages'].to_i
                out_messages.page = response.headers['x-page'].to_i
                out_messages.content = processed_messages
                out_messages
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

        def self.process_invoice json_obj
        end

        def self.invoices page=1
            out_invoices = OpenStruct.new
            out_invoices.pages = 0
            out_invoices.content = nil
            out_invoices.page = 0
            begin
                response = @@connection.get do |req|
                    req.url '/invoices'
                    req.params['page'] = page
                end
            rescue Faraday::ConnectionFailed
                return out_invoices
            end
            if response.status == 200
                invoices_obj = JSON.parse(response.body)
                processed_invoices = []
                invoices_obj.each do |invoice_obj|
                    processed_invoices.push(self.process_invoice invoice_obj)
                end
                out_invoices.pages = response.headers['x-pages'].to_i
                out_invoices.page = response.headers['x-page'].to_i
                out_invoices.content = processed_invoices
                out_invoices
            end
        end

        def self.invoice id
            begin
                response = @@connection.get "/invoices/#{id}"
            rescue Faraday::ConnectionFailed
                return
            end
            if response.status == 200
                Invoice.new JSON.parse(response.body)
            end
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