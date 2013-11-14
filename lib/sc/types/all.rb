%w[
  function
].each do |machine|
  require "sc/types/#{machine}"
end
