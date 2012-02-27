module Frange
  module Selectors
    NotHashIncluded = ->(params, input) { !File.readlines(params[:check_hash_file]).include?(input.hash) }
  end
end
