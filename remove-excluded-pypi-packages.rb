#!/usr/bin/env ruby
# frozen_string_literal: true

# Removes excluded packages from pypi_formula_mappings.json,
# so that they can be vendored back into formulas.
require 'json'
require 'set'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'neatjson', '0.10.5'
end

EXCLUDED_PACKAGES_TO_REMOVE = Set.new(%w[
  click
  dateutil
  markupsafe
  packaging
  psutil
  pygments
  Pygments
  python-dateutil
  pyparsing
  pytz
  PyYAML
  pyyaml
  six
  tabulate
  typing-extensions
  urllib3
])

mappings_file = File.join(
  `brew --prefix`.strip,
  'Library/Taps/homebrew/homebrew-core',
  'pypi_formula_mappings.json'
)

data = JSON.parse(File.read(mappings_file))
data.each do |formula, v|
  set = Set.new(v['exclude_packages'])
  EXCLUDED_PACKAGES_TO_REMOVE.each do |excl|
    set.delete(excl)
  end

  if set.empty?
    data[formula].delete('exclude_packages')
    next
  end

  v['exclude_packages'] = set.to_a
  data[formula]['exclude_packages'] = v['exclude_packages']
end

# TODO: fiddle with neatjson args so that it can
#       keep the same json formatting as the original file,
#       or at least close to it. if not possible, maybe switch
#       to a different JSON formatting gem
File.open(mappings_file, 'w') do |f|
  f.write(JSON.neat_generate(data))
end
