# This allows us to have deeply nested associations
# for our serialized data that is sent as json
ActiveModelSerializers.config.default_includes = '**'