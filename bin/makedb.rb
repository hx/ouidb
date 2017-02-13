#!/usr/bin/env ruby

require 'ouidb'
require 'ouidb/importer'

Ouidb::Importer.read STDIN
