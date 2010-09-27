class RemoteResourceLookup
 
  def self.resource_fields_for(a_class)
    fields = nil

    if a_class.respond_to? :columns # it's an ActiveRecord object
      fields = a_class.columns.map {|col| {'name' => col.name, 'type' => col.type}}
    else # ActiveResource object
      remote_resources_config = "config/remote_resources.rb"
      if File.exists?(remote_resources_config)
        serialized_obj = File.read remote_resources_config
        if serialized_obj.empty? # In case file is blank
          raise "Remote resources file is empty (#{remote_resources_config})"
        end
        remote_resources = eval(serialized_obj)
        fields = remote_resources[a_class.name]['fields'].map{|field| {'name' => field.keys.first, 'type' => field.values.first.to_sym}}
      else
        raise "No remote resources file found (#{remote_resources_config})"
      end

      fields
    end
  end
 
end