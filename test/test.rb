#test.rb
# -*- coding: UTF-8 -*-
require_relative 'idp-sdk-ruby'

c=Client.new(region:"test", token:'QWhPM7Wxqr3xc4dCQFmXhH8xYD8CTq3N41XnvV38OblJQpTw5R9DyKHA0coN5m81')
task_result=c.extraction_task.run_simple_task(file:File.new("/home/guo/src/idp-python-sdk/[UOB]202103_UOB_2222.pdf","rb"), file_type:FileType.new().bank_statement)
task_result_fields=task_result.fields
puts task_result_fields[0].field_name