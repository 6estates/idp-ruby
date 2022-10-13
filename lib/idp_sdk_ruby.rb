#idp-sdk-ruby.rb
# -*- coding: UTF-8 -*-

require 'rest_client'
require 'json'
require_relative 'idp_sdk_ruby/version'

module IdpSdkRuby
    class FileType
        def bank_statement
            return 'CBKS'
        end
        def invoice
            return 'CINV'
        end
        def cheque
            return 'CHQ'
        end
        def credit_bureau_singapore
            return 'CBS'
        end
        def receipt
            return 'RCPT'
        end
        def payslip
            return 'PS'
        end
        def packing_list
            return 'PL'
        end
        def bill_of_lading
            return 'BL'
        end
        def air_waybill
            return 'AWBL'
        end
        def kartu_tanda_penduduk
            return 'KTP'
        end
        def hong_kong_annual_return
            return 'HKAR'
        end
        def purchase_order
            return 'PO'
        end
        def delivery_order
            return 'DO'
        end
        def FileType
            return ['CBKS','CINV','CHQ','CBS','RCPT','PS','PL','BL','AWBL','KTP','HKAR','PO','DO']
        end
    end

    class IDPException < StandardError
    end

    class IDPConfigurationException < StandardError
    end

    class Task
        def initialize(json=nil)
            @raw=json
        end

        def task_id
            return @raw['data']
        end

    end

    class TaskResultField
        def initialize(json=nil)
            @raw=json
        end

        def field_code
            return @raw['field_code']
        end

        def field_name
            return @raw['field_name']
        end

        def value
            return @raw['value']
        end

        def type
            return @raw['type']
        end
    end

    class TaskResult
        def initialize(json=nil)
            # puts json
            @raw=json
        end
        def raw
            # puts raw
            return @raw
        end
        def status
            # puts @raw['data']['taskStatus']
            return @raw['data']['taskStatus']
        end
        def fields
            fields=Array.new(0)
            for x in @raw['data']['fields']
                fields[fields.length]=TaskResultField.new(x)
            end
            return fields
        end
    end

    class ExtractionTaskClient
        def initialize(token:nil,region:nil, isOauth:nil)
            @token=token
            @region=region
            @isOauth=isOauth

            if region === 'test'
                region = ''
            else
                region = '-'+region
            end
            @url_post = "https://idp"+region + \
                ".6estates.com/customer/extraction/fields/async"
            @url_get = "https://idp"+region + \
                ".6estates.com/customer/extraction/field/async/result/"
        end

        def create(file:nil, file_type:nil, lang:nil,
            customer:nil, customer_param:nil, callback:nil,
            auto_callback:nil, callback_mode:nil, hitl:nil)
            if FileType.new().FileType.count {|x|x==file_type} == 0
                raise IDPException.new("Invalid file type")
            end
            if file.nil?
                raise IDPException.new("File is required")
            end
            if @isOauth
                headers = {"Authorization"=> @token}
            else
                headers = {"X-ACCESS-TOKEN"=> @token}
            end
            # files = {"file": file}
            data = {'fileType'=> file_type, 'lang'=> lang, 'customer'=> customer,
                    'customerParam'=> customer_param, 'callback'=> callback,
                    'autoCallback'=>auto_callback, 'callbackMode'=> callback_mode,
                    'hitl'=> hitl, "file"=>file}
            data=data.delete_if{|key,value|value.nil?}

            r = JSON.parse(RestClient.post(@url_post, data, headers))
            if r['status']==200
                return Task.new(r)
            end
            raise IDPException.new(r['message'])
        end

        def result(task_id=nil)
            if task_id.nil?
                raise IDPConfigurationException.new('Task ID is required')
            end
            if @isOauth
                headers = {"Authorization"=> @token}
            else
                headers = {"X-ACCESS-TOKEN"=> @token}
            end
            r = JSON.parse(RestClient.get(@url_get+task_id.to_s, headers))

            if r['status']==200
                return TaskResult.new(r)
            end
            raise IDPException.new(r['message'])
        end

        def run_simple_task(file:nil, file_type:nil, poll_interval:3, timeout:600)
            """
                Run simple extraction task 
                :param file: Pdf/image file. Only one file is allowed to be uploaded each time
                :type file: file
                :param file_type: The code of the file type (e.g., CBKS). Please see details of File Type Code.
                :type file_type: FileType
                :param poll_interval: Interval to poll the result from api, in seconds
                :type poll_interval: float
                :param timeout: Timeout in seconds
                :type timeout: float
            """
            ct=timeout/poll_interval
            task = create(file:file, file_type:file_type)
            task_result = result(task.task_id)
            while(task_result.status=='Doing' or task_result.status=='Init')
                if (ct-=1) == 0
                    raise IDPException.new('Task timeout exceeded: {timeout}')
                end
                puts "Task is doing. Please wait."
                sleep(poll_interval)
                task_result = result(task.task_id)
                
                if task_result.status == 'Done'
                    return task_result
                end
            end
            return task_result
        end
    end

    class Client
        def initialize(token:nil,region:nil, isOauth:false)
            if token.nil?
                raise IDPConfigurationException.new('Token is required')
            end
            if ["test", "sea"].count {|x|x==region} == 0
                raise IDPConfigurationException.new(
                    "Region is required and limited in ['test','sea']")
            end

            @token=token
            @region=region
            @isOauth=isOauth
            @extraction_task=ExtractionTaskClient.new(token:token,region:region, isOauth:isOauth)

        end
        def extraction_task
            return @extraction_task
        end
    end
           
    def IdpSdkRuby.oauthutil(region:nil, authorization:nil)
        if authorization.nil?
            raise IDPConfigurationException.new('Authorization is required')
        end
        if ["test", "sea"].count {|x|x==region} == 0
            raise IDPConfigurationException.new(
                    "Region is required and limited in ['test','sea']")
        end
        if region === 'test'
               region = '-onp'
        else
               region = '-'+region
        end
        url_post = "https://oauth"+region + \
                ".6estates.com/oauth/token?grant_type=client_bind"
        
        headers = {"Authorization" => authorization}
  
        r = JSON.parse(RestClient.post(url_post, nil, headers))
        if r['status'] != 200
            raise IDPException.new(r['message'])
            return 
        end

        if r['data']['expired']
            raise IDPException.new("This IDP Authorization is expired, please re-send the request to get new IDP Authorization.")
        end
        return r['data']['value']
    end
end
