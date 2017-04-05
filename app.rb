require 'alexa_rubykit'
require 'sinatra'
require 'json'

before do
  content_type('application/json')
end

get '/' do
  'Hello World!'
end

post '/' do
  alexa = AlexaRubykit.build_request(JSON.parse(request.body.read.to_s))
  alexa_response = AlexaRubykit::Response.new

  provider = alexa.slots['Provider']['value']

  providers = []
  response = @conn.get "/api/vms?expand=resources&attributes=#{provider}"
  JSON.parse(response.body).to_h['resources'].each do |result|
    providers << result['vendor']
  end

  counts = {}
  providers.group_by(&:itself).each { |k,v| counts[k] = v.length }
  # speach_string = "#{provider} has #{counts[provider.downcase]} VMs running"
  speach_string 'Hello World! I am Alexa.'

  if alexa.type == 'INTENT_REQUEST'
    alexa_response.add_speech(speach_string)
    alexa_response.add_hash_card(title: 'AlringtonRuby', subtitle: "Intent #{alexa.name}")
  end

  if alexa.type =='SESSION_ENDED_REQUEST'
    halt 200
  end

  alexa_response.build_response
end
