
require 'hydra/derivatives'

Hydra::Derivatives::Processors::Video::Processor.timeout = 10.minutes
Hydra::Derivatives::Processors::Document.timeout = 5.minutes
Hydra::Derivatives::Processors::Audio.timeout = 10.minutes
Hydra::Derivatives::Processors::Image.timeout = 5.minutes
