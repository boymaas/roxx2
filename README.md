# Roxx

Roxx is a small DSL to render audiofiles using the ecasound audiofile.

## Installation

Add this line to your application's Gemfile:

    gem 'roxx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roxx

## Usage

Using the DSL is pretty straightforward. See the spec in `specs/integration_spec.rb`

### Defining an AudioMix

    @audio_mix, = Roxx::audio_mix do 
      library do
        audio_file :sound_1, :path => 'spec/data/sound_1.mp3'
        audio_file :sound_2, :path => 'spec/data/sound_2.mp3', :offset => 10
        audio_file :sound_3, :path => 'spec/data/sound_3.mp3', 
                             :offset => 10,
                             :duration => 20
      end
      track :voice do
        sound :sound_1, :offset =>  0, :duration => 20
        sound :sound_2, :offset => 0, :duration => 10
        volume 0.2
      end
      track :overtone do
        sound :sound_3
        volume 0.4
      end
    end

### Rendering an AudioMix

Rendering an audio mix is also pretty straight forward. Just pass the returned audio\_mix
and a target path.

    Roxx::ecasound_render(@audio_mix, 'output/target.mp3')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
