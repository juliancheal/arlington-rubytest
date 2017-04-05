require 'alexa_generator'
require 'json'

interaction_model = AlexaGenerator::InteractionModel.build do |model|
  model.add_intent(:ArlingtonRuby) do |intent|
    intent.add_slot(:Names, AlexaGenerator::Slot::SlotType::LITERAL) do |slot|
      slot.add_bindings(*%w(Christophers))
    end

    intent.add_utterance_template('How many {Names} are there?')
  end
end

puts JSON.pretty_generate(interaction_model.intent_schema)

puts interaction_model.sample_utterances(:ArlingtonRuby)
